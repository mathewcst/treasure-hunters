extends Camera2D

@export_group('Camera Follow')
@export var follow_target: Node2D

@export_group('Camera Shake')
## The sarting range of possible offsets using random values
@export var random_shake_strength: float = 15.0
## Multiplier for lerping the shake strength to zero
@export var shake_decay_rate: float = 5.0
## How quickly to move through the noise
@export var noise_shake_speed: float = 15.0
## Noise return values in the range of [-1, 1]
## sot his is how much to multiply the returned value by
@export var noise_shake_strength: float = 30.0

@onready var noise = FastNoiseLite.new()

#--- CAMERA FOLLOW
var cur_screen: Vector2 = Vector2(0, 0)
var is_changing_room: bool = false

#--- CAMERA SHAKE
var noise_i: float = 0.0
var shake_strength: float = 0.0
var is_shaking: bool = false



func _ready() -> void:
	randomize()
	assert(follow_target != null, "Missing target to follow")
	
	EventBus.signal_camera_ready(self)
	
	# Set up noise
	noise.seed = randi()
	noise.frequency = 2


func _physics_process(delta: float) -> void:
	var parent_screen: Vector2 = (follow_target.global_position / Global.DOUBLE_SCREEN_SIZE).floor()
	
	if not parent_screen.is_equal_approx(cur_screen):
		update_screen(parent_screen)
	
	# Decay strength from MAX to ZERO
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	offset = get_noise_offset(delta)
	
	
	if is_shaking and floor(shake_strength) == 0:
		is_shaking = false
		EventBus.signal_camera_shake_finished()
	


func update_screen(new_screen: Vector2) -> void:
	EventBus.signal_camera_changing_room(cur_screen)
	
	is_changing_room = true
	
	cur_screen = new_screen
	var new_camera_position = (cur_screen * Global.DOUBLE_SCREEN_SIZE) + Global.SCREEN_SIZE	
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, 'global_position', new_camera_position, 0.5)
	tween.tween_callback(_on_Camera_Changed_Room)


func shake(strength: float = 0) -> void:
	EventBus.signal_camera_shake_started()
	is_shaking = true
	shake_strength = random_shake_strength if strength < 1 else strength


## Shake by noise
func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	
	# Set the x values fo each call to 'get_noise_2d'to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)


## Shake by random float value
func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)


func _on_Camera_Changed_Room() -> void:
	EventBus.signal_camera_change_room_completed(cur_screen)
	is_changing_room = false
