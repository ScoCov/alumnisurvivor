extends Node


#region Description
#endregion

## Returns the relative path of the given desired resource directory.
static func get_dir(target_dir: String, _cfg: ConfigFile = null) -> String:
	const acceptable_directories: Array[String] = ["student", "attribute", "item", "enemy", "map", "ability"]
	var err_msg: String = "Parameter must be one of the follow: "
	for dir in acceptable_directories:
		err_msg += "%s " % dir
	assert(target_dir in acceptable_directories, err_msg + " (You gave: '%s')" % target_dir)
	target_dir.to_lower()
	var cfg:= ConfigFile.new() 
	cfg.load("res://env.cfg")
	return cfg.get_value("files", target_dir+"_resource_directory")
	
	

