extends CanvasLayer

const PATH_TO_UPGRADES := "res://src/upgrade/valid/";

### Node Refs ###
@onready var exp_bar := $EXP;
@onready var lvl_lbl := $EXP/LVL;

@onready var upgrade_menu := $M/UPGRADES;
@onready var upgrade_list := $M/UPGRADES/LIST;

@onready var valid_upgrades: Array = [];


#############################
### Experience and Levels ###
#############################

#
# Update Experience
#
func update_exp() -> bool:
	var xp_tween := exp_bar.create_tween();
	
	xp_tween.tween_property(
		exp_bar,
		"value",
		get_parent().stats["exp"],
		0.1
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC);
	
	await xp_tween.finished;
	
	if exp_bar.value == exp_bar.max_value:
		
		## Tween the exp back to 0 when leveling up
		var tween_back = exp_bar.create_tween();
		tween_back.tween_property(
			exp_bar,
			"value",
			0,
			0.25
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC);
		
		
		return true;
	else:
		return false;

#
# Update Levels
func update_level(lvl: int) -> void:
	lvl_lbl.set_text("Level: %s" % lvl);
	exp_bar.set_max(5 + (lvl * 2));
	
	#get_tree().paused = true;
	show_upgrades();


####################
### Upgrade Menu ###
####################

#
# Load all upgrades
#
func _ready() -> void:
	upgrade_menu.set_visible(false);



func show_upgrades() -> void:
	var dir := DirAccess.open(PATH_TO_UPGRADES);
	
	if dir:
		## Get all files in dir
		var files := dir.get_files();
		
		## Load all the files
		for file in files:
			valid_upgrades.append(load(PATH_TO_UPGRADES + file));
	
	
	## Upgrade 1
	randomize();
	var first_upgrade: Control = valid_upgrades.pop_at(randi() % valid_upgrades.size()).instantiate();
	
	## Upgrade 2
	randomize();
	var second_upgrade: Control = valid_upgrades.pop_at(randi() % valid_upgrades.size()).instantiate();
	
	## Upgrade 3
	randomize();
	var third_upgrade: Control = valid_upgrades.pop_at(randi() % valid_upgrades.size()).instantiate();
	
	
	#
	# Add the upgrades to the menu
	#
	if first_upgrade:
		upgrade_list.add_child(first_upgrade);
		first_upgrade.upgrade_selected.connect(_on_Upgrade_Selection);
	
	if second_upgrade:
		upgrade_list.add_child(second_upgrade);
		second_upgrade.upgrade_selected.connect(_on_Upgrade_Selection);
	
	if third_upgrade:
		upgrade_list.add_child(third_upgrade);
		third_upgrade.upgrade_selected.connect(_on_Upgrade_Selection);
	
	upgrade_menu.set_visible(true);
	get_tree().paused = true;


#
# Close the upgrade menu and clear it for the next time the player levels up
#
func _on_Upgrade_Selection() -> void:
	for child in upgrade_list.get_children():
		if !child is Label:
			child.queue_free();
	
	upgrade_menu.set_visible(false);
	get_tree().paused = false;


########################
### Helper Functions ###
########################

## HACK: May switch this to my way of just setting the goal to 10 or 5 + (lvl * 2)
func get_exp_goal(lvl) -> int:
	match lvl:
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19:
			return lvl * 10;
		
		20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 32, 34, 35, 36, 37, 38, 39:
			return lvl * 13;
		
		_:
			return lvl * 16;
