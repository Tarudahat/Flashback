extends Node2D

var bodies:Array 
var velocity:Vector2
var timer:float
export var timeout:bool = true
export var succ_power:int = 120

func _process(delta):
    $Sprite.rotate(150)
    for boi in bodies:
        velocity = Vector2() 
        velocity = (((position-Vector2(0,-50))-boi.position).normalized())
        if boi.position.y>position.y:
            boi.velocity.y -= boi.ENTITY_WEIGHT*Globals.gravity*delta*2
        velocity = boi.move_and_slide(velocity*succ_power)
        if timer>=0.5:
            boi.damage(15,true)
            timer=0
    timer+=delta
   
        


func _on_Area2D_body_entered(body):
    if body is Entity:
        bodies.append(body)


func _on_Area2D_body_exited(body):
    bodies.erase(body)


func _on_Timer_timeout():
    if timeout:
        queue_free()
