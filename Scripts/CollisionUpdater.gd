extends Node2D

@export var polygon_2d : Polygon2D
#@export var collision_polygon_2d : CollisionPolygon2D

@export var collision_polygons_to_update : Array[CollisionPolygon2D]

func _ready():
	for i in collision_polygons_to_update.size():
		if (collision_polygons_to_update[i] == null):
			pass
		else:
			collision_polygons_to_update[i].polygon = polygon_2d.polygon
	#collisions_to_update.polygon = polygon_2d.polygon

