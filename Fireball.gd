extends RigidBody2D

func _ready():
	print("ready!")
	var fire_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(fire_types[randi() % fire_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func name():
	return "Fireball"


func _on_body_entered(body):
	print("Scorch!")
