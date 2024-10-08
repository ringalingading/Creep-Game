extends Node

@export var mob_scene: PackedScene
var score
signal game_start
signal game_over
var health = 3
func _ready():
	$HUD.start_pressed.connect(new_game)
	$Player.player_died.connect(reset_game)
	randomize()
	new_game()

func new_game():
	emit_signal("game_start")
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
func reset_game():
	emit_signal("game_over")
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_message("Game Over!")
	$HUD/MessageLabel.visible = true
	$GameOverTimer.start()
	await $GameOverTimer.timeout
	$HUD.show_message("Dodge the Creeps!")
	$HUD/StartButton.visible = true
	
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD/MessageLabel.hide()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_game_over_timer_timeout():
	pass # Replace with function body.








