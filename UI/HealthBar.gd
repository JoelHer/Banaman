extends TextureRect

@export_category("Health bar slices")
@export var health1:AtlasTexture
@export var health2:AtlasTexture
@export var health3:AtlasTexture
@export var health4:AtlasTexture
@export var health5:AtlasTexture
@export var health6:AtlasTexture
@export var health7:AtlasTexture
@export var health8:AtlasTexture
@export var health9:AtlasTexture
@export var health10:AtlasTexture
@export var health11:AtlasTexture
@export var health12:AtlasTexture
@export var health13:AtlasTexture

func setTexture(_index:int):
	if _index >= 1:
		texture = health1
	if _index == 2:
		texture = health2
	if _index == 3:
		texture = health3
	if _index == 4:
		texture = health4
	if _index == 5:
		texture = health5
	if _index == 6:
		texture = health6
	if _index == 7:
		texture = health7
	if _index == 8:
		texture = health8
	if _index == 9:
		texture = health9
	if _index == 10:
		texture = health10
	if _index == 11:
		texture = health11
	if _index == 12:
		texture = health12
	if _index == 13:
		texture = health13
