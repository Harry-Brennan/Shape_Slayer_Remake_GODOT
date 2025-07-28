class_name Bullet_Movement
extends Node

@onready var Bullet_Parent := get_parent()
enum movement_types {straight, homing}
@export var movement_preset : movement_types
var speed
@export var life_duration := 5.0
var life_duration_timer : Timer

func _ready():
	life_duration_timer = Timer.new()
	life_duration_timer.wait_time = life_duration
	add_child(life_duration_timer)
	life_duration_timer.start()
	life_duration_timer.timeout.connect(bullet_lifetime_expire)
	
	speed = Bullet_Parent.speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match movement_preset:
		0:
			Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
			#print("straight movement preset")
			pass
		1:
			#look_at(#playerposition)
			Bullet_Parent.position += Bullet_Parent.transform.x * speed * delta
			#print("homing movement preset")
			pass

func bullet_lifetime_expire():
	Bullet_Parent.queue_free()
