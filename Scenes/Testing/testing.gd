extends Node2D

# Checkpoint system variables
var current_checkpoint_position: Vector2 = Vector2(100, 0)  # Default starting position
var current_checkpoint_id: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func check_input():
    if Input.is_action_pressed("quit"):
        get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    check_input()
