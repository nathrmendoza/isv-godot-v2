extends Control

const SPRITE_SIZE = 68

var armor = 0 : set = set_armor

@onready var armor_texture: TextureRect = $ArmorTexture
@onready var armor_texture_backdrop: TextureRect = $ArmorTextureBackdrop

func init_armor(multiplier: int):
	armor = multiplier
	armor_texture.size.x = SPRITE_SIZE * multiplier
	armor_texture_backdrop.size.x = SPRITE_SIZE * multiplier

func set_armor(_new_armor):
	if _new_armor == 0:
		armor_texture.modulate.a = 0
	else:
		if armor_texture.modulate.a == 0:
			armor_texture.modulate.a = 0
		armor_texture.size.x = SPRITE_SIZE * _new_armor
