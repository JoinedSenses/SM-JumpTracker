#include <sourcemod>
#include <sdktools>
#include <jumptracker>

#define PLUGIN_DESCRIPTION "Tracks when a player jumps and lands"
#define PLUGIN_VERSION "0.1.0"

Handle g_hForwardJumped;
Handle g_hForwardLanded;

bool g_bOnGroundLastFrame[MAXPLAYERS+1];
bool g_bPlayerJumped[MAXPLAYERS+1];

public Plugin myinfo = {
	name = "JumpTracker",
	author = "JoinedSenses",
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = ""
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	RegPluginLibrary("jumptracker");
}

public void OnPluginStart() {
	CreateConVar("sm_jumptracker_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD).SetString(PLUGIN_VERSION);

	g_hForwardJumped = CreateGlobalForward("JT_OnClientJumped", ET_Ignore, Param_Cell);
	g_hForwardLanded = CreateGlobalForward("JT_OnClientLanded", ET_Ignore, Param_Cell);

	HookEvent("player_death", eventClientStatusChanged);
	HookEvent("player_team", eventClientStatusChanged);
	if (GetEngineVersion() == Engine_TF2) {
		HookEvent("player_changeclass", eventClientStatusChanged);
	}
}

public void eventClientStatusChanged(Event event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(event.GetInt("userid"));

	if (client && g_bPlayerJumped[client]) {
		g_bPlayerJumped[client] = false;
	}
}

public Action OnPlayerRunCmd(int client, int& buttons) {
	if (IsFakeClient(client) || !IsPlayerAlive(client)) {
		return Plugin_Continue;
	}

	int onGround = GetEntityFlags(client) & FL_ONGROUND;
	if (((buttons & IN_JUMP) | onGround) == IN_JUMP && g_bOnGroundLastFrame[client]) {

		Call_StartForward(g_hForwardJumped);
		Call_PushCell(client);
		Call_Finish();

		g_bPlayerJumped[client] = true;
	}
	else if (g_bPlayerJumped[client] && onGround) {

		Call_StartForward(g_hForwardLanded);
		Call_PushCell(client);
		Call_Finish();

		g_bPlayerJumped[client] = false;
	}

	g_bOnGroundLastFrame[client] = !!onGround;
	
	return Plugin_Continue;
}