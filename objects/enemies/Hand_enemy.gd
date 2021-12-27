extends Entity

var bodies:Array
export var grab_power:float = 170
var timer:float

func _ready():
	ENTITY_TYPE=Globals.ENTITY_TYPES.ENEMY

func _process(delta):
	for boi in bodies:
		#have fun future me with reading this shit, tip: "Vector2(0,-50)" is there bc the normal position was in the air making the player unable to jump
		boi.move_and_slide(((position-Vector2(0,-50))-boi.position).normalized()*grab_power*(((boi.position-position).length())/22.5),Vector2.UP)
		if timer>=2.5:
			Globals.player_node.damage(dmg,true)
			timer = 0
			
	timer+=delta

func _on_Area2D_body_entered(body):
	if !body in bodies and !Globals.is_in_name("Hand_enemy", body.name) and Globals.is_in_name("Player", body.name):
		bodies.append(body)
		

func _on_Area2D_body_exited(body):
	bodies.erase(body)
