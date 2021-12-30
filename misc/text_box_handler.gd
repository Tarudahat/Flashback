extends Node

var text_box:Node 
var msg_sqc_object:Dictionary
var show_text_box_:bool = false
var i=0

func _ready():
    text_box = preload("res://misc/UI/text_box.tscn").instance()
    text_box.layer=69
    add_child(text_box)
        
func show_text_box(name,main_text):
    if text_box!=null:
        text_box.get_node("text_box/name_label").text="||   A    ||"
        text_box.get_node("text_box/name_label").text= text_box.get_node("text_box/name_label").text.replace("A",name)
        text_box.get_node("text_box/main_text").bbcode_text= main_text
        text_box.get_node("text_box").popup()

func show_text_box_sequence(convo):
    i=0
    msg_sqc_object=convo
    show_text_box_ = true
        
func _process(_delta):
    if show_text_box_ and i!=-1:
        show_text_box(msg_sqc_object["convo"][i]["name"],msg_sqc_object["convo"][i]["main_text"])
        if Input.is_action_just_pressed("in_shoot") or Input.is_action_just_pressed("ui_accept"):
            i+=1
        if i>=msg_sqc_object["convo"].size():
            i=0
            text_box.get_node("text_box").visible=false
            show_text_box_ = false

    if i==-1:
        if Input.is_action_just_pressed("in_shoot") or Input.is_action_just_pressed("ui_accept"):
            text_box.get_node("text_box").visible=false
            i=0
