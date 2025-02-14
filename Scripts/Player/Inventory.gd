extends Node

var door_keys : Dictionary = {
	"light brown" : false,
	"gray" : false,
	"orange" : false,
	"blue" : false,
	"red" : false,
	"green" : false,
	"purple" : false,
}

func give_key(key : String) -> void:
	door_keys[key] = true

func has_key(key : String) -> bool:
	return door_keys[key]
