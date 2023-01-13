extends Camera2D

@export var follow_target: Node2D

func _process(_delta: float) -> void:
	assert(follow_target, "Missing Target to follow")
	global_position = follow_target.global_position
