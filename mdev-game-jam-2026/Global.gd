extends Node

signal PitchBall
signal CaughtBall
signal BallStop
signal CueSFX(key : String)

signal CallStrike
signal CallBall

enum eBallTargets {LEFT, RIGHT, CENTER, TOP, BOTTOM}
var current_target : eBallTargets
