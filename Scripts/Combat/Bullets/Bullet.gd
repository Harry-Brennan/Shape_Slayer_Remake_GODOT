extends Area2D
class_name Bullet

var damage : int
var speed : float

const bullet_scene : PackedScene = preload("res://Scenes/Bullet.tscn")


@onready var hitbox : HitBox = %HitBox

static func new_bullet(speed : float, damage : int) -> Bullet:
	var new_bullet := bullet_scene.instantiate()
	new_bullet.speed = speed
	new_bullet.damage = damage
	return new_bullet

func _ready():
	print(damage)
	hitbox.set_damage(damage)
