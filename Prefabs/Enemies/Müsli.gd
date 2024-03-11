extends CharacterBody2D

@export_category("Enemy Properties") 
@export var move_speed : float = 50
@export var gravity : float = 30
@export var damage : int = 2
@export var health : int = 3
var jump_count : int = 2
@onready var player = get_node("/root/Main/Player")
@onready var ap = $EAnimationPlayer

var allowed_move = true
var death = false

func _physics_process(delta):
	var direction
	if allowed_move:
		direction = global_position.direction_to(player.global_position)
	else:
		direction = Vector2(0,0)
	if !is_on_floor():
		velocity.y += gravity
	
	if (velocity.x != 0 && allowed_move):
		ap.play("walk")
	
	velocity = Vector2(direction.x * move_speed, velocity.y)
	move_and_slide()
	
	
func take_damage(_damage):
	if !death:
		ap.stop()
		ap.pause()
		
		allowed_move = false
		health = health - _damage
		if health <= 0:
			death = true
			ap.play("death")
		else:
			ap.play("take_damage")
	

func _on_area_2d_body_entered(body):
	pass


func _on_e_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
	if anim_name == "walk":
		ap.play("RESET")
	if anim_name == "take_damage":
		allowed_move = true
