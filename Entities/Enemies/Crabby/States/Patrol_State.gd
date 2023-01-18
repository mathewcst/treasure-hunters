extends State

@export var idle_state: State

var crabby: Crabby
var direction_changed: bool = false

func enter() -> void:
	super.enter()

	if not crabby:
		crabby = entity
	
	crabby.patrol_timer.start()
	crabby.is_idle = false


func physics_process(_delta: float) -> State:
	var found_ledge = not crabby.raycast_foot_left.is_colliding() or not crabby.raycast_foot_right.is_colliding()
	
	var last_direction: int = 0

	#--- CHECK LEDGE
	if found_ledge:

		if not direction_changed:

			direction_changed = true
			last_direction = crabby.direction
			
			crabby.change_direction()

		elif direction_changed and crabby.direction != last_direction:
			direction_changed = false
	

	crabby.velocity.x = crabby.direction * crabby.move_speed


	if crabby.patrol_timer.time_left <= 0:
		return idle_state
	else:
		return null
