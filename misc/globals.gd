extends Node

enum ENTITY_TYPES{ENEMY,OBJECT,PLAYER}
var gravity:float = 13
var player_node:Node
var current_level:Node
var text_box:Node 

func _ready():
	text_box = preload("res://misc/UI/text_box.tscn").instance()
	text_box.layer=69
	add_child(text_box)
		
func show_text_box(name,main_text):
	if text_box!=null:
		print(text_box.get_children().size(),text_box.name)
		text_box.get_node("text_box/name_label").text= text_box.get_node("text_box/name_label").text.replace("A",name)
		text_box.get_node("text_box/main_text").bbcode_text= main_text
		text_box.get_node("text_box").popup()
		
func switch_bool(input_bool):
	match input_bool:
		true:
			return false
		false:
			return true

#needs improvements
func is_in_name(search_name,node_name):
	if search_name in node_name:
		if search_name+"_" in node_name:
			return false
		else:
			return true
