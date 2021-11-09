extends Entity

var velocity:Vector2
export var max_rnd_time:int = 10
var timers:Dictionary = {"respawn_timer":0,"poof_timer":0,"dmg_timer":0}

func _ready():
	movement_speed=65
	dmg = 10
	timers["respawn_timer"] = OS.get_system_time_secs()+round(rand_range(5,max_rnd_time))
	timers["poof_timer"] = OS.get_system_time_secs()+900

func _process(delta):
	if OS.get_system_time_secs() >= timers["respawn_timer"]:
		$AnimatedSprite.play("poof_out")
		timers["respawn_timer"] = OS.get_system_time_secs()+900
	if OS.get_system_time_secs() >= timers["poof_timer"]:
		#---fix rnd spawn location, keep away from player by a range---
		#---------------------------TEMP-------------------------------
		position = Globals.player_node.position-Vector2(rand_range(0,25),rand_range(0,25))
		#--------------------------------------------------------------
		$AnimatedSprite.play("poof_in")
		timers["poof_timer"] = OS.get_system_time_secs()+900

	velocity = (Globals.player_node.position-position).normalized()

	velocity = move_and_slide(velocity*movement_speed)

	if timers["dmg_timer"]>=0.2:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if Globals.is_in_name("Player",collision.collider.name):
				Globals.player_node.hp -= dmg
		timers["dmg_timer"] = 0

	timers["dmg_timer"]+=delta

func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"poof_out":
			visible = false
			$CollisionShape2D.disabled = true
			timers["poof_timer"] = OS.get_system_time_secs()+3
		"poof_in":
			visible = true
			$CollisionShape2D.disabled = false
			$AnimatedSprite.play("default")
			timers["respawn_timer"] = OS.get_system_time_secs()+round(rand_range(5,max_rnd_time))