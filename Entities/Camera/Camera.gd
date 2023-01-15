extends Camera2D

var player: CharacterBody2D
var cur_screen: Vector2 = Vector2(0, 0)

var is_changing_room: bool = false

func _ready() -> void:
	EventBus.player_ready.connect(_on_Player_Ready)


func _physics_process(_delta: float) -> void:
	var parent_screen: Vector2 = (player.global_position / Global.DOUBLE_SCREEN_SIZE).floor()
	
	if not parent_screen.is_equal_approx(cur_screen):
		update_screen(parent_screen)



func update_screen(new_screen: Vector2) -> void:
	EventBus.signal_camera_changing_room(cur_screen)
	
	is_changing_room = true
	
	cur_screen = new_screen
	var new_camera_position = (cur_screen * Global.DOUBLE_SCREEN_SIZE) + Global.SCREEN_SIZE	
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, 'global_position', new_camera_position, 0.5)
	tween.tween_callback(_on_Camera_Changed_Room)


func _on_Player_Ready(_player: CharacterBody2D) -> void:
	player = _player


func _on_Camera_Changed_Room() -> void:
	EventBus.signal_camera_change_room_completed(cur_screen)
	is_changing_room = false
