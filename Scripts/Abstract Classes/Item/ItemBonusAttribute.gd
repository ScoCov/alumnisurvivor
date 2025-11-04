class_name ItemBonusAttribute
extends ItemBonus

#region Description
## Item Bonus Attribute is an extended Item Bonus class. It will control Attribute related
## bonuses. It will contain the Attribute to be modified by how much and how to apply it.
#endregion
## Target Attribute to be modified by this Item Bonus.
@export var attribute: AttributeResource
## Items will start with a single item, this is the value used.
@export var initial_value: float
## This value will be multiplied by the number of items in a given stack.
@export var level_value: float
## This value will help determine how to apply the total value to the component's moded vlaue
@export var type: _type
enum _type {Addition, Subtraction}
## This value will help target the base_value that will have the calculations done to it, 
## or the modded value that will be simply added on top of the base value, not adding any value
## to future calculations.
@export var target: _target
enum _target {Base, Mod}
## This  value is to control what type this value should be displayed as:
## Float: "If the value should be displayed with Decimals."
## Percentage: If the value should convert to % value.
## Int: If the value should be displayed as a whole number.
## String: If the value is a word, or some non-number value.
@export var data_type: _data_type
enum _data_type { Float , Percentage, Int, String}
## This value is to control how a 'good' value is displayed.
## High: Larger Positive Numbers are Good.
## Low: The lower the number, bigger negative numbers, are Good.
## Zero: Zero is a good number, neither positive or negative has an advantage.
@export var better_value: _better_value
enum _better_value {High, Low, Zero}
## Pass a component that is to be processed, and the count of the ItemStack to calculate the appropriate values.
#func process_component(component: Component, count: int):
	#assert(count > 0, "ERROR: ItemBonusAttribute.process_component, requires a count of 1 or greater.")
	#var target_value = "base_mod" if target == _target.Base else "mod_value"
	#match type:
		#_type.Addition:
			#component[target_value] += initial_value + (level_value*(count-1))
		#_type.Subtraction:
			#component[target_value] -= initial_value + (level_value*(count-1))
