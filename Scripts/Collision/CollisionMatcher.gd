@tool
class_name Collision_Matcher
extends Node

@export var polygon_2d : Polygon2D : get = get_polygon_2d, set = set_polygon_2d
#@export var collision_polygon_2d : CollisionPolygon2D

@export var collision_polygons_to_update : Array[CollisionPolygon2D] : get = get_collisions_to_update, set = set_collisions_to_update

@export var collision_matching_multiplier : float = 1 : get = get_collision_matching_multiplier, set = set_collision_matching_multiplier
func get_polygon_2d() -> Polygon2D:
	return polygon_2d

func get_collisions_to_update() -> Array[CollisionPolygon2D]:
	return collision_polygons_to_update

func get_collision_matching_multiplier() -> float:
	return collision_matching_multiplier

func set_polygon_2d(new_polygon : Polygon2D):
	polygon_2d = new_polygon
	update_collisions()
	
func set_collisions_to_update(new_collision_polygons_to_update : Array[CollisionPolygon2D]):
	collision_polygons_to_update = new_collision_polygons_to_update
	update_collisions()

func set_collision_matching_multiplier(new_multiplier : float):
	collision_matching_multiplier = new_multiplier
	#print("SETTING COLLISION MATCHING MULTIPLIER")
	update_collisions()

func update_collisions():
	#print("UPDATING COLLISIONS")
	if polygon_2d == null:
		return
	if collision_matching_multiplier != 1:
		var expanded_collisions : Array[Vector2] = []
		for j in range(0, polygon_2d.polygon.size()):
			var multiplied_polygon = polygon_2d.polygon[j] * collision_matching_multiplier
			expanded_collisions.append(multiplied_polygon)
		
		for k in collision_polygons_to_update.size():
			#print(collision_polygons_to_update[k])
			if (collision_polygons_to_update[k] == null):
				return
			else:
				collision_polygons_to_update[k].polygon = expanded_collisions
		
	else:
		for i in collision_polygons_to_update.size():
			if (collision_polygons_to_update[i] == null):
				return
			else:
				collision_polygons_to_update[i].polygon = polygon_2d.polygon
	#collisions_to_update.polygon = polygon_2d.polygon
