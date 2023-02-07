extends CanvasLayer

### Node Refs ###
@onready var exp_bar := $EXP;
@onready var lvl_lbl := $EXP/LVL;


#
# Update Experience
#
func update_exp(xp: int) -> bool:
	var xp_tween := exp_bar.create_tween();
	
	xp_tween.tween_property(
		exp_bar,
		"value",
		xp,
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

func update_level(lvl: int) -> void:
	lvl_lbl.set_text("Level: %s" % lvl);
	exp_bar.set_max(get_exp_goal(lvl));
	
	## TODO: Pause game and show upgrade selection

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
