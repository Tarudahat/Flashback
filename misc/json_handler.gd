extends Node

func serialize_vector(input_vector): 
    return {"x":input_vector.x,"y":input_vector.y}

func deserialize_vector(input_vector):
    return Vector2(input_vector["x"],input_vector["y"])

func load_dictionary(file_path):
    var file = File.new()
    file.open(file_path,file.READ)
    var return_value = parse_json(file.get_as_text())
    file.close()
    return return_value

func save_dictionary(dictionary,file_path):
    var file = File.new()
    file.open(file_path,file.WRITE)
    file.store_line(to_json(dictionary))
    file.close()
    