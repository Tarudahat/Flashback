extends Node2D


export(String, MULTILINE) var sign_text = ""
export var use_conv_sqc:bool = false
export(String, FILE) var conv_sqc_path =""
export var npc_name:String = "Sign"
export var visible_npc:bool = true
var conversation:Dictionary
var player_in_range:bool = false

func _ready():
    $Sign_sprite.visible=visible_npc
    if use_conv_sqc:
        conversation=JsonHandler.load_dictionary(conv_sqc_path)

func _on_Area2D_body_entered(body):
    if Globals.is_in_name("Player",body.name):
        player_in_range=true
        $E.visible=true

func _on_Area2D_body_exited(body):
    if Globals.is_in_name("Player",body.name):
        player_in_range=false
        $E.visible=false
        TextBoxHandler.show_text_box_=false
        TextBoxHandler.text_box.get_node("text_box").visible=false

func _process(_delta):
    
    if player_in_range and Input.is_action_just_pressed("in_interact"):
        if use_conv_sqc:
            TextBoxHandler.show_text_box_sequence(conversation)
        else:
            TextBoxHandler.i=-1
            TextBoxHandler.show_text_box(npc_name,sign_text)

    
