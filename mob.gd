extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func name():
	return "Mob"


func _on_body_entered(body):
	print("ouch!")
	if body.name() == "Fireball":
		print("ouch2!")
		queue_free()

