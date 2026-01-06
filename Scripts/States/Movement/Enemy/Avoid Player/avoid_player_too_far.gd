class_name Avoid_Player_Too_Far
extends Enemy_Avoid_Player_Movement_State


func update(_delta:float):
	if enemy_movement_component.is_knocked_backed: return
	## Determine distance from player:
	var enemy_entity = enemy_movement_component.enemy_entity
	var distance = enemy_entity.position.distance_to(enemy_entity.player.position)
	
	if distance < enemy_movement_component.movement_type.player_distance_limits.y * 0.95:
		self.Transitioned.emit(self,"Avoid_Player_State")
		
	var direction = enemy_entity.position.direction_to(enemy_entity.player.position)
	if (enemy_entity.enemy as EnemyResource).looks_at_target:
			enemy_entity.sprite_2d.look_at(enemy_entity.player.position)
	enemy_entity.velocity = direction * enemy_movement_component.speed
