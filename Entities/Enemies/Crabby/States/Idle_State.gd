extends State

@export var patrol_state: State

var crabby: Crabby

func enter() -> void:
	super.enter()

	if not crabby:
		crabby = entity

	crabby.idle_timer.start()
	crabby.is_idle = true


func physics_process(_delta: float) -> State:
	crabby.velocity.x = 0

	if crabby.idle_timer.time_left <= 0.5:
		return patrol_state
	else:
		return null
