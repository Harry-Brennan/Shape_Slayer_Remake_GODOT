extends Camera2D


#@export var player : CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	#print ((player.global_position - position).normalized())
	
	
	#position = lerp(position, player.global_position, delta)
	#if ((player.global_position - position).normalized() >= Vector2(0.5, 0.5)):
		#position = lerp(position, player.global_position, delta)
