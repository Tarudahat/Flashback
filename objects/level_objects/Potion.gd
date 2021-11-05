extends Sprite

export var healing_amount:int = 50

func _on_Area2D_body_entered(body):
	if Globals.is_in_name("Player",body.name):
		Globals.player_node.hp += healing_amount
		queue_free()

