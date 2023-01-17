extends CharacterBody2D


var move_speed: float = 20
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#--- RAYCAST
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_foot_right: RayCast2D = $FootRaycastRight

@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_foot_left: RayCast2D = $FootRaycastLeft


#--- TIMER
@onready var patrol_timer: Timer = $PatrolTimer
@onready var idle_timer: Timer = $IdleTimer

var direction: int
var can_move: bool = true
var is_idle: bool = false

func _ready() -> void:
	randomize()
	direction = get_random_direction()
	patrol_timer.start()


func _physics_process(_delta: float) -> void:
	sprite.flip_h = direction > 0
	
	if not is_idle:
		patrol()
	
	move_and_slide()


func patrol() -> void:
	can_move = is_on_platform()
	sprite.play('RUN')
	
	velocity.x = direction * move_speed


func idle() -> void:
	is_idle = true
	sprite.play('IDLE')
	can_move = false
	
	velocity.x = 0


func get_random_direction () -> int:
	return randi_range(-1, 1)


func change_direction() -> void:
	direction *= -1


func is_on_platform() -> bool:
	# Check the foot
	if raycast_foot_left.is_colliding() and raycast_foot_right.is_colliding():
		return true
	elif not raycast_foot_left.is_colliding() or not raycast_foot_right.is_colliding():
		change_direction()
		return true
	else:
		return false


func _on_patrol_timer_timeout() -> void:
	
	idle_timer.start()
	
	idle()


func _on_idle_timer_timeout() -> void:
	is_idle = false
	
	patrol_timer.start()
	patrol()
	
