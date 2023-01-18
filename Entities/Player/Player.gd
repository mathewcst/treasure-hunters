class_name Player
extends CharacterBody2D


@export_group('Movement')
@export var move_speed = 150.0
@export var jump_velocity = -350.0


#--- STATE MACHINE
@onready var state_machine: StateMachine = $StateMachine
@onready var jump_state: State = $StateMachine/Jump
@onready var hit_state: State = $StateMachine/Hit
@onready var frozen_state: State = $StateMachine/Frozen

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# TODO : move animations to animation_player
@onready var animation_player = sprite
@onready var state_label: Label = $Label


#--- HEALTH
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_collision: CollisionShape2D = $HurtboxComponent/HurtboxCollision


#--- TIMERS
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBuffer
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer

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
	# BUG: transitioning from FALL to idle it does a mini-jump
	if is_on_floor() and not jump_buffer.is_stopped() and coyote_timer.is_stopped():
		jump_buffer.stop()
		state_machine.change_state(jump_state)


func get_input() -> float:
	return Input.get_axis("move_left", "move_right")


func animation() -> void:
	# Flip sprite if moving left
	sprite.flip_h = last_direction < 0
	
	# Screen transition
	if not can_move:
		sprite.stop()

func make_invulnerable(yes: bool) -> void:
	if yes:
		health_component.can_take_damage = false
		hurtbox_collision.call_deferred('set_disabled', true)
		invulnerability_timer.start()
	else:
		health_component.can_take_damage = true
		hurtbox_collision.call_deferred('set_disabled', false)


#############
# SIGNALS
############
func _on_Camera_Chage_Start(_new_room: Vector2) -> void:
	state_machine.change_state(frozen_state)


func _on_Input_Device_Changed(_device: String, _device_index: int) -> void:
	pass
	# TODO: when using PS4 controller, prints both 'keyboard' and 'playstatin'
	#print(device)


func _on_health_component_on_death() -> void:
	get_tree().reload_current_scene()


func _on_health_component_health_changed(new_health: int) -> void:
	if new_health < current_health and health_component.can_take_damage:
		state_machine.change_state(hit_state)



func _on_invulnerability_timer_timeout() -> void:
	make_invulnerable(false)
