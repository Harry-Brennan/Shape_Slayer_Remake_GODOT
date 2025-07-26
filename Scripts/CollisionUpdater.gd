extends Node2D

@export var polygon_2d : Polygon2D
@export var collision_polygon_2d : CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_polygon_2d.polygon = polygon_2d.polygon

