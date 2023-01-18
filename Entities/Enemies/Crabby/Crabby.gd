extends CharacterBody2D
class_name Crabby


var move_speed: float = 20
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#--- STATE MACHINE
@onready var state_machine: StateMachine = $StateMachine


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
	
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)

	sprite.flip_h = direction > 0
	
	move_and_slide()



func get_random_direction () -> int:
	return randi_range(-1, 1)


func change_direction() -> void:
	direction *= -1
