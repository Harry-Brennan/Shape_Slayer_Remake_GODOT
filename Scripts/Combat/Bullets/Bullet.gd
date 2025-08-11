extends Area2D
class_name Bullet

var damage : int
var speed : float
var is_enemy_bullet : bool

const enemy_bullet_scene := preload("res://Scenes/Enemy_Bullet.tscn")
const bullet_scene := preload("res://Scenes/Bullet.tscn")
#test
@export var hitbox : HitBox

static func new_bullet(speed : float, damage : int, pos : Vector2, rot : float, is_enemy_bullet: bool) -> Bullet:
	if is_enemy_bullet:
		var new_bullet := enemy_bullet_scene.instantiate()
		new_bullet.speed = speed
		new_bullet.damage = damage
		new_bullet.global_position = pos
		new_bullet.global_rotation = rot
		return new_bullet
	else:
		var new_bullet := bullet_scene.instantiate()
		new_bullet.speed = speed
		new_bullet.damage = damage
		new_bullet.global_position = pos
		new_bullet.global_rotation = rot
		return new_bullet


func _ready():
	#print(damage)
	if hitbox == null:
		return
	hitbox.set_damage(damage)


func _on_area_entered(area):
	#print("bullet area entered")
	#print(area.get_owner().get_groups())
	if area.get_owner().is_in_group("Environment"):
		queue_free()
