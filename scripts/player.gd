extends CharacterBody2D

signal dead

@export var speed: float = 400.0
var health = 1
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Exit early if player is dead (prevents unnecessary processing)
	if health == 0:
		return  

	# Replaced multiple `if` statements with `Input.get_axis()` for cleaner movement handling
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	# If moving, normalize direction and apply velocity
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")

	move_and_slide()

	# Used `position.clamp()` instead of separate `clamp()` calls for efficiency
	position = position.clamp(Vector2.ZERO, screen_size)

	# Checks if hitbox is overlapping an enemy and calls `hit()`
	if $hitbox.has_overlapping_areas():
		hit()

func hit():
	health -= 1
	$AnimatedSprite2D.play("hit")
	await $AnimatedSprite2D.animation_finished
	hide()
	await get_tree().create_timer(0.2).timeout
	dead.emit()

func respawn():
	# Restores player position and health on respawn
	global_position = Vector2(580, 320)
	health = 1
	show()
