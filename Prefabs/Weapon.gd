extends Area2D

@onready var sprite = %GunSprite
@onready var ap = $AnimationPlayer
@onready var timer = $Timer
@onready var summoner = %Summoner
@onready var ammoui = get_node("/root/Ui/AmmoUI")

@onready var projectile_class = preload("res://Prefabs/Projectile.tscn")
var is_mouse_button_down = false
var can_shoot = true
var can_shoot_reload = true

@export_category("Weapon properties")
@export var cooldown:float = 0.5
@export var total_ammo:int = 100
@export var magazine_ammo:int = 6
@export var current_ammo:int = magazine_ammo

func _ready():
	ap.play("idle")
	ammoui.setTexture(magazine_ammo-(current_ammo-1))

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
	if current_ammo > 0:
		can_shoot_reload = true
	else:
		can_shoot_reload = false
		relaod()
	
	if can_shoot && can_shoot_reload && !reloading:
		print("shut")
		can_shoot = false
		ap.play("shoot")
		var object_instance = projectile_class.instantiate()
		current_ammo -= 1
		ammoui.setTexture(magazine_ammo-(current_ammo-1))
		object_instance.global_position = summoner.global_position
		object_instance.global_rotation = summoner.global_rotation
		summoner.add_child(object_instance)
		await get_tree().create_timer(cooldown).timeout
		can_shoot = true

var reloading = false
func relaod():
	if reloading:
		return
	reloading = true
	ap.play("reload")
	print("wes")
	for i in range(magazine_ammo):
		print("we" + str(i))
		await get_tree().create_timer((1.7*0.5)/magazine_ammo).timeout
		current_ammo+=1
		ammoui.setTexture(magazine_ammo-(current_ammo-1))
	await get_tree().create_timer((1.7*0.5)/magazine_ammo*1.5).timeout
	reloading = false

func _input(event):
	if event.is_action_pressed("Shoot"):
		is_mouse_button_down = true
	if event.is_action_released("Shoot"):
		is_mouse_button_down = false

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "shoot"):
		ap.play("idle")
	if (anim_name == "reload"):
		can_shoot = true
		ap.play("idle")
