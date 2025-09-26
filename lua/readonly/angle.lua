AddCSLuaFile()

local AngleGroup = gm_readonly.InitializeGroup("Angle")

gm_readonly.SetupBasicMetas(AngleGroup)

gm_readonly.BlockingDetour(AngleGroup, "Add")
gm_readonly.BlockingDetour(AngleGroup, "Div")
gm_readonly.BlockingDetour(AngleGroup, "Mul")
gm_readonly.BlockingDetour(AngleGroup, "Normalize")
gm_readonly.BlockingDetour(AngleGroup, "Random")
gm_readonly.BlockingDetour(AngleGroup, "RotateAroundAxis")
gm_readonly.BlockingDetour(AngleGroup, "Set")
gm_readonly.BlockingDetour(AngleGroup, "SetUnpacked")
gm_readonly.BlockingDetour(AngleGroup, "Sub")
gm_readonly.BlockingDetour(AngleGroup, "Zero")
