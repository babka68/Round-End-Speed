#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Round End Speed", 
	author = "babka68", 
	description = "Данный плагин позволяет выдать быстрый бег игрокам в конце раунда", 
	version = "1.0", 
	url = "https://vk.com/zakazserver68"
};

int g_iCount;
float g_fValue;
bool b_EnableSpeed;

public void OnPluginStart()
{
	ConVar cvar;
	
	cvar = CreateConVar("sm_enable_speed", "1", "1 - Включить, 0 - Выключить плагин", _, true, 0.0, true, 1.0);
	cvar.AddChangeHook(CVarChanged_Enable_Speed);
	b_EnableSpeed = cvar.BoolValue;
	
	cvar = CreateConVar("sm_value_speed", "2.0", "Значение (Число с плавающей запятой) скорости (по умолчанию 1.0)", _, true, 1.0, true, 10.0);
	cvar.AddChangeHook(CVarChangedRoundEndSpeed);
	g_fValue = cvar.FloatValue;
	
	HookEvent("round_end", RoundEndSpeedCallback, EventHookMode_Pre);
	g_iCount = FindSendPropInfo("CCSPlayer", "m_flLaggedMovementValue");
	
	AutoExecConfig(true, "round_end_speed");
}

public void CVarChanged_Enable_Speed(ConVar CVar, const char[] oldValue, const char[] newValue)
{
	b_EnableSpeed = CVar.BoolValue;
}

public void CVarChangedRoundEndSpeed(ConVar CVar, const char[] oldValue, const char[] newValue)
{
	g_fValue = CVar.FloatValue;
}

public Action RoundEndSpeedCallback(Handle event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i <= MaxClients; ++i)
	if (IsClientInGame(i) && IsPlayerAlive(i) && b_EnableSpeed)
	{
		SetEntDataFloat(i, g_iCount, g_fValue);
	}
}
