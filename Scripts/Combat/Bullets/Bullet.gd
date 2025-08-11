extends Area2D
class_name Bullet

var bullet_damage : int
var bullet_speed : float
var is_enemy_bullet : bool

enum movement_types {straight, homing}
var bullet_movement_mode : movement_types

const enemy_bullet_scene := preload("res://Scenes/Enemy_Bullet.tscn")
const bullet_scene := preload("res://Scenes/Bullet.tscn")

var enemy_fired_bullet : bool

@export var hitbox : HitBox

static func new_bullet(speed : float, damage : int, pos : Vector2, rot : float, is_enemy_bullet: bool, movement_mode : movement_types) -> Bullet:
	if is_enemy_bullet:
		var new_bullet := enemy_bullet_scene.instantiate()
		new_bullet.bullet_speed = speed
		new_bullet.bullet_damage = damage
		new_bullet.bullet_movement_mode = movement_mode
		new_bullet.enemy_fired_bullet = is_enemy_bullet
		new_bullet.global_position = pos
		new_bullet.global_rotation = rot
		
		return new_bullet
	else:
		var new_bullet := bullet_scene.instantiate()
		new_bullet.bullet_speed = speed
		new_bullet.bullet_damage = damage
		new_bullet.bullet_movement_mode = movement_mode
		new_bullet.enemy_fired_bullet = is_enemy_bullet
		new_bullet.global_position = pos
		new_bullet.global_rotation = rot
		
		return new_bullet


func _ready():
	#print(damage)
	if hitbox == null:
		return
	hitbox.set_damage(bullet_damage)


func _on_area_entered(area):
	#print("bullet area entered")
	#print(area.get_owner().get_groups())
	if area.get_owner().is_in_group("Environment"):
		queue_free()
