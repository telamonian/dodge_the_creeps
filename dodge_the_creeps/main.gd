extends Node

@export var mob_scene: PackedScene
var score


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0

	$Player.start($StartPosition.position)
	$HUD.update_score(score)
	$HUD.show_message("Get ready")

	$StartTimer.start()


func _on_player_hit():
	game_over()

func _on_mob_timer_timeout():
	# new instance of mob scene
	var mob = mob_scene.instantiate()

	# choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# set the ob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI/2

	# set the mob's position to a random location
	mob.position = mob_spawn_location.position

	# add some randomness to the direction
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction

	# choose the velocity for the mob
	var velocity = Vector2(randf_range(150, 250), 0)
	mob.linear_velocity = velocity.rotated(direction)

	# spawn the mob by adding it to the main scene
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_hud_start_game():
	new_game()


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Player.hit.connect(_on_player_hit)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
