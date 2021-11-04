extends Entity

var player_positions:PoolVector3Array#save positions and looking direction
var velocity:Vector2
var jumping:bool = false
var jump_velocity:Vector2
var MAXJUMPY:int = 775
var looking_dir:int
var timers:Dictionary = {"rewind_timer":0,"blast_start_timer":0,"blast_timer":0,"no_stick_timer":0,"no_floor_timer":0}
var blast_power:int

var blast = load("res://objects/player/blast.tscn")

func _ready():
	ENTITY_TYPE = Globals.ENTITY_TYPES.PLAYER
	$PlayerUI_canvas/PlayerUI_controle.visible=true
	$PlayerUI_canvas/PlayerUI_controle/HPbar.max_value=max_hp
	movement_speed=150

func _process(delta):
	#movement
	velocity = Vector2(0,0)

	if Input.is_action_pressed("in_left"):
		velocity.x -= 1
		$AnimatedSprite.flip_h=true
		looking_dir=1
	if Input.is_action_pressed("in_right"):
		velocity.x += 1
		$AnimatedSprite.flip_h=false
		looking_dir=0

	velocity=velocity.normalized()*movement_speed
	#jumping and gravity (super trash)
	if is_on_floor():
		if !jumping:
			if Input.is_action_pressed("in_jump"):
				jump_velocity.y = MAXJUMPY
				jumping = true
		else:
			jumping=false
		timers["no_floor_timer"]=0
	else:
		timers["no_floor_timer"]+=delta*25
		velocity.y += ENTITY_WEIGHT*4+timers["no_floor_timer"]

	if jumping:
		if is_on_ceiling():
			jump_velocity.y -= 250
		velocity.y -= jump_velocity.y
		jump_velocity.y -= 26
		if jump_velocity.y<0:
			jumping=false	
			jump_velocity.y=0				
	
	#rewinding		
	if Input.is_action_just_pressed("in_rewind"):
		player_positions.invert()
	if Input.is_action_just_released("in_rewind"):
		timers["rewind_timer"] = OS.get_system_time_secs()+3
		if player_positions.size()>=1:
			player_positions.resize(0)
		$CollisionShape2D.disabled=false
	
	if Input.is_action_pressed("in_rewind") and OS.get_system_time_secs() >= timers["rewind_timer"]:
		if player_positions.size()>0:
			position=Vector2(player_positions[0].x,player_positions[0].y)
			damage(1)
			match player_positions[0].z:
				0.0:
					$AnimatedSprite.flip_h=false
				1.0:
					$AnimatedSprite.flip_h=true
			player_positions.remove(0)
		else:
			timers["rewind_timer"] = OS.get_system_time_secs()+3
	
		$CollisionShape2D.disabled=true
	else:
		$CollisionShape2D.disabled=false
		velocity = move_and_slide(velocity, Vector2.UP)
		if OS.get_system_time_secs() >= timers["rewind_timer"]:
			player_positions.append(Vector3(position.x,position.y,looking_dir))

	if player_positions.size()>=500:
		player_positions.remove(0)

	#BLASTING
	if OS.get_system_time_msecs() >= timers["blast_timer"]:
		if Input.is_action_just_pressed("in_shoot"):
			timers["blast_start_timer"] =OS.get_system_time_msecs()
			timers["no_stick_timer"]=0
			$staff.visible=true

		if Input.is_action_just_released("in_shoot"):
			var new_blast = blast.instance()
			new_blast.dmg = dmg
			new_blast.blast_power = blast_power
			#this beautiful line makes the blasts appear on the end of the staff
			new_blast.position = (position+$staff.position)+(get_local_mouse_position().normalized()*32)
			new_blast.target_position = get_local_mouse_position()
			get_parent().add_child(new_blast)
			damage(blast_power*15)
			timers["no_stick_timer"] = OS.get_system_time_msecs()+1350
			timers["blast_timer"] = OS.get_system_time_msecs()+200
			timers["blast_start_timer"] = OS.get_system_time_msecs()
		
	if Input.is_action_pressed("in_shoot"): 
		$staff.look_at(get_local_mouse_position()*500)
		blast_power = 1
		if OS.get_system_time_msecs() >= timers["blast_start_timer"]+750:
			blast_power = 2
		if OS.get_system_time_msecs() >= timers["blast_start_timer"]+1300:
			blast_power = 4
	else:
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
