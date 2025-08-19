extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

@export var dash_speed: float = 600.0
@export var max_dash_time: float = 0.25
var is_dashing: bool = false
var dash_time: float = 0.0

const fall_limit: float = 200.0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_dashing:
		velocity.x = move_speed

	get_gravity(delta)
	get_input(delta)
	check_position()
	move_and_slide()

func get_gravity(delta) -> void:
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
	elif is_on_floor() and not Input.is_action_pressed("Jump"):
		velocity.y = 0.0

func get_input(delta) -> void:
	if Input.is_action_just_pressed("Jump") and is_on_floor() and not is_dashing:
		velocity.y = jump_force
		
	if Input.is_action_just_pressed("Dash") and not is_dashing:
		is_dashing = true
		dash_time = 0.0
		velocity = Vector2(dash_speed,0)
	
	if is_dashing:
		dash_time += delta
		velocity = Vector2 (dash_speed, 0)
		
	if dash_time >= max_dash_time or not Input.is_action_pressed("Dash"):
		is_dashing = false

func check_position() -> void:
	if position.y > fall_limit:
		die()

func die() -> void:
	queue_free()
