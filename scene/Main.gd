extends Node

#preload obstacle
var rock_scene = preload("res://scene/Rock.tscn")
var trunk_scene = preload("res://scene/Trunk.tscn")
var sign_scene = preload("res://scene/Sign.tscn")
var obstacle_types := [rock_scene, trunk_scene, sign_scene]
var obstacles : Array

#game variables
const dino_start_post := Vector2(150, 485)
const cam_start_post := Vector2(513, 301)

var score : int
var speed : float
const start_speed : float = 5.0
const max_speed : int = 25
var difficulty : int
var health : int = 5
var screen_size : Vector2
var ground_height : int
var game_running : bool
var game_reset : bool
var last_obs

func _ready():
	screen_size = get_viewport().size
	ground_height = $Ground.get_node("Sprite").texture.get_height()
	$GameOver.get_node("Button").connect("pressed" , self, "new_game")
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
	$MainSound.play()

	#reset HUD
	$HUD.get_node("StartLabel").show()
	
	#hide gameover 
	$GameOver.hide()
	
	#reset pause
	get_tree().paused = false
	
	#reset health bar
	health = 5
	$HUD.get_node("HealthLabel").text =  str(health)
	
	#reset obstacle
	for obs in obstacles:
		obs.queue_free()
		obstacles.clear()

#process while game started
func _process(delta):
	if game_running:
		$HUD.get_node("StartLabel").hide()
		speed = start_speed
		
		#generate obstacles
		generate_obs()
		
		#move dino and camera
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		#update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		#update score
		score += speed
		show_score()
		
		#remove obstacle when off screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		#deteksi space entered
		if Input.is_action_pressed("ui_accept"):
			if health != 0:
				game_running = true
			else:
				yield(get_tree().create_timer(1.0), "timeout")
				new_game()
				
				
				
				
func generate_obs():
	#ground obs
	if obstacles.empty() or last_obs.position.x < score + rand_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instance()
		
		#difficulty of the game obstacle spawn 
		if score/10 < 1000:
			difficulty = 1000
		elif score/10 <3000:
			difficulty = 500
		elif score/10 <5000:
			difficulty = 100
		else:
			difficulty = 50
			
		var obs_x : int = screen_size.x + score + difficulty
		
		last_obs = obs
		obs.position = Vector2(obs_x, 480)
		obs.connect("body_entered", self, "hit_obs")
		add_child(obs)
		obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Dino":
		$Dino.get_node("HitSound").play()
		health -= 1
		$HUD.get_node("HealthLabel").text =  str(health)
		if health == 0:
			game_running = false
			$Dino.get_node("DiedSound").play()
			$MainSound.stop()
			$GameOver.show()
	 

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE : "+ str(score/10)
