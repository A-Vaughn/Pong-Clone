extends Node

# Stores the winner from the game scene so that it can be accessed in the game over scene
var winner: String
var score_to_win: int = 3
var single_player_mode: bool = true
var first_load = true
enum GAME_SCENES {START_SCREEN, GAME_MODE_SCREEN, SETTINGS_SCREEN, CREDITS_SCREEN, GAME_SCREEN, PAUSE_SCREEN, GAME_OVER_SCREEN}
