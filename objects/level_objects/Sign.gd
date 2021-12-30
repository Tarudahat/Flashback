extends Node2D

export(String, MULTILINE) var sign_text = ""

var player_in_range:bool = false


func _on_Area2D_body_entered(body):
	if Globals.is_in_name("Player",body.name):
		player_in_range=true
		$E.visible=true

func _on_Area2D_body_exited(body):
	if Globals.is_in_name("Player",body.name):
		player_in_range=false
		$E.visible=false
		Globals.text_box.get_node("text_box").visible=false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("in_interact"):
		Globals.show_text_box("Sign",sign_text)
	
