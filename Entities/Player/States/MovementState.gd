extends State

@export var idle_state: State = null
@export var jump_state: State = null
@export var coyote_state: State = null

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
	player.was_on_floor = player.is_on_floor()
	
	if not player.is_on_floor():
		return coyote_state
	
	if direction:
		player.last_direction = direction
		player.velocity.x = direction * player.move_speed
		return null
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)
		return idle_state
