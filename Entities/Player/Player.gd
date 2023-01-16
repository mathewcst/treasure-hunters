class_name Player
extends CharacterBody2D


@export_group('Movement')
@export var move_speed = 150.0
@export var jump_velocity = -350.0


#--- STATE MACHINE
@onready var state_machine: StateMachine = $StateMachine
@onready var jump_state: State = $StateMachine/Jump

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# TODO : move animations to animation_player
@onready var animation_player = sprite
@onready var state_label: Label = $Label


#--- HEALTH
@onready var health_component: HealthComponent = $HealthComponent


#--- JUMP
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBuffer

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


#--- MOVEMENT
var can_move: bool = true
var last_direction: float = 0

#--- DAMAGE
var current_health: int = 0

#---- JUMP
var is_grounded: bool = true
var was_on_floor: bool = false

var is_jumping: bool = false
var is_falling: bool = false

var has_presssed_jump: bool = false

func _ready() -> void:
	EventBus.singal_player_ready(self)
	
	EventBus.camera_changing_room.connect(_on_Camera_Chage_Start)
	EventBus.camera_change_room_completed.connect(_on_Camera_Chage_Finished)
	
	InputHelper.device_changed.connect(_on_Input_Device_Changed)
	
	current_health = health_component.current_health
	
	state_machine.init(self)
	

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	state_label.text = state_machine.current_state.name
	
	move_and_slide()
	animation()


func _input(event: InputEvent) -> void:
	state_machine.input(event)


func apply_gravity(delta: float) -> void:
	if not is_on_floor() and coyote_timer.is_stopped():
		velocity.y += gravity * delta
	
	# --- JUMP BUFFER
	if is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		state_machine.change_state(jump_state)


func get_input() -> float:
	return Input.get_axis("move_left", "move_right")


func jump() -> void:
	state_machine.change_state(jump_state)


func take_damage() -> void:
	Engine.set_time_scale(0.2)
	
	GameManager.camera.shake()
	
	sprite.play('HIT')
	await get_tree().create_timer(0.05).timeout
	Engine.set_time_scale(1)
	


func animation() -> void:
	# Flip sprite if moving left
	sprite.flip_h = last_direction < 0
	
	# Screen transition
	if not can_move:
		sprite.stop()



#############
# SIGNALS
############
func _on_Camera_Chage_Start(_new_room: Vector2) -> void:
	can_move = false


func _on_Camera_Chage_Finished(_new_room: Vector2) -> void:
	await get_tree().create_timer(0.5).timeout
	can_move = true


func _on_Input_Device_Changed(_device: String, _device_index: int) -> void:
	pass
	# TODO: when using PS4 controller, prints both 'keyboard' and 'playstatin'
	#print(device)


func _on_health_component_on_death() -> void:
	get_tree().reload_current_scene()


func _on_health_component_health_changed(new_health: int) -> void:
	if new_health < current_health:
		take_damage()

