class_name Enemy_State_Machine
extends Node

enum enemy_states {Idle, Chasing, Attacking, Dead}
var current_state : enemy_states

var rand =  RandomNumberGenerator.new()

@onready var player_ref = get_tree().get_first_node_in_group("Player") 
@onready var parent_ref = get_parent()

@onready var active := true

func _process(delta):
	if active:
		match current_state:
			0:
				#print("Current state idle")
				idle_loop()
				pass
			1:
				#print("current state chasing")
				chasing_loop()
				pass
			2:
				#print("current state attacking")
				attacking_loop()
				pass
			3:
				#print("current state dead")
				dead_loop()
				pass


func enter_state(state_to_enter : enemy_states):
	print("Entering :", state_to_enter, " from ", current_state)
	current_state = state_to_enter
	pass

func idle_loop():
	if (parent_ref.global_position - player_ref.global_position).length() < 500:
		enter_state(1)
	pass

func chasing_loop():
	var direction : Vector2 =  player_ref.global_position - parent_ref.global_position
	if (parent_ref.global_position - player_ref.global_position).length() < 10:
		return
	
	parent_ref.global_rotation = lerp_angle(parent_ref.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(-0.5 * get_physics_process_delta_time()))
	
	parent_ref.velocity = Vector2(1, 0).rotated(parent_ref.global_rotation) * 750 * ( 1.0 - exp(-10 * get_physics_process_delta_time()))
	parent_ref.move_and_slide()
	

func attacking_loop():
	if 1:#!b_shoot:
		enter_state(1)
		return

func dead_loop():
	pass
