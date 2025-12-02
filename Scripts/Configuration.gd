extends Node


#region Description
#endregion

##TODO: The acceptable_directories needs to be populated automatically in the future. 
const acceptable_directories: Array[String] = ["student", "attribute", "item",
	 "enemy", "map", "ability", "mouth", "eyes", "hair", "eyebrows"]
	
## Returns the relative path of the given desired resource directory.
static func get_dir(target_dir: String, _cfg: ConfigFile = null) -> String:
	var err_msg: String = "Parameter must be one of the following: "
	for dir in acceptable_directories:
		err_msg += "%s " % dir
	assert(target_dir in acceptable_directories, err_msg + " (You gave: '%s')" % target_dir)
	target_dir.to_lower()
	var cfg:= ConfigFile.new() if not _cfg else _cfg
	cfg.load("res://env.cfg")
	return cfg.get_value("files", target_dir+"_resource_directory")
	
	
