class_name Enemy
extends CharacterBody2D

var contact_damage : float
var b_shoot : bool
var shoot_range : float
var move_speed : float
var shoot_damage : int

const enemy_scene : PackedScene = preload("res://Scenes/Enemy.tscn")
#test ssss
static func new_enemy(contact_dmg : float, can_shoot : bool, shoot_range : float, move_speed : float, shoot_damage : int) -> Enemy:
	var new_enemy := enemy_scene.instantiate()
	new_enemy.contact_damage = contact_dmg
	new_enemy.b_shot = can_shoot
	new_enemy.shoot_range = shoot_range
	new_enemy.move_speed = move_speed
	new_enemy.shoot_damage = shoot_damage

	return new_enemy

func _on_health_health_depleted():
	queue_free()
