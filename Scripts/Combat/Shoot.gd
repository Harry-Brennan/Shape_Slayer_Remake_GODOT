extends Node

# Called when the node enters the scene tree for the first time.
@export var bullet : PackedScene
@export var shoot_cooldown_timer : Timer
@export var ammo_regen_timer : Timer

var can_shoot : bool

@export var shoot_cooldown_length : float = 0.1
var shoot_cooldown : bool = false

var ammo : int = 10
@export var ammo_regen_length : float = 3
var ammo_regen_active : bool

func _process(delta):
	if (!shoot_cooldown and ammo > 0):
		can_shoot = true
	else:
		can_shoot = false

func shoot(shoot_pos : Vector2, shoot_rot : float):
	if (can_shoot):
		var instantiated_bullet = bullet.instantiate()
		instantiated_bullet.global_position = shoot_pos
		instantiated_bullet.global_rotation = shoot_rot
		add_child(instantiated_bullet)
		ammo -= 1
		shoot_cooldown_timer.wait_time = shoot_cooldown_length
		shoot_cooldown_timer.start()
		shoot_cooldown = true
	else:

		if (ammo == 0 and !ammo_regen_active):
			ammo_regen_timer.wait_time = ammo_regen_length
			ammo_regen_timer.start()
			ammo_regen_active = true

		pass

func _on_player_body_player_shoot_signal(shoot_pos : Vector2, shoot_rot : float):
	shoot(shoot_pos, shoot_rot)

func _on_timer_timeout():
	shoot_cooldown = false

func _on_ammo_regen_timer_timeout():
	ammo = 10
	ammo_regen_active = false
	print("ammo_regen_timer timeout")
