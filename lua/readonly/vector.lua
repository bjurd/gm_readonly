AddCSLuaFile()

local VectorGroup = gm_readonly.InitializeGroup("Vector")

gm_readonly.SetupBasicMetas(VectorGroup)

gm_readonly.BlockingDetour(VectorGroup, "Add")
gm_readonly.BlockingDetour(VectorGroup, "Div")
gm_readonly.BlockingDetour(VectorGroup, "Mul")
gm_readonly.BlockingDetour(VectorGroup, "Negate")
gm_readonly.BlockingDetour(VectorGroup, "Normalize")
gm_readonly.BlockingDetour(VectorGroup, "Random")
gm_readonly.BlockingDetour(VectorGroup, "Rotate")
gm_readonly.BlockingDetour(VectorGroup, "Set")
gm_readonly.BlockingDetour(VectorGroup, "SetUnpacked")
gm_readonly.BlockingDetour(VectorGroup, "Sub")
gm_readonly.BlockingDetour(VectorGroup, "Zero")
