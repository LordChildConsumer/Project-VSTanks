extends Node2D

### Node Refs ###
@onready var projectiles := $Projectiles;


#
# Spawn Bullets
#
func spawn_bullet(pos: Vector2, bullet: Bullet) -> void:
	projectiles.add_child(bullet);
	bullet.set_global_position(pos);
