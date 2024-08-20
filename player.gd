extends Area2D
signal player_died
signal hit
signal reset_health
@export var speed = 400 # How fast the player will move (pixels/sec).
@export var fireball_scene: PackedScene
var screen_size # Size of the game window.
var immune_timer = false
var atk_timer = true
func _ready():
	
	$Health/ImmunityTimer.timeout.connect(_on_ImmunityTimer_timeout)
	$Health.health_died.connect(_on_health_died)
	get_parent().game_start.connect(_reset_health)
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
	if atk_timer:
		if Input.is_action_pressed("atk_right"):
			atk_timer = false
			attack(1,0)
			$AtkTimer.start()
		elif Input.is_action_pressed("atk_left"):
			atk_timer = false
			attack(-1,0)
			$AtkTimer.start()
		elif Input.is_action_pressed("atk_down"):
			atk_timer = false
			attack(0,-1)
			$AtkTimer.start()
		elif Input.is_action_pressed("atk_up"):
			atk_timer = false
			attack(0,1)
			$AtkTimer.start()

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
func attack(x,y):
	print("Fire!")
	var fireball = fireball_scene.instantiate()
	fireball.direction.x = x
	fireball.direction.y = -1* y
	fireball.position = position
	get_parent().add_child(fireball)	
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
	emit_signal("player_died")
	
func _reset_health():
	emit_signal("reset_health")

func _on_health_took_dmg():
	
	while ( !immune_timer):
		
		hide()
		await get_tree().create_timer(0.1).timeout
		show()
		await get_tree().create_timer(0.1).timeout
	immune_timer = false
	show()
func _on_ImmunityTimer_timeout():
	immune_timer = true


func _on_atk_timer_timeout():
	atk_timer = true
