extends Sprite

export var distination:int = 0#the level it wil bring you to
var player_in_range:bool = false

func _on_Area2D_body_entered(body):
    if Globals.is_in_name("Player",body.name):
        player_in_range=true
        $E.visible=true


func _on_Area2D_body_exited(body):
    if Globals.is_in_name("Player",body.name):
        player_in_range=false
        $E.visible=false		

func _process(_delta):
    if Input.is_action_just_pressed("in_interact") and player_in_range:
        if "Orb" in Globals.player_node.inventory:
            if Globals.player_node.inventory["Orb"]==Globals.current_level.max_orbs:
                print(get_tree().change_scene("res://levels/level_"+str(distination)+".tscn"))
