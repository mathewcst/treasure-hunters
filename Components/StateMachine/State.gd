class_name State
extends Node

@export var animation_name: String = ""

var entity: Node2D

func enter() -> void:
	entity.animation_player.play(animation_name)


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func physics_process(_delta: float) -> State:
	return null


func process(_delta: float) -> State:
	return null
