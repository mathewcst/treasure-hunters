extends State

@export var fall_state: State

var player: Player


func enter() -> void:
	super.enter()
	
	if not player.is_jumping:
		player.coyote_timer.stop()
		player.is_jumping = true
		player.velocity.y = player.jump_velocity


func physics_process(delta: float) -> State:
	player.apply_gravity(delta)
	
	var direction: float = player.get_input()
	if direction:
		player.last_direction = direction
		player.velocity.x = direction * player.move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)
	
	if player.velocity.y >= 0:
		return fall_state
	else:
		return null

