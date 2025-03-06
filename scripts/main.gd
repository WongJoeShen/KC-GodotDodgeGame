extends Node2D

@export var mob_scene: PackedScene
var score = 0
@onready var player = $Player  # Reference to player node

func _on_mob_timer_timeout() -> void:
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var mob = mob_scene.instantiate()
	add_child(mob)
	
	mob.position = mob_spawn_location.global_position
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var speed = randf_range(mob.min_speed, mob.max_speed)
	var velocity = Vector2.RIGHT * speed
	mob.velocity = velocity.rotated(direction)
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$StartTimer.start()
	$HUD.show_message("Get Ready...")
	get_tree().call_group("mob", "queue_free")
	$Player.respawn()
	await $StartTimer.timeout
	$Music.play()
	$ScoreTimer.start()
	$MobTimer.start()
	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$GameOver.play()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
