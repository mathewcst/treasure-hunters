extends State

@export var move_state: State
@export var jump_state: State

var player: Player

func enter() -> void:
	super.enter()
	
	# AS "default" state, player is not loaded here
	if not player:
		player = entity
	
	player.is_jumping = false


func input(event: InputEvent) -> State:
	if event.is_action_pressed('jump'):
		if player.is_on_floor() or not player.coyote_timer.is_stopped():
			return jump_state
		else:
			return null
	else:
		return null


func physics_process(delta: float) -> State:
	player.apply_gravity(delta)
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)
	
	var direction = player.get_input()
	if direction:
		return move_state
	else:
		return null
	
