
AddCSLuaFile()

CreateConVar( "gibsystem_enabled", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Gib System.")
CreateConVar( "gibsystem_gibbing_player", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Gib System for Players.")
CreateConVar( "gibsystem_gibbing_npc", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Gib System for NPCs.")
CreateConVar( "gibsystem_random_finger_rotating", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable random finger rotating.")
CreateConVar( "gibsystem_random_toe_rotating", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable random toe rotating.")
CreateConVar( "gibsystem_random_gf2_toe_rotating", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable random toe(GF2) rotating.")
CreateConVar( "gibsystem_ragdoll_convulsion", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable ragdoll convulsion.")
CreateConVar( "gibsystem_ragdoll_collisiongroup", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set ragdoll Collision Group.")
CreateConVar( "gibsystem_ragdoll_removetimer", 10 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set ragdoll remove timer.")
CreateConVar( "gibsystem_deathcam_enable", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Deathcam.")
CreateConVar( "gibsystem_deathcam_mode", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Deathcam Mode, 0 = Head, 1 = Body.")
CreateConVar( "gibsystem_deathcam_firstperson", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] First Person Deathcam Mode.")
CreateConVar( "gibsystem_blood_effect", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Blood Effect.")
CreateConVar( "gibsystem_blood_time", 5 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Blood Effect's Time.")
CreateConVar( "gibsystem_blood_time_body", 30 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Blood Effect's Time.")
CreateConVar( "gibsystem_death_express", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Death Express.")
CreateConVar( "gibsystem_random_bodygroup", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Random Bodygroup.")
CreateConVar( "gibsystem_random_skin", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Random Skin.")
CreateConVar( "gibsystem_rope", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Rope.")
CreateConVar( "gibsystem_rope_strength", 1000 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Rope Strength.")
CreateConVar( "gibsystem_body_mass", 10 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Body Mass.")
CreateConVar( "gibsystem_head_mass", 20 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Head Mass.")
CreateConVar( "gibsystem_gib_group", "headless" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Gib Group.")
CreateConVar( "gibsystem_gib_name", "random" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Gib Name.")
CreateConVar( "gibsystem_experiment", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Experimental Features.")
CreateConVar( "gibsystem_deathanimation", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable death animations.")
CreateConVar( "gibsystem_deathanimation_name", "random" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set death animation.")
CreateConVar( "gibsystem_model_category", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Category for each model (If set).")
CreateConVar( "gibsystem_gib_base_on_model", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Choose Model Base on materials.")
