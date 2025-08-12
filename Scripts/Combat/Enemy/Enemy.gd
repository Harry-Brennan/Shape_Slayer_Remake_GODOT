class_name Enemy
extends CharacterBody2D


var enemys_info : Enemy_Info

signal enemy_health_depleted

const enemy_scene : PackedScene = preload("res://Scenes/Enemy.tscn")
#test 
static func new_enemy(passed_enemy_info : Enemy_Info) -> Enemy:
	var new_enemy := enemy_scene.instantiate()
	new_enemy.enemys_info = passed_enemy_info

	return new_enemy

func _on_health_health_depleted():
	enemy_health_depleted.emit()
	queue_free()
