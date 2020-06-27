extends Node2D

var DUCKSCENE = preload("res://Duck.tscn")
var GOOSESCENE = preload("res://Goose.tscn")

var Score = 0.0
var GameOver = false

var RestartTimer = 2.0

func _ready():
	Score = 0.0
	GameOver = false
	RestartTimer = 2.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif GameOver and event.is_action_pressed("mouse_click") and RestartTimer < 0.0:
		SceneChanger.ChangeScene("res://Main.tscn")

func _process(delta):
	if not GameOver:
		$SpawnTimer.wait_time = max($SpawnTimer.wait_time - delta * 0.01, 0.2)
		$Detection.set_position(.get_global_mouse_position())
		
		if Input.is_action_just_pressed("mouse_click") and not GameOver:
			var bodies = $Detection.get_overlapping_bodies()
			var foundGoose = false
			for body in bodies:
				if body.IsGoose:
					foundGoose = true
					body.Spotted()
			if not foundGoose and bodies.size() > 0:
				Score = max(Score - 10, 0)
				$UI/Points.text = "Score: " + str(Score)
				bodies[0].Spotted()
	else:
		RestartTimer -= delta

func _on_SpawnTimer_timeout():
	if randi() % 10 == 0:
		var goose = GOOSESCENE.instance()
		goose.IsGoose = true
		goose.set_position(Vector2(rand_range(8.0, 172.0), -10.0))
		goose.connect("ReachedBottom", self, "GooseAtBottom")
		$DucksAndGooses.add_child(goose)
	else:
		var duck = DUCKSCENE.instance()
		duck.IsGoose = false
		duck.set_position(Vector2(rand_range(8.0, 172.0), -10.0))
		duck.connect("ReachedBottom", self, "DuckAtBottom")
		$DucksAndGooses.add_child(duck)

func GooseAtBottom():
	if not GameOver:
		GameOver = true
		$UI/Points.visible = false
		$UI/GameOver/Points.text = "Score: " + str(Score)
		$UI/GameOver.visible = true
		$GooseLaughing.play()

func DuckAtBottom():
	if not GameOver:
		Score += 1
		$UI/Points.text = "Score: " + str(Score)
		if not $Duck.playing:
			$Duck.play()
