extends Node

############
# PLAYER
############
signal player_ready(player: CharacterBody2D)
func singal_player_ready(player: CharacterBody2D) -> void:
	emit_signal('player_ready', player)


############
# CAMERA
############
signal camera_changing_room(new_room: Vector2)
func signal_camera_changing_room(new_room: Vector2) -> void:
	emit_signal('camera_changing_room', new_room)


signal camera_change_room_completed(new_room: Vector2)
func signal_camera_change_room_completed(new_room: Vector2) -> void:
	emit_signal('camera_change_room_completed', new_room)



############
# GAME WINDOW
############
signal window_size_changed(new_size: Vector2)
func signal_window_size_changed(new_size: Vector2) -> void:
	emit_signal('window_size_changed', new_size)
