extends State

@export var idle_state: State
@export var fall_state: State

var player: Player
var state_machine: StateMachine

var previous_velocity: Vector2 = Vector2.ZERO

func enter() -> void:
	super.enter()
	previous_velocity = player.velocity
	state_machine = get_parent()
	
	player.can_move = false
	player.velocity = Vector2.ZERO
	
	var previous_state = await await_camera_transition()
	state_machine.change_state(previous_state)
	

func await_camera_transition() -> State:
	await EventBus.camera_change_room_completed
	await get_tree().create_timer(0.5).timeout
	
	player.can_move = true
	player.velocity = previous_velocity
	
	return state_machine.previous_state
