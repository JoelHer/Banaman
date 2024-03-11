extends Area2D

@onready var sprite = %GunSprite
@onready var ap = $AnimationPlayer
@onready var timer = $Timer
@onready var summoner = %Summoner

@onready var projectile_class = preload("res://Prefabs/Projectile.tscn")
var is_mouse_button_down = false
var can_shoot = true
var cooldown = 0.5

func _ready():
	ap.play("idle")

func _physics_process(delta):
	if is_mouse_button_down:
		shoot()
	
	look_at(get_global_mouse_position())
	var deg = rad_to_deg(sprite.global_position.angle_to(get_global_mouse_position()))
	if (deg > 0):
		sprite.flip_v = true
	else:
		sprite.flip_v = false

func shoot():
	if can_shoot:
		can_shoot = false
		ap.play("shoot")
		var object_instance = projectile_class.instantiate()
		object_instance.global_position = summoner.global_position
		object_instance.global_rotation = summoner.global_rotation
		summoner.add_child(object_instance)
		await get_tree().create_timer(cooldown).timeout
		can_shoot = true
	
func _input(event):
	if event.is_action_pressed("Shoot"):
		is_mouse_button_down = true
	if event.is_action_released("Shoot"):
		is_mouse_button_down = false

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "shoot"):
		ap.play("idle")
