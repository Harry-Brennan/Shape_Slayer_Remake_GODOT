class_name Enemy_State_Machine
extends Node

enum enemy_states {Idle, Chasing, Attacking, Dead}
var current_state : enemy_states

@export var enemy_speed := 1500.0
var chasing_attacking_turning_speed = -4

@export var chase_range := 650.0
@export var can_shoot := false
@export var shoot_range := 250.0
@onready var shoot_ref := %Shoot
var required_shooting_angle_percentage : float = 0.65

var rand =  RandomNumberGenerator.new()

@onready var player_ref = get_tree().get_first_node_in_group("Player") 
@onready var parent_ref = get_parent()

@onready var active := true

var idle_wander_timer : Timer = null
var wander_position : Vector2
var rng = RandomNumberGenerator.new()
var enemy_wander_randomness : float = 250
var enemy_wander_speed_percentage : float = 0.65
var idle_wander_update_position_interval : float = 1.5
var idle_turn_speed : float = -0.5

func _ready():
	idle_wander_timer = Timer.new()
	idle_wander_timer.one_shot = true
	idle_wander_timer.wait_time = idle_wander_update_position_interval
	idle_wander_timer.timeout.connect(idle_timer_timeout)
	add_child(idle_wander_timer)


func _process(delta):
	#print(wander_position)
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
	if idle_wander_timer.is_stopped():
		idle_wander_timer.start()
	
	if (parent_ref.global_position - player_ref.global_position).length() < chase_range:
		enter_state(enemy_states["Chasing"])
	
	var direction : Vector2 =  wander_position - parent_ref.global_position
	parent_ref.global_rotation = lerp_angle(parent_ref.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(idle_turn_speed * get_physics_process_delta_time()))
	
	parent_ref.velocity = Vector2(1, 0).rotated(parent_ref.global_rotation) * (enemy_speed * enemy_wander_speed_percentage) * ( 1.0 - exp(-10 * get_physics_process_delta_time()))
	parent_ref.move_and_slide()


func idle_calculate_new_wander_position():
	wander_position.x = player_ref.global_position.x + rng.randf_range(-enemy_wander_randomness, enemy_wander_randomness)
	wander_position.y = player_ref.global_position.y + rng.randf_range(-enemy_wander_randomness, enemy_wander_randomness)

func idle_timer_timeout():
	print("idle timer timedout")
	idle_calculate_new_wander_position()
	if current_state == enemy_states["Idle"]:
		idle_wander_timer.start()

func chasing_loop():
	var direction : Vector2 =  player_ref.global_position - parent_ref.global_position
	if (parent_ref.global_position - player_ref.global_position).length() < 10:
		return
	
	if (parent_ref.global_position - player_ref.global_position).length() < shoot_range:
		enter_state(enemy_states["Attacking"])
		return
	parent_ref.global_rotation = lerp_angle(parent_ref.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(chasing_attacking_turning_speed * get_physics_process_delta_time()))
	
	parent_ref.velocity = Vector2(1, 0).rotated(parent_ref.global_rotation) * enemy_speed * ( 1.0 - exp(-10 * get_physics_process_delta_time()))
	parent_ref.move_and_slide()
	

func attacking_loop():
	if !can_shoot:#!b_shoot:
		enter_state(enemy_states["Chasing"])
		return
	var direction : Vector2 =  player_ref.global_position - parent_ref.global_position
	parent_ref.global_rotation = lerp_angle(parent_ref.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(chasing_attacking_turning_speed * get_physics_process_delta_time()))
	
	if (player_ref.global_position - parent_ref.global_position).length() < shoot_range:
		#print("stopping velocity")
		parent_ref.velocity = parent_ref.velocity.lerp(Vector2.ZERO,  1.0 - exp(-0.5 * get_physics_process_delta_time()))
	else:
		
		parent_ref.velocity = parent_ref.velocity.lerp(Vector2(1, 0).rotated(parent_ref.global_rotation) * enemy_speed * ( 1.0 - exp(-10 * get_physics_process_delta_time())),1.0 - exp(-1 * get_physics_process_delta_time()) )
	
	parent_ref.move_and_slide()
	#print(parent_ref.global_rotation - atan2(direction.y, direction.x))
	if (parent_ref.global_rotation - atan2(direction.y, direction.x)) < required_shooting_angle_percentage:
		shoot_ref.shoot()


func dead_loop():
	#slow down velocity
	#disable collisions
	#start destruction timer
	#vfx on destruction timer complete
	#add to score and re-add points to enemy spawner
	pass
