extends KinematicBody2D

var dir = Vector2(0.0, -1.0)
var spd = 0.0
var alive = true
var enemySpawnTimer = 0.0
var missile = load("res://scenes/missile.tscn")
var pitch = 1.0

func die():
	alive = false
	get_node("Sprite").hide()
	get_node("FireParticles").set_emitting(false)
	get_node("BlackParticles").set_emitting(false)
	get_node("Explosion").set_emitting(true)
	set_rot(0)
	get_node("SamplePlayer2D").stop_all()
	get_node("SamplePlayer2D").play("exp", 0)
	get_node("SamplePlayer2D").voice_set_pitch_scale(0, 1)
	if(get_pos().y < 300):
		get_node("GameOverText").set_global_pos(Vector2(188, get_pos().y))
	else:
		get_node("GameOverText").set_global_pos(Vector2(188, 300))
		get_node("GameOverText").show()

func _fixed_process(dt):
	if(alive == true):
		pitch += dt * 0.01
		get_node("SamplePlayer2D").play("thrust", 0)
		get_node("SamplePlayer2D").voice_set_pitch_scale(0, pitch)
		enemySpawnTimer += dt
		if(enemySpawnTimer >= 1.0 - clamp((spd * 0.1), 0.0, 0.99)):
			var nm = missile.instance()
			get_parent().add_child(nm)
			nm.init(get_pos().y, spd)
			enemySpawnTimer = 0.0
		spd += 0.25 * dt
		if(Input.is_key_pressed(KEY_LEFT)):
			dir = dir.rotated(deg2rad(180 * dt))
		if(Input.is_key_pressed(KEY_RIGHT)):
			dir = dir.rotated(deg2rad(-180 * dt))
		set_rot(dir.angle() + deg2rad(180))
		move(dir * spd)
		if (is_colliding() == true) or (get_pos().x < 0) or (get_pos().x > 800):
			die()
	else:
		if (Input.is_key_pressed(KEY_SPACE) == true):
			set_pos(Vector2(400, 568))
			dir = Vector2(0.0, -1.0)
			spd = 0.0
			alive = true
			pitch = 1.0
			get_node("Sprite").show()
			get_node("FireParticles").set_emitting(true)
			get_node("BlackParticles").set_emitting(true)
			get_node("GameOverText").hide()

func _ready():
	set_fixed_process(true)