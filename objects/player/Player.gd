extends Entity

var player_positions:PoolVector3Array#save positions and looking direction
var jumping:bool = false
var jump_velocity:Vector2
var JUMP_POWER:int = 435
var looking_dir:int
var timers:Dictionary = {"rewind_timer":0,"blast_start_timer":0,"blast_timer":0,"no_stick_timer":0,"no_floor_timer":0}
var blast_power:int
var rewinding:bool = false
var rewinded:bool = false
var velocity:Vector2

var inventory:Dictionary = {}
var right_stick:Vector2 = Vector2()
var P:String = ""

var blast = load("res://objects/player/blast.tscn")

func _ready():
    $PlayerUI_canvas/PlayerUI_controle.visible=true
    movement_speed=160
    if Globals.player_node==null:
        Globals.player_node = self
    else:#this is player 2
        Globals.player_node2 = self
        Globals.co_op = true
        position.x+=64
        P="2"
        $AnimatedSprite.play("player_2")
        $PlayerUI_canvas/PlayerUI_controle/HPbar.modulate.g=1.4
        Globals.player_node.get_node("PlayerUI_canvas/PlayerUI_controle/HPbar").modulate = Color(1.0,0.7,1.1,1.0)
        $PlayerUI_canvas/PlayerUI_controle/HPbar.margin_top+=26
    ENTITY_WEIGHT=90
    hp = 1000
    max_hp = hp
    
    $PlayerUI_canvas/PlayerUI_controle/HPbar.max_value=max_hp


func _process(delta):
    #movement
    velocity.x=0

    if Input.is_action_pressed("in_left"+P):
        velocity.x -= 1*movement_speed
        $AnimatedSprite.flip_h=true
        looking_dir=1
    if Input.is_action_pressed("in_right"+P):
        velocity.x += 1*movement_speed
        $AnimatedSprite.flip_h=false
        looking_dir=0

    #jumping and gravity
    if velocity.y<=3500:
        velocity.y += ENTITY_WEIGHT*Globals.gravity*delta
    if (is_on_floor() and Input.is_action_pressed("in_jump"+P)) and (TextBoxHandler.show_text_box_==false or TextBoxHandler.i==-1):
        velocity.y=-JUMP_POWER
    
    #rewinding		
    rewinding=false
    rewinded=false
    if Input.is_action_just_pressed("in_rewind") and OS.get_system_time_secs() >= timers["rewind_timer"]:
        rewinded=true
        player_positions.invert()

    if Input.is_action_just_released("in_rewind"):
        timers["rewind_timer"] = OS.get_system_time_secs()+3
        if player_positions.size()>=1:
            player_positions.resize(0)
        $CollisionPolygon2D.disabled=false
    
    if Input.is_action_pressed("in_rewind") and OS.get_system_time_secs() >= timers["rewind_timer"]:
        rewinding=true
        if player_positions.size()>0:
            position=Vector2(player_positions[0].x,player_positions[0].y)
            damage(1,false)
            match player_positions[0].z:
                0.0:
                    $AnimatedSprite.flip_h=false
                1.0:
                    $AnimatedSprite.flip_h=true
            player_positions.remove(0)
        else:
            timers["rewind_timer"] = OS.get_system_time_secs()+3
    
        $CollisionPolygon2D.disabled=true
    else:
        $CollisionPolygon2D.disabled=false
        velocity = move_and_slide(velocity, Vector2.UP)
        if OS.get_system_time_secs() >= timers["rewind_timer"]:
            player_positions.append(Vector3(position.x,position.y,looking_dir))

    if player_positions.size()>=500:
        player_positions.remove(0)

    $PlayerUI_canvas/PlayerUI_controle/rewind_layer.visible=rewinding
    if rewinding:
        $PlayerUI_canvas/PlayerUI_controle/rewind_layer/main_clock/Sprite.rotate(-0.06)
        $PlayerUI_canvas/PlayerUI_controle/rewind_layer/main_clock/Sprite2.rotate(-0.008)
    else:
        $PlayerUI_canvas/PlayerUI_controle/rewind_UI/Label.visible=false
        if timers["rewind_timer"]-OS.get_system_time_secs()>0:
            $PlayerUI_canvas/PlayerUI_controle/rewind_UI/Label.visible=true
            $PlayerUI_canvas/PlayerUI_controle/rewind_UI/Label.text= str(timers["rewind_timer"]-OS.get_system_time_secs())

    right_stick = Vector2(Input.get_action_strength("in_sh_R"+P) - Input.get_action_strength("in_sh_L"+P),
    Input.get_action_strength("in_sh_D"+P) - Input.get_action_strength("in_sh_U"+P)).clamped(1)

    #BLASTING
    if (OS.get_system_time_msecs() >= timers["blast_timer"]) and (TextBoxHandler.show_text_box_==false or TextBoxHandler.i==-1):
        if Input.is_action_just_pressed("in_shoot"+P):
            timers["blast_start_timer"] =OS.get_system_time_msecs()
            timers["no_stick_timer"]=0
            $staff.visible=true

        if Input.is_action_just_released("in_shoot"+P):
            var new_blast = blast.instance()
            new_blast.dmg = dmg
            new_blast.blast_power = blast_power
            #this beautiful line makes the blasts appear on the end of the staff
            if right_stick==Vector2():
                new_blast.position = (position+$staff.position)+(get_local_mouse_position().normalized()*32)
                new_blast.target_position = get_local_mouse_position()
            else:
                new_blast.target_position = right_stick
                new_blast.position = (position+$staff.position)+(right_stick.normalized()*32)
                
            get_parent().add_child(new_blast)
            damage(blast_power*15,false)
            blast_power=0
            timers["no_stick_timer"] = OS.get_system_time_msecs()+1350
            timers["blast_timer"] = OS.get_system_time_msecs()+200
            timers["blast_start_timer"] = OS.get_system_time_msecs()
        
    if Input.is_action_pressed("in_shoot"+P): 
        if right_stick==Vector2():
            $staff.look_at(get_local_mouse_position()*500)
        else:
            $staff.look_at(right_stick.normalized()*5000)
        blast_power = 1
        $staff/staff_light.energy=1
        $staff/Particles2D.scale=Vector2(1,1)
        $staff/Particles2D.speed_scale=1
        if OS.get_system_time_msecs() >= timers["blast_start_timer"]+750:
            blast_power = 2
            $staff/staff_light.energy=2
            $staff/Particles2D.scale=Vector2(1.5,1.5)
            $staff/Particles2D.speed_scale=1.2
        if OS.get_system_time_msecs() >= timers["blast_start_timer"]+1750:
            blast_power = 4
            $staff/staff_light.energy=2.5
            $staff/Particles2D.scale=Vector2(1.7,1.7)
            $staff/Particles2D.speed_scale=1.4
    else:
        $staff/staff_light.energy=1
        $staff/Particles2D.scale=Vector2(1,1)
        $staff/Particles2D.speed_scale=1
        if timers["no_stick_timer"]>0:
            if OS.get_system_time_msecs() >= timers["no_stick_timer"]:
                $staff.visible=false
                timers["no_stick_timer"]=OS.get_system_time_msecs()
                        
    
    match looking_dir:
        0:
            $staff.position = Vector2(17,0)
        1:
            $staff.position = Vector2(-17,0)

    #update hp-bar
    $PlayerUI_canvas/PlayerUI_controle/HPbar.value = hp
    $PlayerUI_canvas/PlayerUI_controle/HPbar/HPlabel.text= str(hp)+"/"+str(max_hp)

    #co-op cam
    if Globals.co_op:
        $Camera2D.position = (Globals.player_node.position+Globals.player_node2.position)/2-Globals.player_node2.position
        $Camera2D.zoom = Vector2(1,1)+Vector2(1,1)*((abs(Globals.player_node.position.x-position.x)+abs(Globals.player_node.position.y-position.y))/1250)

