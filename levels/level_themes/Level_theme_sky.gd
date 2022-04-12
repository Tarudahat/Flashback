extends Level
class_name SkyLevel

func _ready():
    $Static_map/CanvasModulate.visible=false
    $Static_map/TileMap.modulate = Color(1.5,1.5,1.8,0.9)
    $Objects/ModNodes.modulate = Color(1.5,1.5,1.8,0.9)
    Globals.player_node.modulate.r = 0.8
    Globals.lights_on = false
