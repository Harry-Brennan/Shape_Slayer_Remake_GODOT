class_name Enemy_Director
extends Node

@export var max_points : int = 10
var current_points : int

@export var possible_enemy_types : Array[Enemy_Info] = []

@export var starting_ranges : Array[Vector2]

const enemy_scene : PackedScene = preload("res://Scenes/Enemy.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	reset_points()
	
func reset_points():
	current_points = max_points

func attempt_point_deduction(subtraction : int) -> bool:
	print(subtraction)
	if current_points - subtraction < 0:
		print("NOT ENOUGH POINTS")
		return false
	
	current_points -= subtraction
	return true
	
func point_addition(addition : int):
	current_points += addition

func calculate_enemy_spawn_position() -> Vector2:
	var calculated_position : Vector2
	calculated_position.x = randf_range(starting_ranges[0].x, starting_ranges[1].x)
	calculated_position.y = randf_range(starting_ranges[0].y, starting_ranges[1].y)
	return calculated_position

func spawn_new_enemy():
	var enemy_data_index_selected : int
	if possible_enemy_types.size() > 1:
		enemy_data_index_selected= rng.randi_range(0, possible_enemy_types.size())
	else:
		enemy_data_index_selected = 0
	if attempt_point_deduction(possible_enemy_types[enemy_data_index_selected].enemy_spawn_cost):
		#possible_enemy_types[enemy_data_index_selected].starting_pos = calculate_enemy_spawn_position()
		#print(possible_enemy_types[enemy_data_index_selected].starting_pos)
		#possible_enemy_types[enemy_data_index_selected].starting_rot = atan2(possible_enemy_types[enemy_data_index_selected].starting_pos.y - get_tree().get_first_node_in_group("Player").global_position.y,possible_enemy_types[enemy_data_index_selected].starting_pos.x - get_tree().get_first_node_in_group("Player").global_position.x ) 
		var new_enemy : Enemy = Enemy.new_enemy(possible_enemy_types[enemy_data_index_selected])
		var stored_new_enemy_pos = calculate_enemy_spawn_position()
		new_enemy.global_position = stored_new_enemy_pos
		new_enemy.global_rotation = atan2(stored_new_enemy_pos.y - get_tree().get_first_node_in_group("Player").global_position.y,stored_new_enemy_pos.x - get_tree().get_first_node_in_group("Player").global_position.x ) 
		
		new_enemy.connect("enemy_health_depleted", point_addition.bind(new_enemy.enemys_info.enemy_spawn_cost))
		print("NEW ENEMY CREATED ATTEMPTING TO ADD TO TREE")
		add_child(new_enemy)
