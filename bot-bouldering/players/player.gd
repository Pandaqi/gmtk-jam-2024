class_name Player extends Node2D

@export var map : Map

var lives := 1
var score := 0

signal lives_changed(new_lives:int)
signal score_changed(new_score:int)

func activate() -> void:
	pass

func change_lives(dl:int) -> void:
	lives = clamp(lives + dl, 0, 9)
	lives_changed.emit(lives)

func remove_all_lives() -> void:
	change_lives(-lives)

func change_score(ds:int) -> void:
	score = clamp(score + ds, 0, 99999)
	score_changed.emit(score)
