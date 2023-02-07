class_name Bullet extends CharacterBody2D;

@export var speed: float = 200.0;
@export var damage: int = 5;
@export var lifetime: float = 5.0;

var direction := Vector2() : set = set_direction;

#
# Ready
#
func _ready() -> void:
	look_at(global_position + direction);
	
	$Timer.timeout.connect(_lifetime_Timeout);
	$Timer.set_wait_time(lifetime);
	$Timer.start();

#
# Movement
#
func _physics_process(delta: float) -> void:
	velocity = direction * speed;
	
	move_and_slide();
	
	var collision = get_last_slide_collision();
	if collision:
		if collision.get_collider().is_in_group("enemy"):
			collision.get_collider().hurt(damage);
			## TODO: Bullet hit effect thingy
			queue_free();

func _lifetime_Timeout() -> void:
	## TODO: Bullet miss effect thingy
	queue_free();

###############
### Setters ###
###############

func set_direction(value: Vector2) -> void:
	direction = value;

func set_speed(value: float) -> void:
	speed *= value;

func set_damage(value: float) -> void:
	damage *= value;
