extends Node2D

const PICKUP_RADIUS := 32.0;

@onready var player := get_parent();

@onready var pickup_range: CollisionShape2D = $"../Pickup/CollisionShape2D"


#######################
### Connect signals ###
#######################
func _ready() -> void:
	EventBus.upgrade_move_speed.connect(up_move_speed);
	
	EventBus.upgrade_max_health.connect(up_max_health);
	EventBus.upgrade_armor.connect(up_armor);
	
	EventBus.upgrade_base_damage.connect(up_base_damage);
	EventBus.upgrade_attack_speed.connect(up_attack_speed);
	EventBus.upgrade_proj_speed.connect(up_proj_speed);
	
	EventBus.upgrade_pickup_range.connect(up_pickup_range);


####################
### Update Stats ###
####################

#
# Movement
#
func up_move_speed(value: float) -> void:
	player.stats["move_speed"] += value;


#
# Health
#
func up_max_health(value: float) -> void:
	player.stats["max_health"] += int(value);
	## TODO: Update health bar

func up_armor(value: float) -> void:
	player.stats["armor"] += value;

#
# Damage
#
func up_base_damage(value: float) -> void:
	player.stats["base_damage"] += value;

func up_attack_speed(value: float) -> void:
	player.stats["attack_speed"] -= value;

func up_proj_speed(value: float) -> void:
	player.stats["proj_speed"] += value;


#
# Misc
#
func up_pickup_range(value: float) -> void:
	player.stats["pickup_range"] += value;
	pickup_range.shape.radius = PICKUP_RADIUS * player.stats["pickup_range"];
