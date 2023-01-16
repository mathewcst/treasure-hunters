class_name Player
extends CharacterBody2D


@export_group('Movement')
@export var move_speed = 150.0
@export var jump_velocity = -350.0


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBuffer


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

#--- MOVEMENT
var can_move: bool = true


#---- JUMP
var is_grounded: bool = true
var is_jumping: bool = false
var has_presssed_jump: bool = false

func _ready() -> void:
	EventBus.singal_player_ready(self)
	EventBus.camera_changing_room.connect(_on_Camera_Chage_Start)
	EventBus.camera_change_room_completed.connect(_on_Camera_Chage_Finished)
	
	InputHelper.device_changed.connect(_on_Input_Device_Changed)


func _physics_process(delta: float) -> void:
	if can_move:
		apply_gravity(delta)
		move()
	animation()
	


func _input(event: InputEvent) -> void:
	# JUMP
	if event.is_action_pressed('jump'):
		if is_on_floor() or not coyote_timer.is_stopped():
			coyote_timer.stop()
			jump()
		else:
			jump_buffer.start()


func apply_gravity(delta: float) -> void:
	if not is_on_floor() and coyote_timer.is_stopped():
		velocity.y += gravity * delta
	
	if is_jumping and velocity.y >= 0:
		is_jumping = false
	
	# --- JUMP BUFFER
	if is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		jump()


func get_input() -> float:
	return Input.get_axis("move_left", "move_right")


func jump() -> void:
	velocity.y = jump_velocity
	is_jumping = true


func move() -> void:
	var direction: float = get_input()
	var was_on_floor: bool =  is_on_floor()
	
	
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	
	move_and_slide()
	
	# --- COYOTE
	if not is_on_floor() and was_on_floor and not is_jumping:
		coyote_timer.start()
		velocity.y = 0
	
	is_grounded = is_on_floor()
	


func animation() -> void:
	var direction: float = get_input()
	
	if not can_move:
		sprite.stop()
		
	else:
		# Movement Animations
		if direction:
			sprite.play('WALK')
			sprite.flip_h = direction < 0
			
		else:
			sprite.play('IDLE')
		
		# Jumping Animations
		if velocity.y < 0:
			sprite.play('JUMP')
		
		if velocity.y > 0:
			sprite.play('FALL')


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
