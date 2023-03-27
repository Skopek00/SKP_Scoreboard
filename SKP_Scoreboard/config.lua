Config = Config or {}

Config.OpenKey = 20

Config.MaxPlayers = GetConvarInt('sv_maxclients', 64) -- It returns 48 if it cant find the Convar Int
Config.PoliceJob = "police"
Config.MechanicJob = "mechanic"
Config.AmbulanceJob = "ambulance"

Config.ShowIDforALL = true