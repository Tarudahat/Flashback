extends Sprite

export var healing_amount:int = 50
export(String) var item_name = "Potion"
var max_orbs:int = 0#letting the level node load first is pain

func _ready():
    texture = load("res://assets/objects/"+item_name+".png")
    match item_name:
        "Orb":
            $Light2D.energy=1.4
            $Orb_particle.visible=true
            max_orbs+=1

func add_item(item_name_):
    if item_name_ in Globals.player_node.inventory:
        Globals.player_node.inventory[item_name_]+=1
    else:
        Globals.player_node.inventory[item_name_]=1
    Globals.current_level.max_orbs=max_orbs

func _on_Area2D_body_entered(body):
    if Globals.is_in_name("Player",body.name):
        match item_name:
            "Potion":
                Globals.player_node.damage(healing_amount*-1,false)
            "Orb":
                add_item("Orb")
        queue_free()

