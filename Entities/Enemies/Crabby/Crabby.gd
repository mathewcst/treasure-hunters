extends CharacterBody2D
class_name Crabby

@export var move_speed: float = 20.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#--- TIMERS
@onready var patrol_timer: Timer = $PatrolTimer
@onready var idle_timer: Timer = $IdleTimer

# Flip to left
var direction: int = -1
var is_idle: bool = true


func _physics_process(_delta: float) -> void:
	if not is_idle:
		patrol()
		move_and_slide()
		
	else:
		idle()
	


func patrol() -> void:
	animation_player.play('PATROL')
	velocity.x = direction * move_speed


func idle() -> void:
	animation_player.play('IDLE')
	velocity.x = 0


func change_direction() -> void:
	scale.x *= -1
	direction *= -1


func _on_ledge_detection_component_is_on_ledge() -> void:
	change_direction()


func _on_patrol_timer_timeout() -> void:
	is_idle = true
	idle_timer.start()


func _on_idle_timer_timeout() -> void:
	is_idle = false
	patrol_timer.start()
