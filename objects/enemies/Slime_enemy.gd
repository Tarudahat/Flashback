extends Entity

var velocity: Vector2
const JUMP_POWER:int = 300
var should_jump:bool = false
var timers:Dictionary = {"jump_timer":0}


func _process(delta):
	if abs(position.length()-Globals.player_node.position.length())<500:
		
		#jumping and gravity yoinked from player code
		if velocity.y<=3500:
			velocity.y += ENTITY_WEIGHT*Globals.gravity*delta

		if abs(position.length()-Globals.player_node.position.length())<170 and timers["jump_timer"]<=OS.get_system_time_secs():
			should_jump = true
		
		velocity.x -= delta
		if abs(velocity.x)<1:
			velocity.x = 0
		if Globals.player_node.position.x > position.x+15:
			$AnimatedSprite.flip_h=true
			velocity.x = 1*movement_speed
		elif Globals.player_node.position.x < position.x-15:
			$AnimatedSprite.flip_h=false
			velocity.x = -1*movement_speed

		if is_on_floor() and should_jump:
			timers["jump_timer"]=OS.get_system_time_secs()+round(rand_range(3,5))
			velocity.y=-JUMP_POWER
			should_jump = false
		
		if is_on_floor():
			movement_speed=15
		else:
			movement_speed=35

		velocity = move_and_slide(velocity,Vector2.UP)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if Globals.is_in_name("Player",collision.collider.name):
				Globals.player_node.damage(dmg)

	
