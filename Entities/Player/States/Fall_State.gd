extends State

@export var idle_state: State
@export var jump_state: State

var player: Player

func input(event: InputEvent) -> State:
	if event.is_action_pressed('jump'):
		if player.is_on_floor() or not player.coyote_timer.is_stopped():
			return jump_state
		else:
			player.jump_buffer.start()
			return null
	else:
		return null

func physics_process(delta: float) -> State:
	player.apply_gravity(delta)
	
	var direction: float = player.get_input()
	
	if direction:
		player.last_direction = direction
		player.velocity.x = direction * player.move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)
	
	
	if player.is_on_floor():
		return idle_state
	else:
		return null


func exit() -> void:
	super.exit()
	player.animation_player.play('GROUND')
