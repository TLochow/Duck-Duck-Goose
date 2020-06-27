extends Control

var StartTimer = 2.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("mouse_click") and StartTimer < 0.0:
		SceneChanger.ChangeScene("res://Main.tscn")

func _process(delta):
	StartTimer -= delta
