extends Node2D

var convo = {"convo":[{"name":"A","main_text":"B"}]}
var i = 0

func _ready():
    $TextEdit.text=convo["convo"][0]["name"]
    $TextEdit2.text=convo["convo"][0]["main_text"]

func _process(_delta):
    $Label.text="i:"+str(i)
    if $Button.pressed:
        TextBoxHandler.show_text_box($TextEdit.text,$TextEdit2.text)
    if $Button2.pressed and Input.is_action_just_pressed("in_shoot"):
        i-=1
        if i<=-1:
            i=convo["convo"].size()-1
        $TextEdit.text=convo["convo"][i]["name"]
        $TextEdit2.text=convo["convo"][i]["main_text"]
    if $Button3.pressed and Input.is_action_just_pressed("in_shoot"):
        i+=1
        if i>convo["convo"].size()-1:
            convo["convo"].append({"name":"A","main_text":"B"})
        $TextEdit.text=convo["convo"][i]["name"]
        $TextEdit2.text=convo["convo"][i]["main_text"]

    if $Button4.pressed and Input.is_action_just_pressed("in_shoot"):
        convo["convo"][i]={"name":$TextEdit.text,"main_text":$TextEdit2.text}
        $RichTextLabel.text=str(convo)

    if $Button5.pressed and Input.is_action_just_pressed("in_shoot"):
        JsonHandler.save_dictionary(convo,"res://assets/conversations/"+$LineEdit.text)

    if $Button6.pressed and Input.is_action_just_pressed("in_shoot"):
        convo= JsonHandler.load_dictionary("res://assets/conversations/"+$LineEdit.text)
    
    
            
