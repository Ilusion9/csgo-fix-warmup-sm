#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

public Plugin myinfo =
{
	name = "Fix Competitive Warmup",
	author = "Ilusion9",
	description = "Fix competitive warmup.",
	version = "1.0",
	url = "https://github.com/Ilusion9/"
};

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "logic_script", true))
	{
		SDKHook(entity, SDKHook_SpawnPost, SDK_OnEntitySpawn_Post);
	}
}

public void SDK_OnEntitySpawn_Post(int entity)
{
	if (entity < -1)
	{
		entity = EntRefToEntIndex(entity);
		if (entity == INVALID_ENT_REFERENCE)
		{
			return;
		}
	}
	
	char vscripts[256];
	GetEntPropString(entity, Prop_Data, "m_iszVScripts", vscripts, sizeof(vscripts));
	
	// remove this script
	if (StrEqual(vscripts, "warmup/warmup_arena.nut", true) || StrEqual(vscripts, "warmup/warmup_teleport.nut", true))
	{
		RequestFrame(Frame_RemoveEntity, EntIndexToEntRef(entity));
	}
}

public void Frame_RemoveEntity(int reference)
{
	int entity = EntRefToEntIndex(reference);
	if (entity == INVALID_ENT_REFERENCE)
	{
		return;
	}
	
	RemoveEntity(entity);
}