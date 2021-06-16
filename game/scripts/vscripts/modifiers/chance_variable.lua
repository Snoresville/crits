chance_variable = chance_variable or class({})

-- check out https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API

-- The modifier Tooltip is inside resource/addon_english.txt (Have fun playing)


function chance_variable:GetTexture() return "sven_gods_strength" end -- get the icon from a different ability

function chance_variable:IsPermanent() return true end
function chance_variable:RemoveOnDeath() return false end
function chance_variable:IsHidden() return false end 	-- we can hide the modifier
function chance_variable:IsDebuff() return false end 	-- make it red or green

function chance_variable:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function chance_variable:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
		}
	end
end

function chance_variable:OnCreated(event)
	if IsServer() then
		self.accumulated_damage = 0
		self:StartIntervalThink(20)

		if self:GetParent():IsRangedAttacker() then
			self:SetStackCount(2)
		else
			self:SetStackCount(15)
		end
	end
end

function chance_variable:OnIntervalThink()
	local crit_base
	local crit_ramp

	if self:GetParent():IsRangedAttacker() then
		crit_base = 2
		crit_ramp = 10/8000
	else
		crit_base = 15
		crit_ramp = 45/8000
	end

	self:SetStackCount(crit_base + crit_ramp * self.accumulated_damage)
	self.accumulated_damage = 0
end