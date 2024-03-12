extends Node2D

@onready var tilemap:TileMap = $tilemap 
var width = 15
var height = 15
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
	var matrix = fillPerlin(Vector2i(-width,-height), Vector2i(0,0), Vector2i(1,1))
	var maxR = maximalRectangle(matrix)
	print(maxR)
	fill(Vector2i(maxR[0]/2,maxR[1]/2), Vector2i(maxR[0]+maxR[2],maxR[1]+maxR[3]), Vector2i(3,3))
	#var t:Room = Room.new()maxR[0]
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

func maximalRectangle(matrix):
	if not matrix or not matrix[0]:
		return [0, 0, 0] # Return [x, y, area] as [0, 0, 0] if matrix is empty
	var n = len(matrix[0])
	var height = []
	for _d in range(n + 1):
		height.append(0)
	var ans = 0
	var max_rect_x = 0
	var max_rect_y = 0
	var max_rect_width = 0
	var max_rect_height = 0
	for row_idx in range(len(matrix)):
		for i in range(n):
			if matrix[row_idx][i] == 1:
				height[i] += 1
			else:
				height[i] = 0
		var stack = [-1]
		for i in range(n + 1):
			while height[i] < height[stack[-1]]:
				var h = height[stack.pop_back()]
				var w = i - 1 - stack[-1]
				if h * w > ans:
					ans = h * w
					max_rect_x = stack[-1] + 1
					max_rect_y = row_idx - h + 1
					max_rect_width = w
					max_rect_height = h
			stack.append(i)
	return [max_rect_x, max_rect_y, max_rect_width, max_rect_height, ans]


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
	var matrix = []
	for i in range(from.x, to.x, invX):
		var outM = []
		for j in range(from.y, to.y, invY):  # Use invY as the step value
			
			var tex:Vector2i
			if noise.get_noise_2d(i,j) > 0:
				tex = atlasMapPos
				outM.append(1)
			else:
				outM.append(0)
				tex = Vector2i(-1,-1)
			tilemap.set_cell(0, Vector2i(i,j), 1, tex)
		matrix.append(outM)
	
	return matrix


func _ready ():
	generate()
