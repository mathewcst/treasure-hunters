extends Area2D


@export var target: Node2D

func _ready() -> void:
	assert(target, "Missing Target to fade")



func _on_body_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(target, 'modulate', Color(1,1,1,0), 0.5)


func _on_body_exited(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(target, 'modulate', Color(1,1,1,1), 0.5)
