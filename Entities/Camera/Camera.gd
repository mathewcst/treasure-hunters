extends Camera2D

@export var follow_target: Node2D

func _physics_process(delta: float) -> void:
	assert(follow_target, "Missing Target to follow")
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'global_position', follow_target.global_position, delta)
