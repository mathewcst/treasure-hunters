class_name Hurtbox
extends Area2D

@export var health_component: HealthComponent = null

func _ready() -> void:
	assert(health_component != null, "HealthComponent is required")


func _on_area_entered(area:Area2D) -> void:
	var hitbox: Hitbox = area
	health_component.take_damage(hitbox.damage)
