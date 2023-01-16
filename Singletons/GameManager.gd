extends Node

var player: Player
var camera: Camera2D

func _ready() -> void:
	# Window Resize
	get_tree().get_root().size_changed.connect(_on_Size_Changed)
	
	EventBus.camera_ready.connect(_on_Camera_Ready)
	EventBus.player_ready.connect(_on_Player_Ready)


func _on_Size_Changed() -> void:
	var new_size: Vector2 = DisplayServer.window_get_size(0)
	EventBus.signal_window_size_changed(new_size)


func _on_Camera_Ready(_camera: Camera2D) -> void:
	camera = _camera


func _on_Player_Ready(_player: Player) -> void:
	player = _player
