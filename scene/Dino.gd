extends KinematicBody2D

var motion = Vector2()
const gravity : int = 4200
const jump_speed : int = -1600
onready var animated_sprite = $AnimatedSprite

	
func _physics_process(delta):
	motion.y += gravity * delta
	
	if is_on_floor():
		if not get_parent().game_running:
			animated_sprite.play("idle")
		else:
			
			if Input.is_action_pressed("ui_accept"):
				motion.y = jump_speed
				animated_sprite.play("jump")
			else:
				animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	motion = move_and_slide(motion, Vector2.UP)
