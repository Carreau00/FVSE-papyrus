Scriptname FV_NukaAcidScript extends activemagiceffect

Faction Property HasBeenCompanionFaction Auto
GlobalVariable Property FV_PlayerNeedsNuka Auto
GlobalVariable Property FV_FemaleVoreEnabled Auto
GlobalVariable Property FV_MaleVoreEnabled Auto
Perk Property FV_PredMeleePerk Auto
;Perk Property FV_BellyCapacityPerk Auto
Perk Property FV_PerkNPCVoreLevel Auto
Perk Property FV_PerkPredatorBasic Auto
Potion Property FV_EvoPredatorBasicInjector Auto
Weapon Property FV_SwallowNPC Auto
ActorValue Property FV_PredLevel Auto
ActorValue Property FV_HasHadNukaAcid Auto
ActorValue Property FV_SwallowStrength Auto
Potion Property FV_RemoveWeapons Auto

FV_ConsumptionRegistryScript Property FV_ConsumptionRegistry Auto

Event OnEffectStart(actor akTarget, actor akCaster)
	
	If(akCaster.GetValue(FV_PredLevel) == 0)
		akCaster.SetValue(FV_HasHadNukaAcid, 1)
		akCaster.SetValue(FV_SwallowStrength, 25)
		akCaster.ModValue(FV_PredLevel, 1)
		akCaster.EquipItem(FV_EvoPredatorBasicInjector, abSilent = true)
		;If(!akCaster.HasPerk(FV_BellyCapacityPerk))
		;	akCaster.AddPerk(FV_BellyCapacityPerk)
		;EndIf
		If(akCaster == Game.GetPlayer())
			FV_PlayerNeedsNuka.SetValue(0)
			FV_ConsumptionRegistry.MakePlayerPred()	
		EndIf
		Bool MakeNPCPred = false
		If(akCaster.GetLeveledActorBase().GetSex() == 1 && FV_FemaleVoreEnabled.GetValue() == 1)
			MakeNPCPred = true
		EndIf
		If(akCaster.GetLeveledActorBase().GetSex() == 0 && FV_MaleVoreEnabled.GetValue() == 1)
			MakeNPCPred = true
		EndIf
		If(MakeNPCPred && akCaster != Game.GetPlayer())
			If(!akCaster.IsInFaction(HasBeenCompanionFaction))
				akCaster.AddPerk(FV_PerkNPCVoreLevel)
			Else
				akCaster.EquipItem(FV_RemoveWeapons)
			EndIf
			akCaster.AddItem(FV_SwallowNPC)
			akCaster.EquipItem(FV_SwallowNPC)
			akCaster.AddPerk(FV_PredMeleePerk)
			akCaster.AddPerk(FV_PerkPredatorBasic)
		EndIf
	EndIf

EndEvent
