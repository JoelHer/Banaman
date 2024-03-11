extends CharacterBody2D

@export_category("Player Properties") 
@export var move_speed : float = 400
@export var jump_force : float = 600
@export var gravity : float = 30
@export var max_jump_count : int = 2
var jump_count : int = 2

@export_category("Toggle Functions") 
@export var double_jump : = false

var is_grounded : bool = false 

@onready var player_sprite = $AnimatedSprite2D
@onready var ap = %AnimationPlayer
@onready var sprite = $Sprite2D
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles

@export var max_health : int = 13
var current_health = int(max_health/2)+1

func _process(_delta):
	get_node("/root/Ui/HealthBar").setTexture(current_health)
	movement()
	flip_player()

func movement():
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	var inputAxis = Input.get_axis("Left", "Right")
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()
	update_animation(inputAxis)

func take_damage(_damage):
	current_health -= 1

func update_animation(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("walk")
	else:
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("walk")

func handle_jumping():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

func jump():
	jump_tween()
	velocity.y = -jump_force

func flip_player():
	if velocity.x < 0: 
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps"):
		death_particles.emitting = true
