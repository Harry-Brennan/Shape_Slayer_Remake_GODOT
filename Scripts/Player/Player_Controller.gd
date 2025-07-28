extends CharacterBody2D

@export var speed : float
@onready var shoot_comp : Shoot = %Shoot
@onready var dash_comp : Dash = %Dash
@export var curve : Curve

var movement_time := 0.0

var movement_smoothing_amount := -5
var rotation_smoothing_amount := -15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_movement_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	if dash_comp.dash_timer != null:
		if dash_comp.dash_timer.is_stopped():
			var target_velocity = input_direction * speed
			velocity = velocity.lerp(target_velocity, 1.0 - exp(movement_smoothing_amount * get_physics_process_delta_time()))
	else:
		var target_velocity = input_direction * speed
		velocity = velocity.lerp(target_velocity, 1.0 - exp(movement_smoothing_amount * get_physics_process_delta_time()))

func rotate_towards_cursor():
	
	var direction : Vector2 = (get_global_mouse_position() - global_position)
	global_rotation = lerp_angle(global_rotation, atan2(direction.y,direction.x), 1.0 - exp(rotation_smoothing_amount * get_physics_process_delta_time()))

	#look_at(get_global_mouse_position())

func shoot_input():
	if (Input.is_action_pressed("Shoot")):
		shoot_comp.shoot()

func dash_input():
	if Input.is_action_just_pressed("Dash"):
		dash_comp.do_dash(1000, 0.5)
	
func _physics_process(delta):

	get_movement_input()
	move_and_slide()
	rotate_towards_cursor()
	shoot_input()
	dash_input()

	#print(velocity)
