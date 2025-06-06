
AddCSLuaFile()
local FCVAR = bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED)
CreateConVar( "gibsystem_enabled", 1 , FCVAR, "[Gib System] Enable Gib System.")
CreateConVar( "gibsystem_gibbing_player", 1 , FCVAR, "[Gib System] Enable Gib System for Players.")
CreateConVar( "gibsystem_gibbing_npc", 1 , FCVAR, "[Gib System] Enable Gib System for NPCs.")
CreateConVar( "gibsystem_random_finger_rotating", 1 , FCVAR, "[Gib System] Enable random finger rotating.")
CreateConVar( "gibsystem_random_toe_rotating", 1 , FCVAR, "[Gib System] Enable random toe rotating.")
CreateConVar( "gibsystem_random_gf2_toe_rotating", 0 , FCVAR, "[Gib System] Enable random toe(GF2) rotating.")
CreateConVar( "gibsystem_ragdoll_convulsion", 0 , FCVAR, "[Gib System] Enable ragdoll convulsion.")
CreateConVar( "gibsystem_ragdoll_collisiongroup", 11 , FCVAR, "[Gib System] Set ragdoll Collision Group.")
CreateConVar( "gibsystem_ragdoll_removetimer", 10 , FCVAR, "[Gib System] Set ragdoll remove timer.")
CreateClientConVar( "gibsystem_deathcam_mode", 1 , true, false )
CreateConVar( "gibsystem_blood_effect", 0 , FCVAR, "[Gib System] Enable Blood Effect.")
CreateConVar( "gibsystem_blood_decal", 1 , FCVAR, "[Gib System] Enable Blood Decal.")
CreateConVar( "gibsystem_blood_time", 5 , FCVAR, "[Gib System] Set Blood Effect's Time.")
CreateConVar( "gibsystem_blood_time_body", 15 , FCVAR, "[Gib System] Set Blood Effect's Time.")
CreateConVar( "gibsystem_death_express", 1 , FCVAR, "[Gib System] Enable Death Express.")
CreateConVar( "gibsystem_random_bodygroup", 1 , FCVAR, "[Gib System] Enable Random Bodygroup.")
CreateConVar( "gibsystem_random_skin", 0 , FCVAR, "[Gib System] Enable Random Skin.")
CreateConVar( "gibsystem_rope", 0 , FCVAR, "[Gib System] Enable Rope.")
CreateConVar( "gibsystem_rope_strength", 1000 , FCVAR, "[Gib System] Rope Strength.")
CreateConVar( "gibsystem_body_mass", 0 , FCVAR, "[Gib System] Body Mass.")
CreateConVar( "gibsystem_head_mass", 0 , FCVAR, "[Gib System] Head Mass.")
CreateConVar( "gibsystem_gib_group", "headless" , FCVAR, "[Gib System] Set Gib Group.")
CreateConVar( "gibsystem_gib_name", "random" , FCVAR, "[Gib System] Set Gib Name.")
CreateConVar( "gibsystem_deathanimation", 1 , FCVAR, "[Gib System] Enable death animations.")
CreateConVar( "gibsystem_deathanimation_alt", 0 , FCVAR, "[Gib System] Enable Alt death animations.")
CreateConVar( "gibsystem_deathanimation_name", "random" , FCVAR, "[Gib System] Set death animation.")
CreateConVar( "gibsystem_deathanimation_body_health", 25 , FCVAR, "[Gib System] Body's Health.")
CreateClientConVar( "gibsystem_model_category", 1 , true, false )
CreateConVar( "gibsystem_gib_base_on_model", 1 , FCVAR, "[Gib System] Choose Model Base on materials.")
CreateConVar( "gibsystem_pee", 0 , FCVAR, "[Gib System] Enable Pee.")
CreateConVar( "gibsystem_pee_time", 10 , FCVAR, "[Gib System] Set Pee's Time.")

