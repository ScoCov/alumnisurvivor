class_name Avoid_Player_Too_Close
extends Enemy_Avoid_Player_Movement_State



func update(_delta: float):
	## Determine distance from player:
	if enemy_movement_component.is_knocked_backed: return
	var enemy_entity = enemy_movement_component.enemy_entity
	var target = enemy_entity.player.position
	var entity = enemy_movement_component.enemy_entity
	var distance = enemy_entity.position.distance_to(target)
	
	if distance > enemy_movement_component.movement_type.player_distance_limits.x * 1.05:
		self.Transitioned.emit(self,"Avoid_Player_State")
		
	var direction = -enemy_entity.position.direction_to(target)
	#if (entity.enemy as EnemyResource).looks_at_target:
			#entity.sprite_2d.look_at(target)
	enemy_entity.velocity = direction * (enemy_movement_component.speed )
