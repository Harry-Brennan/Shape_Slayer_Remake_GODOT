class_name HurtBox
extends Area2D

signal received_damage(damage : int)

@onready var health : Health = %Health

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox : HitBox) -> void:
	if hitbox == null:
		return
	if hitbox.get_parent() == get_parent():
		return

	health.health -= hitbox.damage

	if health.is_player:
		health.set_temporary_invincibility(1)


	#received_damage.emit(hitbox.damage)
	print(get_parent().name, " took ", hitbox.damage, " damage from ", hitbox.get_parent())
