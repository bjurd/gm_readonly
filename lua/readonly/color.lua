AddCSLuaFile()

local ColorGroup = gm_readonly.InitializeGroup("Color")

local MetaTable = ColorGroup.MetaTable
local List = ColorGroup.List

function MetaTable:MarkReadOnly(State)
	State = tobool(State)

	if not State then
		List[self] = nil
	elseif not List[self] then
		local DataTable = {} -- Colors are just tables in disguise so we must proxy their values

		DataTable.r = self.r
		DataTable.g = self.g
		DataTable.b = self.b
		DataTable.a = self.a

		rawset(self, "r", nil) -- Force __index calls
		rawset(self, "g", nil)
		rawset(self, "b", nil)
		rawset(self, "a", nil)

		List[self] = DataTable
	end
end

function MetaTable:IsReadOnly(self)
	return List[self] ~= nil
end

gm_readonly.BasicDetour(ColorGroup, "__index", function(self, Original, Key)
	if List[self] then
		local DataTable = List[self]

		if DataTable[Key] then
			return DataTable[Key]
		end
	end

	if istable(Original) then
		return Original[Key]
	elseif isfunction(Original) then
		return Original(self, Key)
	else
		return nil
	end
end)

gm_readonly.BasicDetour(ColorGroup, "__newindex", function(self, Original, Key, Value)
	if List[self] then
		local DataTable = List[self]

		if DataTable[Key] then
			error("Tried to modify a read only value")
			return
		end
	end

	if istable(Original) then
		return rawset(Original, Key, Value)
	elseif isfunction(Original) then
		return Original(self, Key, Value)
	else
		return nil
	end
end)

gm_readonly.BlockingDetour(ColorGroup, "AddBlackness")
gm_readonly.BlockingDetour(ColorGroup, "AddBrightness")
gm_readonly.BlockingDetour(ColorGroup, "AddHue")
gm_readonly.BlockingDetour(ColorGroup, "AddLightness")
gm_readonly.BlockingDetour(ColorGroup, "AddSaturation")
gm_readonly.BlockingDetour(ColorGroup, "AddWhiteness")
gm_readonly.BlockingDetour(ColorGroup, "SetBlackness")
gm_readonly.BlockingDetour(ColorGroup, "SetBrightness")
gm_readonly.BlockingDetour(ColorGroup, "SetHue")
gm_readonly.BlockingDetour(ColorGroup, "SetLightness")
gm_readonly.BlockingDetour(ColorGroup, "SetSaturation")
gm_readonly.BlockingDetour(ColorGroup, "SetUnpacked")
gm_readonly.BlockingDetour(ColorGroup, "SetWhiteness")
