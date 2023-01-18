extends State

@export var jump_state: State
@export var fall_state: State

var player: Player

func enter() -> void:
	player.coyote_timer.start()

func input(event: InputEvent) -> State:
	if event.is_action_pressed('jump'):
		if player.is_on_floor() or not player.coyote_timer.is_stopped():
			player.coyote_timer.stop()
			return jump_state
		else:
			player.jump_buffer.start()
			return fall_state
	else:
		return fall_state

func physics_process(_delta: float) -> State:
	if player.coyote_timer.is_stopped():
		return fall_state
	else:
		return null
