local mod	= DBM:NewMod("AmnennartheColdbringer", "DBM-Party-Classic", 9)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(7358)
--mod:SetEncounterID(585)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 12675",
	"SPELL_CAST_SUCCESS 13009 12642"
)

--TODO, check/fix frostbolt spellId
local warningAmnennarsWrath			= mod:NewSpellAnnounce(13009, 2)

local specWarnFrostbolt				= mod:NewSpecialWarningInterrupt(12675, "HasInterrupt", nil, nil, 1, 2)
local specWarnFrostSpectres			= mod:NewSpecialWarningSwitch(13322, "-Healer", nil, nil, 1, 2)

local timerAmnennarsWrathCD			= mod:NewAITimer(180, 13009, nil, nil, nil, 2)
local timerFrostboltCD				= mod:NewAITimer(180, 12675, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON..DBM_CORE_MAGIC_ICON)
local timerSummonFrostSpectresCD	= mod:NewAITimer(180, 13322, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)

function mod:OnCombatStart(delay)
	timerAmnennarsWrathCD:Start(1-delay)
	timerFrostboltCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 12675 then
		timerFrostboltCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFrostbolt:Show(args.sourceName)
			specWarnFrostbolt:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 13009 then
		warningAmnennarsWrath:Show()
		timerAmnennarsWrathCD:Start()
	elseif args.spellId == 12642 then
		specWarnFrostSpectres:Show()
		specWarnFrostSpectres:Play("killmob")
		timerSummonFrostSpectresCD:Start()
	end
end
