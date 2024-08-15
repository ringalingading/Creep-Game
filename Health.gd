extends Node2D
signal health_died
signal took_dmg
var health
var immune = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().reset_health.connect(_reset_health)
	health = 3

func _on_player_hit():
	if (!immune):
		
		health -= 1
		print(health)
		if health == 0 :
			emit_signal("health_died")
		else:
			emit_signal("took_dmg")
			immune = true
			$ImmunityTimer.start()
			await $ImmunityTimer.timeout
			immune = false
		
	
	
func return_health() -> int:
	return health

func _reset_health():
	
	health = 3


func _on_immunity_timer_timeout():
	pass # Replace with function body.
