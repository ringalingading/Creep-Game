extends CanvasLayer

signal start_pressed
var currHealth
func _ready():
	get_parent().game_start.connect(reset_HUD)
	get_parent().get_node("Player").hit.connect(_on_hit)
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$StartButton.show()
	$MessageLabel.text = "Dodge the\nCreeps!"
	$MessageLabel.show()
func reset_HUD():
	currHealth = get_parent().get_node("Player/Health").return_health()
	$HealthLabel.text = str(currHealth)
func update_score(score):
	$ScoreLabel.text = str(score)
func _on_MessageTimer_timeout():
	$MessageLabel.hide()
func _on_start_button_pressed():
	$StartButton.hide()
	emit_signal("start_pressed")
func _on_hit():
	await get_tree().create_timer(0.1).timeout
	currHealth = get_parent().get_node("Player/Health").return_health()
	$HealthLabel.text = str(currHealth)
