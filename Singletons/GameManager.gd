extends Node


func _ready() -> void:
	# Window Resize
	get_tree().get_root().size_changed.connect(_on_Size_Changed)


func _on_Size_Changed() -> void:
	var new_size: Vector2 = DisplayServer.window_get_size(0)
	EventBus.signal_window_size_changed(new_size)
