class_name HealthComponent
extends Node2D

signal health_changed(new_health: int)
signal on_death()

@export var max_health: int = 4
@export var current_health: int = 4 : 
	set(value):
		current_health = clamp(value, 0, max_health)
	get:
		return current_health

@export var can_take_damage: bool = true


func take_damage(amount: int) -> void:
	if can_take_damage:
		current_health -= amount
		emit_signal('health_changed', current_health)

		if current_health <= 0:
			emit_signal('on_death')


func heal(amount: int) -> void:
	current_health += amount
	emit_signal('health_changed', current_health)
