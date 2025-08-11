@tool
extends StaticBody2D

@export var collision_vectors : Array[Vector2] : get = get_wall_collision_vectors , set = set_wall_collision_vectors

@export var wall_polygon : Polygon2D
@export var wall_collisions : Array[CollisionPolygon2D]

@export var collision_multiplier : float = 1 : set = set_collision_multiplier

func set_collision_multiplier(new_multiplier : float):
	collision_multiplier = new_multiplier
	set_wall_collision_vectors(collision_vectors)

func get_wall_collision_vectors() -> Array[Vector2]:
	return collision_vectors

func set_wall_collision_vectors(new_wall_collisions : Array[Vector2]):
	collision_vectors = new_wall_collisions
	if wall_polygon == null:
		return
	wall_polygon.polygon = collision_vectors
	
	var expanded_collisions : Array[Vector2] = []
	
	for i in range(0, collision_vectors.size()):
		
		var current_expanded = collision_vectors[i] * collision_multiplier
		expanded_collisions.append(current_expanded)
	for j in range(0, wall_collisions.size()):
		wall_collisions[j].polygon = expanded_collisions
	#print("set_wall_collision_vectors called")
	
