extends KinematicBody2D

export var movement_speed:int = 170
export var dmg:int = 50
var target_position:Vector2
var velocity:Vector2
var skip_rest_collisions:bool = false#mainly used for reflections as it would just collide again and reflect back to it's og place

var blast_powers:Dictionary = {"SMALL":1,"MEDIUM":2,"BIG":4}
#apparently enums and dictionaries are the same in godot... huh
var blast_power:int 

func _ready():
	target_position *= 5000
	match blast_power:
		1:
			$CollisionShape2D.shape.radius=5
			$AnimatedSprite.play("small")
		2:
			$CollisionShape2D.shape.radius=10
			$AnimatedSprite.play("medium")
		4:
			$CollisionShape2D.shape.radius=18
			$AnimatedSprite.play("big")

func _process(_delta):

	look_at(target_position)
	velocity=move_and_slide(target_position.normalized()*movement_speed)

	skip_rest_collisions=false
	for i in get_slide_count():
		if skip_rest_collisions==false:
			var collision = get_slide_collision(i)
			if is_queued_for_deletion():
				pass
			else:
				if !collision.collider == null:
					if collision.collider is Entity:
						if collision.collider.ENTITY_TYPE == Globals.ENTITY_TYPES.ENEMY:
							var collided_object = collision.collider
							collided_object.damage(dmg*blast_power)
							queue_free()
					elif collision.collider is TileMap:
						queue_free()
					elif collision.collider is StaticBody2D:
						var collided_object = collision.collider
						if Globals.is_in_name("Switch",collided_object.name) and collided_object.get_child_count()>0:
							collided_object.active_=Globals.switch_bool(collided_object.active_)
							queue_free()
						elif Globals.is_in_name("Reflector",collided_object.name):
							target_position=target_position.bounce(collision.normal)
							skip_rest_collisions=true
					else:
						queue_free()
				

