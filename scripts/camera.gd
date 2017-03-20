extends Camera2D

var oldAmp = 0.0

func _fixed_process(dt):
	var amplitude = -(get_parent().get_pos().y)
	
	if(amplitude > oldAmp):
		set_v_offset(((randf() * amplitude * 2) - amplitude) * 0.000005)
		set_h_offset(((randf() * amplitude * 2) - amplitude) * 0.000005)
	else:
		set_v_offset(0)
		set_h_offset(0)

	oldAmp = amplitude

func _ready():
	set_fixed_process(true)