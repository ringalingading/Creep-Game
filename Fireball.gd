extends Area2D
@export var speed = 500 # How fast the fireball will move (pixels/sec).
@export var direction = Vector2.ZERO
func _ready():
	$AnimatedSprite2D.play()
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity = direction.normalized() * speed
	position += velocity * delta
	#$AnimatedSprite2D.look_at(position + direction.normalized())
	var angle = atan2(velocity.y, velocity.x)
	$AnimatedSprite2D.rotation = angle + 3*PI/2



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	print(area.name)
	print("Hi2")


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name() == "Mob" :
		print("Gotya!")
		body.queue_free()
