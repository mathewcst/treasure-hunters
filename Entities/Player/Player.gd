class_name Player
extends CharacterBody2D


@export_group('Movement')
@export var move_speed = 150.0
@export var jump_velocity = -450.0


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping: bool = false


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	animation()
	
	move()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('jump') and is_on_floor():
		jump()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func get_input() -> float:
	return Input.get_axis("move_left", "move_right")


func is_grounded() -> bool:
	if is_on_floor():
		is_jumping = false
		return true
	else:
		return false


func jump() -> void:
	is_jumping = true
	velocity.y = jump_velocity

func move() -> void:
	var direction: float = get_input()
	
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	
	move_and_slide()


func animation() -> void:
	var direction: float = get_input()
	
	if direction:
		sprite.play('WALK')
		sprite.flip_h = direction < 0
		
	else:
		sprite.play('IDLE')
	
	
	if velocity.y < 0:
		sprite.play('JUMP')
	
	if velocity.y > 0:
		sprite.play('FALL')
