class_name Player extends CharacterBody2D

const ACCELERATION = 25.0;

### Player Stats ###
var stats: Dictionary = {
	"move_speed": 100.0,
	
	"max_health": 100,
	"health": 100,
	"armor": 1.0,
	
	"base_damage": 1.0,
	"attack_speed": 1.0,
	"proj_speed": 1.0,
	
	"pickup_range": 1.0,
	
	"exp": 0,
	"level": 0,
};

### Node Refs ###
@onready var _body := $Body;
@onready var _collider := $Collider;

@onready var _ui := $UI;

@onready var _gun := $GunParent;



#
# Movement
#
func _physics_process(delta: float) -> void:
	var input_vec := Input.get_vector("player_left", "player_right", "player_up", "player_down").normalized();
	var direction: Vector2 = input_vec * stats["move_speed"];
	
	## Acceleration
	if velocity != direction:
		velocity = lerp(velocity, direction, ACCELERATION * delta);
	
	
	## Make the body face the current movement direction
	_body.rotation = lerp_angle(_body.rotation, velocity.angle() - deg_to_rad(90), 0.15);
	_collider.rotation = _body.rotation + deg_to_rad(90);
	
	
	move_and_slide();

#
# Aim gun at mouse cursor
#
func _process(delta: float) -> void:
	_gun.look_at(get_global_mouse_position());


#
# Collect exp and level up
#
func _on_pickup_area_entered(area: Area2D) -> void:
	if area is ExpOrb:
		var pos_tween = area.create_tween();
		pos_tween.tween_property(
			area,
			"global_position",
			self.global_position,
			0.5
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK);
		
		var scale_tween = area.create_tween();
		scale_tween.tween_property(
			area,
			"scale",
			Vector2.ZERO,
			0.5
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR);
		
		await pos_tween.finished;
		await scale_tween.finished;
		
		stats["exp"] += area.get_exp();
		
		
		
		if await _ui.update_exp():
			stats["exp"] = 0;
			stats["level"] += 1;
			_ui.update_level(stats["level"]);
		
		area.queue_free();
