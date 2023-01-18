extends RayCast2D


signal is_on_ledge

func _physics_process(_delta: float) -> void:
	if not is_colliding():
		emit_signal('is_on_ledge')
