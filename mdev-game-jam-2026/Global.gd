extends Node

signal PitchBall
signal CaughtBall
signal BallStop
signal CueSFX(key : String)

signal CallStrike
signal CallBall
signal CallHit
signal CallOut

signal CallWin
signal CallWalk
signal CallCaught

signal WiggleBatter(wiggle : bool)

enum eBallTargets {LEFT, RIGHT, CENTER, TOP, BOTTOM}
var current_target : eBallTargets
