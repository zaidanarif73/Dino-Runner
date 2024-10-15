extends Node

const dino_start_post := Vector2(150, 485)
const cam_start_post := Vector2(513, 301)

var score : int
var speed : float
const start_speed : float = 5.0
const max_speed : int = 25
var screen_size : Vector2
var game_running : bool

func _ready():
	screen_size = get_viewport().size
	new_game()

func new_game():
	#reset variable
	score = 0
	show_score()
	#reset node
	$Dino.position = dino_start_post
	$Dino.position = Vector2(0, 0)
	$Camera2D.position = cam_start_post
	$Ground.position = Vector2(0, 0)
	
	#reset HUD
	$HUD.get_node("StartLabel").show()
	
	

#process while game started
func _process(delta):
	if game_running:
		speed = start_speed
		
		#move dino and camera
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		#update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		#update score
		score += speed
		show_score()
	else:
		
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE : "+ str(score/10)
