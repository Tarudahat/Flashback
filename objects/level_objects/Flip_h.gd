extends Sprite
var a=0
func _process(delta):
	a+=delta
	if a>=0.2:
		flip_h=Globals.switch_bool(flip_h)
		a=0
