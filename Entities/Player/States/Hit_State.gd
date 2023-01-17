extends State

@export var idle_state: State


var player: Player
var camera: Camera2D

func enter() -> void:
	super.enter()
	camera = GameManager.camera
	
	player.make_invulnerable(true)
	


func physics_process(_delta: float) -> State:
	camera.shake(2.0)
	player.velocity = Vector2.ZERO
	
	Engine.set_time_scale(0.8)
	
	player.animation_player.play('HIT')
	await player.animation_player.animation_finished
	
	Engine.set_time_scale(1)
	
	return idle_state
