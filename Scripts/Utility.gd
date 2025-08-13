extends Node
#region Description
## This file is meant to provide various utilities that may not be specific to any individual object.
## This is where the saving and loading functions will be stored. 
## Any constant that need to be repeatedly refered to will also be located in this file. 
#endregion

const resource_src: String = "res://Resources/"
const data_src: String = "res://Resources/Data"
const img_src: String = "res://Resource/Image"
const music_src: String = "res://Resource/Music"
const sfx_src: String = "res://Resource/SFX"

func get_scalar_ratio_to_window(key: String, value: float):
	assert( key.to_lower() == 'x' || 'y', "Key must be \'x\' or \'y\'.")
	return get_window().size[key] / value 

func get_vector2_scale_to_window(value: Vector2, stretch: bool = true) -> Vector2:
	assert(value.x > 0, "X Value must be greater than 0.")
	assert(value.y > 0, "Y Value must be greater than 0.")
	var _Default: Vector2 = Vector2(1,1)
	var scaledVector = Vector2(get_scalar_ratio_to_window("x",value.x),
		get_scalar_ratio_to_window("y",value.y))
	if (stretch):
		var GreaterValue = max(scaledVector.x, scaledVector.y)
		scaledVector = Vector2(GreaterValue, GreaterValue)
	else:
		assert((scaledVector.x == scaledVector.y), "Scale x, y values do not match! Or, enable stretching")
	return scaledVector

func round_to_dec(num, decimals):
	num = float(num)
	decimals = int(decimals)
	var sgn = 1
	if num < 0:
			sgn = -1
			num = abs(num)
			pass
	var num_fraction = num - int(num) 
	var num_dec = round(num_fraction * pow(10.0, decimals)) / pow(10.0, decimals)
	var round_num = sgn*(int(num) + num_dec)
	return round_num


### Converts a file, given it's directory path and it's file path (name). It returns
### an agnostic dictionary. 
func ConvertJSONFileToDictionary(dir_path: String, file_path: String) -> Dictionary:
	var dirCollection = DirAccess.open(dir_path).get_files()
	var file = dirCollection[dirCollection.find(file_path)]
	var file_as_string = FileAccess.get_file_as_string(dir_path+file.simplify_path())
	var jObj = JSON.new()
	jObj.parse(file_as_string)
	return jObj.get_data()


func ConvertXMLToDict(dir_path: String, file_path: String) -> Dictionary:
	var xml_parser:= XMLParser.new()
	xml_parser.open(dir_path + file_path)
	@warning_ignore("unassigned_variable") 
	var attr_dict_to_return: Dictionary 
	while xml_parser.read() != ERR_FILE_EOF:
		if xml_parser.get_node_type() == XMLParser.NODE_ELEMENT:
			#var node_name: String = xml_parser.get_node_name()
			var attributes_dict:= {}
			for idx in range(xml_parser.get_attribute_count()):
				attributes_dict[xml_parser.get_attribute_name(idx)] = xml_parser.get_attribute_value(idx)
			attr_dict_to_return[attr_dict_to_return.size()] = attributes_dict
	return attr_dict_to_return
