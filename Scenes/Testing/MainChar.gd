extends CharacterBody2D

@onready var anim_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var dash_timer = $DashTimer

var move_speed: float = 1500.0
var jump_force: float = 800
var gravity_up: float = 1800
var gravity_down: float = 3000

var dash_speed: float = move_speed * 2

var game_started: bool = false
var is_dashing: bool = false
var dash_time: float = 0.0
var curranim: String= ""

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

    _get_input(delta)
    _check_position()
    _calculate_state(delta)
    _match_state(delta)
    _get_gravity(delta)
    _update_debug_label()
    move_and_slide()

func _update_debug_label() -> void:
    debug_label.text = "state:%s \nfloor:%s ID:%s \nCA:%s v:%f" % [
        PlayerState.keys()[_state],
        is_on_floor(), is_dashing, curranim,
        velocity.y
    ]

func _get_gravity(delta) -> void:
    if not is_on_floor() and not is_dashing:
        if velocity.y < 0:
            velocity.y += gravity_up * delta
        else:
            velocity.y += gravity_down * delta
    #elif is_on_floor() and not Input.is_action_pressed("Jump"):
        #velocity.y = 0

func _get_input(delta) -> void:
    
    if Input.is_action_just_pressed("Jump") and is_on_floor():
        _set_state(PlayerState.JUMP)
        _start_jump()
    elif Input.is_action_just_pressed("Dash") and _state != PlayerState.DASH:
        _start_dash()

func _start_jump():
    velocity.y = -jump_force
    _set_state(PlayerState.JUMP)
    
    
func _start_dash():
    is_dashing = true
    _set_state(PlayerState.DASH)
    velocity = Vector2(dash_speed,0)
    dash_timer.start()


func _check_position() -> void:
    if position.y > fall_limit:
        _die()

func _die() -> void:
    queue_free()

func _calculate_state(delta) -> void:
    if is_on_floor() == true:
        #if game_started == false and velocity.x == 0:
        if velocity.x == 0:
            _set_state(PlayerState.IDLE)
        elif is_dashing == true:
            _set_state(PlayerState.DASH)
        else: 
            _set_state(PlayerState.RUN)
    
    else:
        if is_dashing == true:
            _set_state(PlayerState.DASH)
        else:
            _set_state(PlayerState.JUMP)
    
    if game_started and PlayerState not in [PlayerState.DASH, PlayerState.DEATH]:
        if is_on_floor() == true and dash_timer.is_stopped():
            _set_state(PlayerState.RUN)
        else:
            _set_state(PlayerState.JUMP)
            
func _set_state(new_state: PlayerState) -> void:
    if new_state == _state:
        return
    
    _state = new_state

func _match_state(delta):
    match _state:
        PlayerState.IDLE:
            anim_player.play("idle")
        PlayerState.RUN:
            anim_player.play("run")
        PlayerState.JUMP:
            anim_player.play("jump")
        PlayerState.DASH:
            anim_player.play("dash")
            
        
    

func _on_dash_timer_timeout():
    _set_state(PlayerState.RUN)
    is_dashing = false
