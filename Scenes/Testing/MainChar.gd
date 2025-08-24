extends CharacterBody2D

@onready var anim_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var dash_timer = $DashTimer


@export var move_speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

@export var dash_speed: float = 600.0
@export var max_dash_time: float = 0.3

var game_started: bool = false
var is_dashing: bool = false
var dash_time: float = 0.0

const fall_limit: float = 200.0

enum PlayerState { IDLE, RUN, JUMP, DASH, DEATH }
var _state: PlayerState = PlayerState.IDLE

func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if not game_started and Input.is_action_just_pressed("startgame"):
		#game_started = true
		#_state = PlayerState.RUN

	if not is_dashing:
		velocity.x = move_speed

	get_gravity(delta)
	get_input(delta)
	check_position()
	calculate_state()
	update_debug_label()
	move_and_slide()

func update_debug_label() -> void:
	debug_label.text = "state:%s \nfloor:%s" % [
		PlayerState.keys()[_state],
		is_on_floor()
	]
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

func calculate_state() -> void:
	if is_on_floor() == true:
		#if game_started == false and velocity.x == 0:
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else: 
			set_state(PlayerState.RUN)
	else:
		if velocity.y < 0:
			set_state(PlayerState.JUMP)
		else:
			pass
	
	if game_started and PlayerState not in [PlayerState.DASH, PlayerState.DEATH]:
		if is_on_floor() == false:
			set_state(PlayerState.JUMP)
		else:
			set_state(PlayerState.RUN)
			
func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	8
	_state = new_state
	match _state:
		PlayerState.IDLE:
			anim_player.play("idle")
		PlayerState.RUN:
			anim_player.play("run")
		PlayerState.JUMP:
			anim_player.play("jump")
		
	
