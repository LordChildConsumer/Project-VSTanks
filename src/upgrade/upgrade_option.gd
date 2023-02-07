class_name UpgradeOption extends Button;

signal upgrade_selected; ## TODO: Connect this to the menu

@export_enum(
"upgrade_move_speed",

"upgrade_max_health",
"upgrade_armor",

"upgrade_base_damage",
"upgrade_attack_speed",
"upgrade_proj_speed",

"upgrade_pickup_range"
) var target_string: String;

@export var signal_arg: float = 1.0;

@onready var target_signal: Callable = Callable(EventBus, target_string);


#
# Trigger the upgrade
#
func _on_Upgrade_Selected() -> void:
	EventBus.emit_signal(target_string, signal_arg);
	upgrade_selected.emit();
	## TODO: Play a sound and close the upgrade menu
