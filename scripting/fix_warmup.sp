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
	// remove trigger_multiple
	if (StrEqual(classname, "trigger_multiple", true))
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
	
	// remove trigger_multiple only in warmup
	if (IsValveWarmupPeriod())
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

bool IsValveWarmupPeriod()
{
	return view_as<bool>(GameRules_GetProp("m_bWarmupPeriod"));
}
