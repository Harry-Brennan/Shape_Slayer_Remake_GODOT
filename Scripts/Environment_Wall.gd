@tool
extends StaticBody2D

@export var collision_vectors : Array[Vector2] : get = get_wall_collision_vectors , set = set_wall_collision_vectors

@export var wall_polygon : Polygon2D

func get_wall_collision_vectors() -> Array[Vector2]:
	return collision_vectors

func set_wall_collision_vectors(new_wall_collisions : Array[Vector2]):
	collision_vectors = new_wall_collisions
	if wall_polygon == null:
		return
	wall_polygon.polygon = collision_vectors
	print("set_wall_collision_vectors called")
	
