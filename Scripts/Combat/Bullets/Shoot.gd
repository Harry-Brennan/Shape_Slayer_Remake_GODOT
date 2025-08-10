class_name Shoot
extends Node2D 

@export var is_enemy := false

#timers for the fire rate and the ammo regeneration
var shoot_cooldown_timer : Timer = null
var ammo_regen_timer : Timer = null

#temporary rng number generator for bullet speed and damage just wanted to test
var rng = RandomNumberGenerator.new()

#ability to shoot based on other checks
var can_shoot := false

#fire rate
@export var shoot_cooldown_length := .05

#ammo
var ammo := 10
@export var ammo_regen_length := 3.0


func _ready():
	#creating a timer for the fire rate / shoot cooldown and adding
	shoot_cooldown_timer = Timer.new()
	shoot_cooldown_timer.one_shot = true
	shoot_cooldown_timer.wait_time = shoot_cooldown_length
	add_child(shoot_cooldown_timer)
	
	#creating a timer for the ammo regen and adding, connecting to respective event as well for timeout
	ammo_regen_timer = Timer.new()
	ammo_regen_timer.one_shot = true
	ammo_regen_timer.wait_time = ammo_regen_length
	add_child(ammo_regen_timer)
	ammo_regen_timer.timeout.connect(ammo_regen_complete)
	

func _process(delta):
	if (shoot_cooldown_timer.is_stopped() and ammo > 0):
		can_shoot = true
	else:
		can_shoot = false
#test
func shoot():
	if (can_shoot):
		
		var instantiated_bullet : Bullet =  Bullet.new_bullet(500,rng.randf_range(0, 100), global_position, global_rotation, is_enemy)
		get_tree().get_first_node_in_group("Bullets").add_child(instantiated_bullet)
		ammo -= 1
		
		shoot_cooldown_timer.start()
		#shoot_cooldown = true
	else:
		#print("can not shoot")
		if (ammo == 0 and ammo_regen_timer.is_stopped()):
			print("should start ammo regen timer")
			ammo_regen_timer.start()
			#ammo_regen_active = true
		pass

func _on_timer_timeout():
	#shoot_cooldown = false
	pass

func ammo_regen_complete():
	ammo = 10
	#ammo_regen_active = false
	print("ammo_regen_timer timeout")
