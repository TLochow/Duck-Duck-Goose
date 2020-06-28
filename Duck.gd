extends StaticBody2D

var IsGoose

signal ReachedBottom

var IsSpotted = false
var Speed = 50.0

func _ready():
	Speed = rand_range(25.0, 75.0)
	$AnimationPlayer.playback_speed = range_lerp(Speed, 25.0, 75.0, 0.5, 1.5)
	$AnimationPlayer.play("Walk")

func _process(delta):
	var pos = get_position()
	if IsSpotted:
		pos.y -= Speed * delta * 2.0
		if pos.y < -20.0 and not $Particles2D.emitting:
			queue_free()
	else:
		pos.y += Speed * delta
		if pos.y > 340.0:
			emit_signal("ReachedBottom")
			queue_free()
	set_position(pos)
	
	if IsGoose:
		var colorStrenght = range_lerp(clamp(pos.y, 200.0, 250.0), 200.0, 250.0, 0.0, 1.0)
		$Sprite.modulate = Color(1.0, 1.0 - (colorStrenght * 0.4), 1.0 - colorStrenght, 1.0)

func Spotted():
	if not IsSpotted:
		IsSpotted = true
		$Spotted.visible = true
		$Particles2D.emitting = true
		$AnimationPlayer.playback_speed *= 2.0
		$SpottedSound.play()
