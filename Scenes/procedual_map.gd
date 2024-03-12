extends Node2D

@onready var tilemap:TileMap = $tilemap 
var width = 100
var height = 100
var noise_scale = 0.1

@export var noise:Noise

class Room:
	var rTopTile = Vector2i(1,2)
	var rBottomTile = Vector2i(1,0)
	var rLeftTile = Vector2i(2,1)
	var rRightTile = Vector2i(0,1)
	var rEdgeTLTile = Vector2i(4,0)
	var rEdgeTRTile = Vector2i(4,1)
	var rEdgeBLTile = Vector2i(5,0)
	var rEdgeBRTile = Vector2i(5,1)
	var size: Vector2i
	var pos: Vector2i
	func _init():
		size = Vector2i(0, 0)
		pos = Vector2i(0, 0)

	func set_size(value: Vector2i):
		self.size = value
		
	func render(_tm:TileMap):
		var from = pos
		var to = pos+size
		var invX = -1
		var invY = -1
		if from.x > to.x:
			invX = -1
		else:
			invX = 1
		if from.y > to.y:
			invY = -1
		else:
			invY = 1
		for i in range(from.x, to.x, invX):
			for j in range(from.y, to.y, invY): 
				_tm.set_cell(0, Vector2i(i,j), 1, Vector2i(-1,-1))
		#corners
		_tm.set_cell(0, pos-Vector2i(1,1), 1, rEdgeTLTile)
		_tm.set_cell(0, Vector2i(pos.x,pos.y+size.y)-Vector2i(1,0), 1, rEdgeTRTile)
		_tm.set_cell(0, Vector2i(pos.x+size.x,pos.y)-Vector2i(0,1), 1, rEdgeBLTile)
		_tm.set_cell(0, pos+size, 1, rEdgeBRTile)
		
		#edges
		for i in range(pos.x,pos.x+size.x,1):
			_tm.set_cell(0, Vector2i(i,pos.y-1), 1, rTopTile)
			_tm.set_cell(0, Vector2i(i,pos.y+size.y), 1, rBottomTile)
			
		for i in range(pos.y,pos.y+size.y,1):
			_tm.set_cell(0, Vector2i(pos.y-1,i), 1, rLeftTile)
			_tm.set_cell(0, Vector2i(pos.y+size.y+3,i), 1, rRightTile)
		

	func get_size():
		return self.size


func generate():
	#tilemap.set_cell(0, Vector2i(0,0), 1, Vector2i(1,1))
	#fill(Vector2i(width,height), Vector2i(-width,-height), Vector2i(1,1))
	fillPerlin(Vector2i(width,height), Vector2i(-width,-height), Vector2i(1,1))
	#var t:Room = Room.new()
	#t.size = Vector2i(12,9)
	#t.pos = Vector2i(-4,-4)
	#t.render(tilemap)

	
	
func fill(from:Vector2i, to:Vector2i, atlasMapPos:Vector2i):
	var invX = -1
	var invY = -1
	if from.x > to.x:
		invX = -1
	else:
		invX = 1
	if from.y > to.y:
		invY = -1
	else:
		invY = 1
	for i in range(from.x, to.x, invX):
		for j in range(from.y, to.y, invY):  # Use invY as the step value
			tilemap.set_cell(0, Vector2i(i,j), 1, atlasMapPos)

func fillPerlin(from:Vector2i, to:Vector2i, atlasMapPos:Vector2i):
	var invX = -1
	var invY = -1
	if from.x > to.x:
		invX = -1
	else:
		invX = 1
	if from.y > to.y:
		invY = -1
	else:
		invY = 1
	for i in range(from.x, to.x, invX):
		for j in range(from.y, to.y, invY):  # Use invY as the step value
			print(noise.get_noise_2d(i,j))
			var tex:Vector2i
			if noise.get_noise_2d(i,j) > 0:
				tex = atlasMapPos
			else:
				tex = Vector2i(-1,-1)
			tilemap.set_cell(0, Vector2i(i,j), 1, tex)


func _ready ():
	generate()
