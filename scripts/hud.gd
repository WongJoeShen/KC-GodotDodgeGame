extends CanvasLayer

signal start_game

func update_score(score):
	# Updates the score display
	$ScoreLabel.text = str(score)

func show_message(text):
	# Displays a message and starts the timer to hide it later
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	# Displays "Game Over" and then resets message to "Dodge Fireballs!"
	show_message("Game Over")
	await $MessageTimer.timeout
	show_message("Dodge Fireballs!")
	await get_tree().create_timer(1).timeout
	$StartButton.show()

func _on_start_button_pressed():
	# Hides the start button and starts the game
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	# Hides the message when the timer runs out
	$MessageLabel.hide()
