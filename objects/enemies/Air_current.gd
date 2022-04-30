extends Node2D

var bodies:Array
var blow_velocity:Vector2
export var blow_power:float = 2

func _process(delta):
        for boi in bodies:
            blow_velocity = Vector2()
            blow_velocity = position-boi.position.normalized()
            if Globals.is_in_name("Player",boi.name):
                blow_velocity.y  += boi.ENTITY_WEIGHT*Globals.gravity*delta*blow_power
            blow_velocity = blow_velocity*blow_power/(position.distance_to(boi.get_global_position())/320)
            blow_velocity = boi.move_and_slide(Vector2(blow_velocity.x*get_parent().scale.x,blow_velocity.y),Vector2.UP)

func _on_Area2D_body_entered(body):
    if body is Entity and body!=get_parent():
        bodies.append(body)


func _on_Area2D_body_exited(body):
    bodies.erase(body)
