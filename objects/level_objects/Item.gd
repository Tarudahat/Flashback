extends Sprite

export var healing_amount:int = 50
export var item_name:String = "Potion"

func _ready():
	texture = load("res://assets/objects/"+item_name+".png")
	match item_name:
		"Orb":
			pass

func add_item(item_name_):
	if item_name_ in Globals.player_node.inventory:
		Globals.player_node.inventory[item_name_]+=1
	else:
		Globals.player_node.inventory[item_name_]=1
	print(Globals.player_node.inventory)

func _on_Area2D_body_entered(body):
	if Globals.is_in_name("Player",body.name):
		match item_name:
			"Potion":
				Globals.player_node.damage(healing_amount*-1,false)
			"Orb":
				add_item("Orb")
		queue_free()

