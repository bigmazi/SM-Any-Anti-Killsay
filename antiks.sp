#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Anti-killsay",
	author = "bigmazi",
	description = "Gags players for a short time after they make a kill",
	version = "1.0",
	url = "https://steamcommunity.com/id/bmazi"
};

ConVar cv_gagDuration;
float g_canSayTime[MAXPLAYERS + 1];

public void OnPluginStart()
{
	cv_gagDuration = CreateConVar(
		"sm_antiks_gag_duration",
		"0",
		"Player will be gagged for THIS many seconds after making a kill (0 = disabled)",
		FCVAR_NONE,
		true, 0.0, true, 5.0);
	
	HookEvent("player_death", Event_PlayerDeath);
}

public void OnMapStart()
{
	for (int i = 0; i < sizeof(g_canSayTime); ++i)
		g_canSayTime[i] = 0.0;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] arg)
{
	return GetGameTime() > g_canSayTime[client]
		? Plugin_Continue
		: Plugin_Handled;
}

Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if (!cv_gagDuration.BoolValue)
		return Plugin_Continue;
	
	int client = GetClientOfUserId(event.GetInt("attacker"));	
	g_canSayTime[client] = GetGameTime() + cv_gagDuration.FloatValue;
	
	return Plugin_Continue;
}