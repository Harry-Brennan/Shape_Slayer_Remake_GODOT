class_name Health
extends Node

#signals for when the max health is changed, health is changed and finally when the health gets to 0
signal max_health_changed(diff : int)
signal health_changed(diff : int)
signal health_depleted

#max health and health
@export var max_health := 100 : get = get_max_health, set = set_max_health
@export var health := max_health : get = get_health, set = set_health

#invincibility
@export var invincible := false : get = get_invincible, set = set_invincible
var invincible_timer : Timer = null

@export var is_player := false

#getter and setter for health
func get_health() -> int:
	return health

func set_health(value : int):
	#if the new health is going to be less then current health and we are invincible then don't change health
	if value < health and invincible:
		return
	
	#clamp the passed new health between 0 and the max health
	var clamped_health = clampi(value, 0, max_health)
	
	#if the new health is not going to be the same as the current health then
	if clamped_health != health:
		#get the change in health
		var difference = clamped_health - health
		#update health
		health = clamped_health
		#emit signal for the health changed with the amount of health changed
		health_changed.emit(difference)
	
	#if health is 0 then emit that the health is now depleted
	if health == 0:
		health_depleted.emit()

#getter and setter for max health
func get_max_health() -> int:
	return max_health
	
func set_max_health(value : int):
	var clamped_max_health = 1 if value <=0 else value
	if !clamped_max_health == max_health:
		var difference = clamped_max_health - max_health
		max_health = value
		max_health_changed.emit(difference)
		
		if health > max_health:
			health = max_health

#getter and setter for invincibility
func get_invincible() -> bool:
	return invincible
	
func set_invincible(value : bool):
	invincible = value

#temporary invincibility with a time passed for the amount of time for invincibility
func set_temporary_invincibility(time : float):
	#creating the invincible timer
	print("Invincibility activated for ", time)
	if invincible_timer == null:
		invincible_timer = Timer.new()
		invincible_timer.one_shot = true
		add_child(invincible_timer)
	
	#check if it already connected and if so disconnect it
	if invincible_timer.timeout.is_connected(set_invincible):
		invincible_timer.timeout.disconnect(set_invincible)
	
	#set the wait time for the invincible timer
	invincible_timer.set_wait_time(time)
	#connect the timeout of the timer to be setting invicible 
	#to false using the set_invincible func and binding false
	invincible_timer.timeout.connect(set_invincible.bind(false))
	
	#set invincible true and then start the timer
	invincible = true
	invincible_timer.start()
