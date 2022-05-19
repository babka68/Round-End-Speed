#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Round End Speed", 
	author = "babka68", 
	description = "Изменяет значение скорости всех игроков, в конце раунда.", 
	version = "1.0", 
	url = "https://vk.com/zakazserver68"
};

// ConVar
bool g_bEnable_Speed;
float g_fSpeed_Value;

// offsets
int g_flLaggedMovementValue;

public void OnPluginStart() {
	
	HookEvent("round_end", Round_End_Speed, EventHookMode_Pre);
	
	g_flLaggedMovementValue = FindSendPropInfo("CCSPlayer", "m_flLaggedMovementValue");
	
	if (g_flLaggedMovementValue == -1) {
		SetFailState("Couldnt find the m_flLaggedMovementValue offset!");
	}
	
	ConVar cvar;
	cvar = CreateConVar("sm_enable_speed", "1", "1 - Включить плагин, 0 - Выключить", _, true, 0.0, true, 1.0);
	cvar.AddChangeHook(CVarChanged_Enable_Speed);
	g_bEnable_Speed = cvar.BoolValue;
	
	cvar = CreateConVar("sm_value_speed", "2.0", "Значение скорости в конце раунда (по умолчанию 1.0)", _, true, 1.0, true, 10.0);
	cvar.AddChangeHook(CVarChangedRoundEndSpeed);
	g_fSpeed_Value = cvar.FloatValue;
	
	AutoExecConfig(true, "round_end_speed");
}

public void CVarChanged_Enable_Speed(ConVar cvar, const char[] oldValue, const char[] newValue) {
	g_bEnable_Speed = cvar.BoolValue;
}

public void CVarChangedRoundEndSpeed(ConVar cvar, const char[] oldValue, const char[] newValue) {
	g_fSpeed_Value = cvar.FloatValue;
}

public Action Round_End_Speed(Event event, const char[] name, bool dontBroadcast) {
	if (g_bEnable_Speed) {
		for (int i = 1; i <= MaxClients; ++i)
		if (IsClientInGame(i) && IsPlayerAlive(i)) {
			SetEntDataFloat(i, g_flLaggedMovementValue, g_fSpeed_Value);
		}
	}
} 
