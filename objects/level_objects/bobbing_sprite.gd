class_name BobbingSprite
extends Sprite

export var bob_max = 32
var bob_position = 0
var add:bool = true

func _process(delta):
	position.y += bob_position*delta
	if add:
		bob_position+=1
	else:
		bob_position-=1
	if bob_position >= bob_max:
		add = false
	if bob_position <= bob_max*-1:
		add = true


