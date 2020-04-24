#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#undef REQUIRE_PLUGIN
#include <jumptracker>

#define PLUGIN_NAME "Example JumpTracker Plugin"
#define PLUGIN_AUTHOR ""
#define PLUGIN_DESCRIPTION ""
#define PLUGIN_VERSION "0.1.0"
#define PLUGIN_URL "https://alliedmods.net"

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
}

public void JT_OnClientJumped(int client) {
	PrintToChatAll("[JT] %N has jumped.", client);
}

public void JT_OnClientLanded(int client) {
	PrintToChatAll("[JT] %N has landed.", client);
}