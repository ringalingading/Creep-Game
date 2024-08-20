extends Area2D
signal player_died
signal hit
signal reset_health
@export var speed = 400 # How fast the player will move (pixels/sec).
@export var fireball_scene: PackedScene
var screen_size # Size of the game window.
var immune_timer = false
var atk_cooldown = true
func _ready():
	$AttackTimer.timeout.connect(_on_AttackTimer_timeout)
	$Health/ImmunityTimer.timeout.connect(_on_ImmunityTimer_timeout)
	$Health.health_died.connect(_on_health_died)
	get_parent().game_start.connect(_reset_health)
	screen_size = get_viewport_rect().size
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if atk_cooldown:
		#0 is up, 1 is right, 2 is down, 3 is left
		
		if Input.is_action_pressed("attack_up"):
			atk_cooldown = false
			$AttackTimer.start()
			attack(0)
		elif Input.is_action_pressed("attack_right"):
			atk_cooldown = false
			$AttackTimer.start()
			attack(1)
		elif Input.is_action_pressed("attack_down"):
			atk_cooldown = false
			$AttackTimer.start()
			attack(2)
		elif Input.is_action_pressed("attack_left"):
			atk_cooldown = false
			$AttackTimer.start()
			attack(3)

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
func name():
	return "Player"
	
func attack(direction):
	print("FIREBALL!!")
	var fireball = fireball_scene.instantiate()
	#fireball.position = position
	#fireball.position.x += 20
	print(fireball.position)
	if direction == 1:
		fireball.rotation = 0
	elif direction ==0:
		fireball.rotation = PI/2
	elif direction == 3:
		fireball.rotation = PI
	elif direction == 2:
		fireball.rotation = 3*PI/2
	#randomize direction a little
	fireball.rotation += randf_range(-PI / 16, PI / 16)
	var velocity = Vector2(randf_range(200,300) , 0)
	fireball.linear_velocity = velocity.rotated(direction)
	fireball.linear_velocity = velocity.rotated(fireball.rotation)
	add_child(fireball)
	

func _on_body_entered(body):
	#hide() # Player disappears after being hit.
	if (body.name() == "Mob"):
		print("Mob")
		hit.emit()

func _on_health_died():
	immune_timer = false
	print("died")
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("player_died")
	
func _reset_health():
	print("HIhi")
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
func _on_AttackTimer_timeout():
	atk_cooldown = true
	



