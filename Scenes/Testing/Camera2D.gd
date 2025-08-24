extends Camera2D

@export var player: NodePath
var player_ref: Node2D

func _ready():
	pass
	#player_ref = get_node(player)
	#limit_left = int(global_position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if not player_ref:
		#return
	
	#limit_left = max(limit_left, int(player_ref.global_position.x))
	
	#limit_bottom = 0
