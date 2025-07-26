extends Area2D

enum movement_types {straight, homing}
@export var movement_preset : movement_types
@export var speed : float = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match movement_preset:
		0:
			position += transform.x * speed * delta
			#print("straight movement preset")
			pass
		1:
			#look_at(#playerposition)
			position += transform.x * speed * delta
			#print("homing movement preset")
			pass

