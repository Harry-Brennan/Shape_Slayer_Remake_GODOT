extends Area2D
class_name Bullet

var damage : int
var speed : float

const bullet_scene : PackedScene = preload("res://Scenes/Bullet.tscn")

@export var hitbox : HitBox

static func new_bullet(speed : float, damage : int, pos : Vector2, rot : float) -> Bullet:
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
