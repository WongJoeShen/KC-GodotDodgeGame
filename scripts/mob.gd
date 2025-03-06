extends Area2D

@export var min_speed: float = 400.0
@export var max_speed: float = 800.0
var velocity = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	# Moves mob based on its velocity
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Deletes mob when it leaves the screen to free up memory
	queue_free()
