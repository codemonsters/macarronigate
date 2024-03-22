extends Node2D
var Izq_scene = load("res://minigames/music ritmito/Izq.tscn")
var Der_scene = load("res://minigames/music ritmito/Der.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var der = Der_scene.instantiate()
	var izq = Izq_scene.instantiate()
	var bolitas = randi_range(1, 3)
	izq.position.y = -100
	der.position.y = -100
	if bolitas == 1:
		izq.position.x = 180
		add_child(izq)
	if bolitas == 2:	
		der.position.x = 540
		add_child(der)
	if bolitas == 3:
		izq.position.x = 180
		add_child(izq)
		der.position.x = 540
		add_child(der)
