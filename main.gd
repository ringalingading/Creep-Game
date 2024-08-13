extends Node

@export var Mob: PackedScene
var score

func _ready():
	randomize()

func new_game():
	print("hi")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD.show_game_over()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_mob_timer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Choose the velocity.
	mob.set_linear_velocity(Vector2(randf_range(mob.min_speed, mob.max_speed), 0).rotated(direction))

func _on_player_hit():
	pass # Replace with function body.


func _on_hud_start_game():
	print("hi1")
	new_game()
