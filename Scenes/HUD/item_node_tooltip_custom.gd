extends RichTextLabel

signal loaded

const _debug_item: Item_Resource = preload("res://Resources/Data/Items/baseball_cap.tres")

@export var item: Item_Resource
@export var count: int = 0


func _ready():
	if not item:
		item = _debug_item
		count = 1
		self.size_flags_vertical =Control.SIZE_EXPAND_FILL
	loaded.emit()
	
func _on_loaded():
	text = "[center]%s (x%s)[/center]\n\n" % [item.item_name,count]
	for item_bonus: Item_Effect in item.item_effects:
		if item_bonus is Item_Effect_Attribute:
			text += row_attribute(item_bonus)
			#v_box_container.add_child(_row_attribute(item_bonus))
			
func row_attribute(item_effect: Item_Effect_Attribute) -> String:
	var attribute_name: String = item_effect.attribute.name
	var color: Color = _get_color(item_effect)
	var value: float = item_effect.base_value + item_effect.base_value * (count - 1)
	return "%s:[right][color=\"%s\"]%s[/color][/right]\n" % [attribute_name, color.to_html(false), value]
	
func _row_attribute(item_effect: Item_Effect_Attribute) -> Label:
	var new_label:= Label.new()
	var attribute_name: String = item_effect.attribute.name
	var value: float = item_effect.base_value + item_effect.base_value * (count - 1)
	new_label.text = "%s:              %s" % [ attribute_name, value]
	return new_label

func _get_color(item_effect: Item_Effect_Attribute) -> Color:
	match item_effect.effect:
		"Good":
			return Color.GREEN
		"Bad":
			return Color.RED
		_:
			return Color.WHITE_SMOKE
