AddCSLuaFile()

gm_readonly = gm_readonly or {}

gm_readonly.NoOp = function() return end
gm_readonly.WeakMeta = { ["__mode"] = "k" }

function gm_readonly.CreateWeakList()
	return setmetatable({}, gm_readonly.WeakMeta)
end

function gm_readonly.InitializeGroup(Name)
	local Group = gm_readonly[Name]
	if Group then return Group end

	Group = {}
	Group.Name = Name
	Group.List = gm_readonly.CreateWeakList()
	Group.MetaTable = FindMetaTable(Name)

	gm_readonly[Name] = Group

	return Group
end

function gm_readonly.SetupBasicMetas(Group)
	local MetaTable = Group.MetaTable
	local List = Group.List

	--[[ Not necessary
	gm_readonly.BasicDetour(Group, "__index", function(self, Original, Key)
		return rawget(MetaTable, Key) or Original(self, Key)
	end)
	--]]

	gm_readonly.BasicDetour(Group, "__newindex", function(self, Original, Key, Value)
		if List[self] then
			error("Tried to modify a read only value")
			return
		end

		if istable(Original) then
			return rawset(Original, Key, Value)
		elseif isfunction(Original) then
			return Original(self, Key, Value)
		else
			return nil
		end
	end)

	--[[ Not necessary because the list is weak
	gm_readonly.BasicDetour(Group, "__gc", function(self, Original)
		if List[self] then
			List[self] = nil
		end

		return Original(self)
	end)
	--]]

	MetaTable.MarkReadOnly = function(self, State)
		List[self] = Either(tobool(State), true, nil)
	end

	MetaTable.IsReadOnly = function(self)
		return List[self] ~= nil
	end
end

-- These functions should use metatable instead of object passthrough but ehhhhhhhhhhhhh
function gm_readonly.GetMethod(MetaTable, MethodName)
	local MetaMethod = rawget(MetaTable, MethodName)

	if MetaMethod == nil then
		-- error(Format("Couldn't find method '%s'", MethodName))
		-- MsgN(Format("Couldn't find method '%s' in '%s'", MethodName, MetaTable.MetaName or "UNK"))
		return gm_readonly.NoOp -- Don't die just in case we want to force detour something (like __gc)
	end

	return MetaMethod
end

function gm_readonly.BasicDetour(Group, MethodName, Callback)
	local MetaTable = Group.MetaTable
	local MetaMethod = gm_readonly.GetMethod(MetaTable, MethodName)

	local OriginalName = Format("o%s", MethodName)
	MetaTable[OriginalName] = MetaTable[OriginalName] or MetaMethod

	local OriginalMethod = MetaTable[OriginalName]

	MetaTable[MethodName] = function(self, ...)
		-- Assume callback is valid because it better be,,,
		return Callback(self, OriginalMethod, ...)
	end
end

function gm_readonly.BlockingDetour(Group, MethodName)
	local List = Group.List

	gm_readonly.BasicDetour(Group, MethodName, function(self, Original, ...)
		if List[self] then
			-- This could be made fancy to throw original errors as well
			-- and only this when there are no original errors
			-- using pcall and a dummy object, but that'd be too slow
			-- to be worth it
			error("Tried to modify a read only value")
		end

		return Original(self, ...) -- Just in case some funny guy detours error
	end)
end

-- Basic stuff
include("vector.lua")
include("angle.lua")
include("color.lua")

vector_origin:MarkReadOnly(true)
angle_zero:MarkReadOnly(true)
color_white:MarkReadOnly(true)
color_black:MarkReadOnly(true)
color_transparent:MarkReadOnly(true)
