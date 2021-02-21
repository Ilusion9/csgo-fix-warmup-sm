#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

public Plugin myinfo =
{
	name = "Fix Competitive Warmup",
	author = "Ilusion9",
	description = "Fix competitive warmup.",
	version = "1.1",
	url = "https://github.com/Ilusion9/"
};

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "logic_script", true) || StrEqual(classname, "trigger_multiple", true))
	{
		SDKHook(entity, SDKHook_Spawn, SDK_OnEntitySpawn);
	}
}

public void SDK_OnEntitySpawn(int entity)
{
	if (entity < 0)
	{
		entity = EntRefToEntIndex(entity);
		if (entity == INVALID_ENT_REFERENCE)
		{
			return;
		}
	}
	
	char scripts[256];
	GetEntPropString(entity, Prop_Data, "m_iszVScripts", scripts, sizeof(scripts));
	
	// remove this entity
	if (StrEqual(scripts, "warmup/warmup_arena.nut", true) || StrEqual(scripts, "warmup/warmup_teleport.nut", true))
	{
		DispatchKeyValue(entity, "vscripts", "");
		DispatchKeyValue(entity, "targetname", "");
	}
}
