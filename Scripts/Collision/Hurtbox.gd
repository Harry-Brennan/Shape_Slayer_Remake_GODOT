class_name HurtBox
extends Area2D

#signal received_damage(damage : int)

@onready var health : Health = %Health

var overlapping_hitboxes : Array[HitBox]

var continous_dmg_timer : Timer = null
var dmg_timers : Array[Timer]
#test
func _ready():
	connect("area_entered",_on_area_entered)
	connect("area_exited",_on_area_exited)

func _on_area_entered(hitbox : Area2D) -> void:
	print(hitbox.get_parent())
	if hitbox == null:
		return
	if hitbox.get_parent() == get_parent():
		return
	if hitbox is not HitBox:
		return
	
	overlapping_hitboxes.append(hitbox)
	
	continous_dmg_timer = Timer.new()
	continous_dmg_timer.wait_time = 2
	add_child(continous_dmg_timer)
	dmg_timers.append(continous_dmg_timer)
	continous_dmg_timer.start()
	continous_dmg_timer.timeout.connect(_dmg_timer_timeout.bind(continous_dmg_timer))

	health.health -= hitbox.damage

	if health.is_player:
		health.set_temporary_invincibility(1)

	#received_damage.emit(hitbox.damage)
	print(get_parent().name, " took ", hitbox.damage, " damage from ", hitbox.get_parent().get_parent())
	
	if hitbox.get_parent().is_in_group("Bullets"):
		hitbox.get_parent().queue_free()


func _on_area_exited(hitbox) -> void:
	if hitbox is not HitBox:
		return
	dmg_timers[overlapping_hitboxes.find(hitbox)].stop()
	dmg_timers.remove_at(overlapping_hitboxes.find(hitbox))
	overlapping_hitboxes.remove_at(overlapping_hitboxes.find(hitbox))
	
func _dmg_timer_timeout(timer_timedout : Timer):
	print("dmg timer timed out")
	health.health -= overlapping_hitboxes[dmg_timers.find(timer_timedout)].damage
