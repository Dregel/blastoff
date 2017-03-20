extends Label

var score

func _fixed_process(dt):
	score = -(get_parent().get_child(1).get_pos().y - 568)
	
	if(score > 275):
		set_pos(Vector2(25, -score + 300))
	else:
		set_pos(Vector2(25, 25))

	set_text(str("Score: ", score))

func _ready():
	set_fixed_process(true)