extends State

@export var idle_state: State

var player: Player

func physics_process(delta: float) -> State:
	return idle_state
