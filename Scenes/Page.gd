extends Control

#region Description
## 
#endregion

@warning_ignore("unused_signal")
signal page_type_changed

const _page_type_list: Array[String] = ["Title","Collection", "Settings"]

@export_enum("Title","Collection", "Settings") var page_type: String:
	set(value):
		assert(value in _page_type_list)
		page_type = value
	get:
		if page_type.is_empty() or null:
			page_type = "Title"
		return page_type
		
func _update_page() -> void:
	find_child("Header").text = page_type
	(find_child("Header").get_child(0) as ColorRect).color  = (find_child(page_type).get_child(0) as ColorRect).color  
		
func _on_page_type_changed(_page_type: String = "") -> bool:
	if _page_type in _page_type_list:
		page_type = _page_type
		for page in find_child("Body").get_children():
			if page.name == page_type:
				page.visible = true
			else:
				page.visible = false
	else:
		assert(_page_type in _page_type_list, "Must be a valid page type")
		return false
	_update_page() 
	return true
