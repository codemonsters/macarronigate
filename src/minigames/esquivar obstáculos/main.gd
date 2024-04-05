extends Node2D

signal game_over
signal game_cleared
signal mouse_touch(event)

@export var game_brief = "esquivar obstáculos"
@export var needs_timer = true 
@export var timer_seconds = 10

var marmol = preload("res://minigames/esquivar obstáculos/marmol.tscn")
var area_movimiento = preload("res://minigames/esquivar obstáculos/area_movimiento.tscn")
var separacion = 100
var num_plataformas
var distancia
var player_x = 0
var num_plataforma = Vector2(0, 0)
var jump = false
var modulo_a = 0
var filas = 6
var marmol_anterior

var game_in_progress = true

func _ready():
	game_over.connect(Callable(get_parent(), "on_game_over"))
	game_cleared.connect(Callable(get_parent(), "on_game_cleared"))
	PhysicsServer2D.area_set_param(get_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,1))
	num_plataformas = 720/(118+separacion)
	num_plataformas = round(num_plataformas)
	distancia = (720 - (118*num_plataformas+separacion*(num_plataformas-1)))/2
	for y in range(filas):
		for x in range(num_plataformas+y%2):
			var marmol2 = marmol.instantiate()
			var area_movimiento2 = area_movimiento.instantiate()
			add_child(marmol2)
			add_child(area_movimiento2)
			if y == filas-1 and x == num_plataformas+y%2-2:
				marmol2.position=Vector2(2*59+separacion+marmol_anterior,200+150*y)
				area_movimiento2.position=Vector2(2*59+separacion+marmol_anterior,200+150*y)
			elif x == 0:
				marmol2.position=Vector2((distancia+26)*((y+1)%2)+33,200+150*y)
				area_movimiento2.position=Vector2((distancia+26)*((y+1)%2)+33,200+150*y)
			else:
				marmol2.position=Vector2(2*59+separacion+marmol_anterior,200+150*y)
				area_movimiento2.position=Vector2(2*59+separacion+marmol_anterior,200+150*y)
			marmol_anterior = marmol2.position.x
			print(area_movimiento2.position)
			mouse_touch.connect(Callable(area_movimiento2.get_node("Area2D"), "on_area_movimiento_mouse_touch"))

func _process(delta):
	if jump:
		$Jugador/CharacterBody2D.jump(delta)
		if $Jugador/CharacterBody2D.position.x - player_x > 218 or $Jugador/CharacterBody2D.position.x - player_x < -218:
			jump = false
	else:
		player_x = $Jugador/CharacterBody2D.position.x
		$Jugador/CharacterBody2D.t = 0

func on_area_movimiento_mouse_touch(event):
	jump = true
	for y in range(6):
		if event.position.y > (50+150*y-60) and event.position.y < (50+150*y+60):
			num_plataforma.y = y
	if int(num_plataforma.y)%2 == 0:
		for x in range(3):
			if event.position.x > (142+218*x-50) and event.position.x < (142+150*x+50):
				num_plataforma.x = x
	else:
		for x in range(4):
			if event.position.x > (142+218*x-50) and event.position.x < (142+150*x+50):
				num_plataforma.x = x
	print(num_plataforma)

func on_game_timeout():
	game_cleared.emit()
	game_in_progress = false
