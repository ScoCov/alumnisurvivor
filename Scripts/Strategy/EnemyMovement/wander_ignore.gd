class_name EnemyMovementWanderIgnore
extends EnemyMovementStrategy

## Target Precision (x,y) offset for random position applied to target; 
## the player's position. 
@export var wander_precision:= Vector2(100,100)
## X == Minmum Distance to player, and Y == Maximum Distance to player, until 
## entity's wander behavior will change.
@export var player_distance_limits:= Vector2(0,450)
## If the entity is too far away from the player,
@export var redirection_precision: Vector2 = Vector2(25,25)
