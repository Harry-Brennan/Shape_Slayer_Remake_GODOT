class_name HurtBox
extends Area2D

signal received_damage(damage : int)

@onready var health : Health = %Health

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox : HitBox) -> void:
	if hitbox == null:
		pass

	health.health -= hitbox.damage
	received_damage.emit(hitbox.damage)
	print("received damage")
