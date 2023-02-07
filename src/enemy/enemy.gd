class_name Enemy extends CharacterBody2D;

### Stats ###
@export var move_speed: float = 50.0;
@export var health: int = 10;

## Player Reference
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player");


## Target position
var target_pos := Vector2();


#
# Connect the timer to the _update_Target_Pos() function
#
func _ready() -> void:
	$Timer.timeout.connect(_update_Target_Pos);

#
# Movement
#
func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(target_pos) * move_speed;
	look_at(global_position + velocity);
	
	move_and_slide();


#
# Update the target position every so often
#
func _update_Target_Pos() -> void:
	target_pos = player.global_position;




##############
### Health ###
##############

func hurt(value: int) -> void:
	health -= value;
	print("Hurt")
	if health <= 0:
		kill();

func kill() -> void:
	self.queue_free();
