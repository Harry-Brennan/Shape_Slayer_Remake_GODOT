@tool
extends Area2D

@export var collision_vectors : Array[Vector2] : get = get_wall_collision_vectors , set = set_wall_collision_vectors

@onready var wall_polygon : Polygon2D = %"Wall Polygon" 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in collision_vectors:
		wall_polygon.polygon = collision_vectors
	
	print(wall_polygon.polygons)

func _init():
	for i in collision_vectors:
		wall_polygon.polygon = collision_vectors

func get_wall_collision_vectors() -> Array[Vector2]:
	return collision_vectors

func set_wall_collision_vectors(new_wall_collisions : Array[Vector2]):
	collision_vectors = new_wall_collisions
	print("set_wall_collision_vectors called")
	
