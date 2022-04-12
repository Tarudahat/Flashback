extends Sprite
var a=0
export var timer_thing:float = 0.2
export var flip_v_:bool = false
func _process(delta):
    a+=delta
    if a>=timer_thing:
        if flip_v_:
            flip_v=Globals.switch_bool(flip_v)
        else:
            flip_h=Globals.switch_bool(flip_h)
        a=0
