class_name Enemy_State_Machine
extends Node

enum enemy_states {Idle, Chasing, Attacking, Dead}
var current_state : enemy_states

@export var enemy_speed := 750.0

@export var chase_range := 500.0
@export var can_shoot := false
@export var shoot_range := 350.0
@onready var shoot_ref := %Shoot

var rand =  RandomNumberGenerator.new()

@onready var player_ref = get_tree().get_first_node_in_group("Player") 
@onready var parent_ref = get_parent()

@onready var active := true
#tst
func _process(delta):
	#print(current_state)
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
	if (parent_ref.global_position - player_ref.global_position).length() < chase_range:
		enter_state(1)
	pass

func chasing_loop():
	var direction : Vector2 =  player_ref.global_position - parent_ref.global_position
	if (parent_ref.global_position - player_ref.global_position).length() < 10:
		return
	
	if (parent_ref.global_position - player_ref.global_position).length() < shoot_range:
		enter_state(2)
		return
	parent_ref.global_rotation = lerp_angle(parent_ref.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(-0.5 * get_physics_process_delta_time()))
	
	parent_ref.velocity = Vector2(1, 0).rotated(parent_ref.global_rotation) * enemy_speed * ( 1.0 - exp(-10 * get_physics_process_delta_time()))
	parent_ref.move_and_slide()
	

func attacking_loop():
	if !can_shoot:#!b_shoot:
		enter_state(1)
		return
	var direction : Vector2 =  player_ref.global_position - parent_ref.global_position
	parent_ref.global_rotation = lerp_angle(parent_ref.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(-0.5 * get_physics_process_delta_time()))
	
	if (player_ref.global_position - parent_ref.global_position).length() < shoot_range:
		#print("stopping velocity")
		parent_ref.velocity = parent_ref.velocity.lerp(Vector2.ZERO,  1.0 - exp(-0.5 * get_physics_process_delta_time()))
	else:
		
		parent_ref.velocity = parent_ref.velocity.lerp(Vector2(1, 0).rotated(parent_ref.global_rotation) * enemy_speed * ( 1.0 - exp(-10 * get_physics_process_delta_time())),1.0 - exp(-1 * get_physics_process_delta_time()) )
	
	parent_ref.move_and_slide()
	#print(parent_ref.global_rotation - atan2(direction.y, direction.x))
	if (parent_ref.global_rotation - atan2(direction.y, direction.x)) < 0.65:
		shoot_ref.shoot()


func dead_loop():
	#slow down velocity
	#disable collisions
	#start destruction timer
	#vfx on destruction timer complete
	#add to score and re-add points to enemy spawner
	pass
