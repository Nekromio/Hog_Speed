#pragma semicolon 1
#pragma newdecls required

#include <hog_core>

ConVar
	cvHogSpeed;

Handle
	hTimerCheck[MAXPLAYERS+1];

public Plugin myinfo = 
{
	name = "[Hog] Speed/Скорость",
	author = "Nek.'a 2x2 | ggwp.site ",
	description = "Устанавливает скорость Кабану",
	version = "1.0.0",
	url = "https://ggwp.site/"
};

public void OnPluginStart()
{
	cvHogSpeed = CreateConVar("sm_hog_speed", "2.0", "Скорость кабана");

	AutoExecConfig(true, "hog_speed", "hog");
}

public void OnClientDisconnect(int client)
{
	if(!HOG_ValideClient(client))
		return;

	delete hTimerCheck[client];
}

public int HOG_ActiveStart(int client)
{
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", cvHogSpeed.FloatValue);

	delete hTimerCheck[client];
	hTimerCheck[client] = CreateTimer(1.0, CheckHog, GetClientUserId(client), TIMER_REPEAT);

	return 0;
}

Action CheckHog(Handle hTimer, int UserId)
{
	int client = GetClientOfUserId(UserId);

	if(HOG_ValideClient(client))
	{
		if(HOG_GetStstusHog(client) == 2)
		{
			float fSpeed = GetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue");
			if(fSpeed != cvHogSpeed.FloatValue)
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", cvHogSpeed.FloatValue);
			return Plugin_Continue;
		}
		else
		{
			hTimerCheck[client] = null;
			return Plugin_Stop;
		}
	}
	return Plugin_Stop;
}

public int HOG_Reset(int client)
{
	if(hTimerCheck[client])
		delete hTimerCheck[client];

	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
	return 0;
}