extends Area2D

@export var checkpoint_id: int = 0

signal checkpoint_activated(checkpoint_position: Vector2, checkpoint_id: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "MainChar":
		print("Checkpoint ", checkpoint_id, " activated at position: ", global_position)
		checkpoint_activated.emit(global_position, checkpoint_id)
 