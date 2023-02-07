class_name Gun extends Node2D;

signal bullet_fired(pos, bullet);

@export var bullet: PackedScene = preload("res://src/bullet/bullet.tscn");
@export var fire_delay: float = 1.0;

@onready var timer := $Timer;
@onready var muzzle := $Muzzle;


var can_shoot: bool = true;


#
# Ready
#
func _ready() -> void:
	update_delay_timer();
	
	## Connect self to bullet_fired signal on level
	bullet_fired.connect(get_tree().get_first_node_in_group("level").spawn_bullet);

#
# Process
#
func _process(delta: float) -> void:
	if Input.is_action_pressed("player_shoot") && can_shoot:
		shoot();


#
# Shooting
#
func shoot() -> void:
	print("shot")
	can_shoot = false;
	
	var new_bullet: Bullet = bullet.instantiate();
	
	new_bullet.set_direction(global_position.direction_to(get_global_mouse_position()));
	
	## Apply changes based on player stats
	new_bullet.set_speed(get_parent().get_parent().stats["proj_speed"]);
	new_bullet.set_damage(get_parent().get_parent().stats["base_damage"]);
	
	bullet_fired.emit(muzzle.global_position, new_bullet);
	
	timer.start();
	await timer.timeout;
	can_shoot = true;




########################
### Helper Functions ###
########################

func update_delay_timer() -> void:
	timer.set_wait_time(fire_delay * get_parent().get_parent().stats["attack_speed"]);
