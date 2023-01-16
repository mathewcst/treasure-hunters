extends StateMachine


func init(entity: Node2D) -> void:
	super.init(entity)
	
	for state in get_children():
		state.player = entity
	
