extends Node2D
signal died
signal took_dmg
var health
var immune = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 3

func _on_player_hit():
	if (!immune):
		
		health -= 1
		print(health)
		if health == 0 :
			emit_signal("died")
		else:
			emit_signal("took_dmg")
		immune = true
		$ImmunityTimer.start()
		await $ImmunityTimer.timeout
		immune = false
	
	


func _on_player_reset_health():
	
	health = 3
	print(health)


func _on_immunity_timer_timeout():
	pass # Replace with function body.
