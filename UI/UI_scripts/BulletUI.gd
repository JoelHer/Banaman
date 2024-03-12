extends TextureRect

@export_category("Health bar slices")
@export var bullet1:AtlasTexture
@export var bullet2:AtlasTexture
@export var bullet3:AtlasTexture
@export var bullet4:AtlasTexture
@export var bullet5:AtlasTexture
@export var bullet6:AtlasTexture
@export var bullet7:AtlasTexture


func setTexture(_index:int):
	if _index >= 1:
		texture = bullet1
	if _index == 2:
		texture = bullet2
	if _index == 3:
		texture = bullet3
	if _index == 4:
		texture = bullet4
	if _index == 5:
		texture = bullet5
	if _index == 6:
		texture = bullet6
	if _index == 7:
		texture = bullet7

