class_name Bullet_Movement
extends Node

@onready var Bullet_Parent := get_parent()
enum movement_types {straight, homing}
var movement_preset : movement_types
var speed
@export var life_duration := 5.0
var life_duration_timer : Timer

var homing_update_target_timer : Timer
var homing_update_target_interval : float = 1
var homing_target : Node
var homing_turn_speed : float = -5
var homing_range : float = 750
var homing_angle : float = 0.95

func _ready():
	
	movement_preset = Bullet_Parent.bullet_movement_mode
	
	if movement_preset == movement_types["homing"]:
		homing_update_target_timer = Timer.new()
		homing_update_target_timer.wait_time = homing_update_target_interval
		add_child(homing_update_target_timer)
		homing_update_target_timer.start()
		homing_update_target_timer.timeout.connect(update_homing_target)
		update_homing_target()
	
	
	life_duration_timer = Timer.new()
	life_duration_timer.wait_time = life_duration
	add_child(life_duration_timer)
	life_duration_timer.start()
	life_duration_timer.timeout.connect(bullet_lifetime_expire)
	
	speed = Bullet_Parent.bullet_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match movement_preset:
		0:
			Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
			#print("straight movement preset")
			pass
		1:
			if (homing_target == null):
				Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
				return
			if ((homing_target.global_position - Bullet_Parent.position).length() > homing_range):
				if ((Bullet_Parent.rotation - atan2((homing_target.global_position.y - Bullet_Parent.global_position.y), (homing_target.global_position.x - Bullet_Parent.global_position.x))) < homing_angle):
					Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
					return
				else:
					Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
					return
			else:
				
			#look_at(#playerposition)
				var direction : Vector2 = homing_target.global_position - Bullet_Parent.global_position
				Bullet_Parent.global_rotation = lerp_angle(Bullet_Parent.global_rotation, atan2(direction.y,direction.x), 1.0 - exp(homing_turn_speed * get_physics_process_delta_time()))
				Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
			#print("homing movement preset")
			

func update_homing_target():
	if Bullet_Parent.enemy_fired_bullet:
		homing_target = get_tree().get_first_node_in_group("Player") 
	else:
		var all_enemies : Array[Node] = get_tree().get_nodes_in_group("Enemies")
		var closest_enemy : Node
		for i in all_enemies:
			if i == all_enemies[0]:
				closest_enemy = i
			else:
				if (closest_enemy.global_position - get_parent().global_position) > i.global_position - get_parent().global_position:
					closest_enemy = i
		
		homing_target = closest_enemy
	
	homing_update_target_timer.start()
				

func bullet_lifetime_expire():
	Bullet_Parent.queue_free()
