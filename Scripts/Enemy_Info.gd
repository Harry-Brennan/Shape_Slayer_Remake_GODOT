extends Resource
class_name Enemy_Info

enum enemy_names {Melee, Ranged, Ranged_Homing}
@export var enemy_name : enemy_names

@export var max_health : float
@export var move_speed : float
@export var contact_damage : float

@export var b_shoot : bool
@export var shoot_range : float
@export var shoot_damage : int
@export var shoot_rate : float
enum shoot_types {Straight, Homing}
@export var shoot_type : shoot_types

@export var enemy_spawn_cost : int
#var starting_pos : Vector2
#var starting_rot : float
