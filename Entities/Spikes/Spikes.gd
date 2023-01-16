extends StaticBody2D

@export var damage: int = 1

@onready var hitbox_component: Hitbox = $HitboxComponent

func _ready() -> void:
	hitbox_component.damage = damage
