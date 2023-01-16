class_name StateMachine
extends Node

@export var default_state: State = null

var current_state: State = null

func init(entity: Node2D) -> void:
	for state in get_children():
		state.entity = entity
	
	change_state(default_state)


func change_state(new_state: State) -> void:
	if current_state:
		#Exits can be synchronous, so await
		await current_state.exit()

	current_state = new_state
	current_state.enter()


func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)


func physics_process(delta: float) -> void:
	var new_state = await current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
