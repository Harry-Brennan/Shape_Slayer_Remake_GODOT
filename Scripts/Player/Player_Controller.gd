extends CharacterBody2D

@export var speed : float
@export var shooting_controller : Node2D
signal player_shoot_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_movement_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func rotate_towards_cursor():
	look_at(get_global_mouse_position())

func shoot_input():
	if (Input.is_action_pressed("Shoot")):
		#print(shooting_controller.global_position, shooting_controller.global_rotation)
		player_shoot_signal.emit(shooting_controller.global_position, shooting_controller.global_rotation)

func _physics_process(delta):
	get_movement_input()
	move_and_slide()
	rotate_towards_cursor()
	shoot_input()




