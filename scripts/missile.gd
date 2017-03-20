extends KinematicBody2D

var dir = Vector2(0.0, 0.0)
var spd = 0.0
var alive = true
var seek = 0.0
var lifetime = 0.0

func init(height, speed):
	if(randi() % 2 == 0):
		set_pos(Vector2(-50.0, height - randf() * (250 + speed)))
		dir.x = 1.0
	else:
		set_pos(Vector2(850.0, height - randf() * (250 + speed)))
		dir.x = -1.0
		
	dir.y += randf() - 0.5
	spd = 5 + speed * 0.5
	set_rot(dir.angle() + deg2rad(180))
	seek = clamp((randf() - 0.99) + (height * 0.00001), 0.0, 1.0)

func _fixed_process(dt):
	if(alive == true):
		spd += 0.1
		lifetime += dt
		get_node("SamplePlayer2D").play("thrust", 0)
		var player_pos = get_parent().get_node("Player").get_pos()
		var pos = get_pos()
		dir = (((dir.normalized() * (1.0 - seek)) + ((player_pos - pos).normalized() * seek)))
		
		set_rot(dir.angle() + deg2rad(180))
		
		move(dir * spd)
		if (is_colliding() == true) or (get_pos().x < -100) or (get_pos().x > 900) or lifetime > 2.5:
			if (is_colliding() == true) and get_collider() == get_parent().get_node("Player"):
				get_parent().get_node("Player").die()
			get_node("SamplePlayer2D").stop_all()
			get_node("SamplePlayer2D").play("exp", 0)
			get_node("SamplePlayer2D").voice_set_pitch_scale(0, 1)
			alive = false
			get_node("Sprite").hide()
			get_node("FireParticles").set_emitting(false)
			get_node("BlackParticles").set_emitting(false)
			get_node("Explosion").set_emitting(true)
			set_rot(0)
	else:
		if (get_node("Explosion").is_emitting() == false):
			queue_free()

func _ready():
	set_fixed_process(true)