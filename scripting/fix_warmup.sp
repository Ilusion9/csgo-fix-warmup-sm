#pragma newdecls required

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
	if (StrEqual(classname, "logic_script", true) 
		|| StrEqual(classname, "trigger_multiple", true))
	{
		SDKHook(entity, SDKHook_Spawn, SDK_OnEntitySpawn);
	}
}

public void SDK_OnEntitySpawn(int entity)
{
	char vScripts[256];
	GetEntPropString(entity, Prop_Data, "m_iszVScripts", vScripts, sizeof(vScripts));
	
	if (StrEqual(vScripts, "warmup/warmup_arena.nut", true) 
		|| StrEqual(vScripts, "warmup/warmup_teleport.nut", true))
	{
		DispatchKeyValue(entity, "vscripts", "");
		DispatchKeyValue(entity, "targetname", "");
	}
}
