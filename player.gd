extends Area2D
signal game_over
signal hit
signal reset_health
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var immune_timer = false
func _ready():
	
	immune_timer = $Health/ImmunityTimer.timeout.connect(_on_ImmunityTimer_timeout)
	screen_size = get_viewport_rect().size
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	else:
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.animation = "walk"
		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	#hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	# $CollisionShape2D.set_deferred("disabled", true)

func _on_health_died():
	immune_timer = false
	print("died")
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("game_over")
	
func _on_main_reset_health():
	emit_signal("reset_health")

func _on_health_took_dmg():
	print("hi")
	while ( !immune_timer):
		print("HI")
		hide()
		await get_tree().create_timer(0.1).timeout
		show()
		await get_tree().create_timer(0.1).timeout
	immune_timer = false
	show()
func _on_ImmunityTimer_timeout():
	immune_timer = true
