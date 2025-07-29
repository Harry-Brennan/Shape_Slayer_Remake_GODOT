class_name Dash
extends Node

var dash_cooldown_timer : Timer
var dash_cooldown_length := 1.0

var dash_direction : Vector2
var dashing := false
var dash_timer : Timer

var dash_distance := 0
var dash_speed := 5000.0

var non_dash_input_direction : Vector2

@onready var health_comp : Health = %Health

func _ready():
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(dash_cooldown_over)
	add_child(dash_cooldown_timer)

	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.timeout.connect(dash_over)
	add_child(dash_timer)

func do_dash(passed_dash_distance : float, passed_dash_cooldown_length : float):
	
	if dash_cooldown_timer.is_stopped() and !dashing:
		
		dash_cooldown_length = passed_dash_cooldown_length
		dash_distance = passed_dash_distance
		
		health_comp.set_temporary_invincibility((dash_distance / dash_speed) + 0.5)
		#dash functionality
		dash_direction = Input.get_vector("Left", "Right", "Up", "Down")
		if !dash_direction:
			#print (get_parent().transform.x)
			non_dash_input_direction = get_parent().transform.x
		
		dashing = true
		#print(dash_distance / dash_speed)
		dash_timer.wait_time = dash_distance / dash_speed
		dash_timer.start()
		

func _physics_process(delta):
	if !dashing:
		return
	if !dash_direction:
		#print("Dash Direction is null")
		get_parent().velocity = non_dash_input_direction * dash_distance
	else:
		#print("Dash Direction isnt null")
		get_parent().velocity = dash_direction * dash_distance
	
	get_parent().move_and_slide()
	
func dash_over():
	dashing = false
	dash_cooldown_timer.wait_time = dash_cooldown_length
	dash_cooldown_timer.start()

func dash_cooldown_over():
	print("dash cooldown over")
	pass
