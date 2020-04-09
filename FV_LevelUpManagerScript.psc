Scriptname FV_LevelUpManagerScript extends Quest

Group Actor_Values
	ActorValue Property FV_HasHadNukaAcid Auto
	ActorValue Property Strength Auto
	ActorValue Property Perception Auto
	ActorValue Property Endurance Auto
	ActorValue Property Charisma Auto
	ActorValue Property Intelligence Auto
	ActorValue Property Agility Auto
	ActorValue Property Luck Auto
	ActorValue Property FV_PredLevel Auto
	ActorValue Property FV_PreyLevel Auto
	ActorValue Property FV_VoreXP Auto
EndGroup

Group RefAlias
	Faction Property HasBeenCompanionFaction Auto
	RefCollectionAlias Property ActiveCompanions const auto
EndGroup

Group Globals
	GlobalVariable Property FV_VoreLevelPoints Auto
	GlobalVariable Property FV_CompanionPredLevel Auto
	GlobalVariable Property FV_CompanionPreyLevel Auto
	GlobalVariable Property FV_CompanionVoreXP Auto
EndGroup

Group StatTraits
	Perk Property FV_PerkPredatorBasic Auto
	int Property BasicLevel = 1 Auto
	Perk Property FV_PerkPredatorMedium Auto
	int Property MediumLevel = 10 Auto
	Perk Property FV_PerkPredatorTough Auto
	int Property ToughLevel = 20 Auto
	Perk Property FV_PerkPredatorAdvanced Auto
	int Property AdvancedLevel = 35 Auto
	Perk Property FV_PerkPredatorEpic Auto
	int Property EpicLevel = 50 Auto
EndGroup

Group Potions
	Spell Property FV_spNPC_PerkCheck Auto
EndGroup

Group Quests
	FV_ConsumptionRegistryScript Property FV_ConsumptionRegistry Auto
	FollowersScript Property Followers Auto
EndGroup

string MenuName = "LevelUpVore"
string MenuPath = "LevelUpVore"
string rootPath = "root1"

Event OnInit()
	RegisterLevelUpVoreMenu()
	RegisterEvents()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	RegisterLevelUpVoreMenu()
EndEvent

Event FV_ConsumptionRegistryScript.VoreLevelUp(FV_ConsumptionRegistryScript akSender, Var[] akArgs)			;akArgs[0] = CurrentPred
	Actor ActorToLevel = akArgs[0] as actor
	FV_ConsumptionRegistry.trace(self, "Received level up event for " + ActorToLevel)
	CheckTraits(ActorToLevel)
	CheckGlobal(ActorToLevel)
	LevelActor(ActorToLevel)
EndEvent

Event FollowersScript.CompanionChange(FollowersScript akSend, Var[] akArgs)			;akArgs[0] => actor companion, akArgs[1] => bool iscompanion
	LevelActor(akArgs[0] as Actor)
EndEvent

Function OnPlayerChooseLevel()
	debug.trace("received OnPlayerChooseLevel event")
	Actor PlayerRef = Game.GetPlayer()
	CheckTraits(PlayerRef)
	CheckGlobal(PlayerRef)
	LevelActor(PlayerRef)
EndFunction

Function RegisterEvents()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterForCustomEvent(Followers, "CompanionChange")
	RegisterForCustomEvent(FV_ConsumptionRegistry, "VoreLevelUp")
	RegisterForExternalEvent("onPlayerLevelChoice", "OnPlayerChooseLevel")
EndFunction

Function RegisterLevelUpVoreMenu()
	if(!UI.IsMenuRegistered(MenuName))
		UI:MenuData data = new UI:MenuData
		data.MenuFlags = 0x4006DD	;this is a bitwise calculation of 0x01 | 0x04 | 0x08 | 0x10 | 0x40 | 0x80 | 0x200 | 0x400 | 0x400000 = 0x4006DD
		;data.ExtendedFlags = FlagNone
		data.Depth = 0x09
		UI.RegisterCustomMenu(MenuName, MenuPath, rootPath, data)
	EndIf
EndFunction

Function CheckTraits(Actor akActorToLevel)
	If(akActorToLevel.GetValue(FV_PredLevel) >= EpicLevel && !akActorToLevel.HasPerk(FV_PerkPredatorAdvanced))
		akActorToLevel.AddPerk(FV_PerkPredatorEpic)
	ElseIf(akActorToLevel.GetValue(FV_PredLevel) >= AdvancedLevel && akActorToLevel.GetValue(FV_PredLevel) < EpicLevel && !akActorToLevel.HasPerk(FV_PerkPredatorTough))
		akActorToLevel.AddPerk(FV_PerkPredatorAdvanced)
	ElseIf(akActorToLevel.GetValue(FV_PredLevel) >= ToughLevel && akActorToLevel.GetValue(FV_PredLevel) < AdvancedLevel && !akActorToLevel.HasPerk(FV_PerkPredatorMedium))
		akActorToLevel.AddPerk(FV_PerkPredatorTough)
	ElseIf(akActorToLevel.GetValue(FV_PredLevel) >= MediumLevel && akActorToLevel.GetValue(FV_PredLevel) < ToughLevel && !akActorToLevel.HasPerk(FV_PerkPredatorBasic))
		akActorToLevel.AddPerk(FV_PerkPredatorMedium)
	ElseIf(akActorToLevel.GetValue(FV_PredLevel) >= BasicLevel && akActorToLevel.GetValue(FV_PredLevel) < MediumLevel && !akActorToLevel.HasPerk(FV_PerkPredatorBasic))
		akActorToLevel.AddPerk(FV_PerkPredatorBasic)
	EndIf
EndFunction

Function CheckGlobal(Actor ActorToLevel)
	If(ActorToLevel == Game.GetPlayer() && Game.GetPlayer().GetValue(FV_HasHadNukaAcid) == 1)
		float PlayerPredLevel = Game.GetPlayer().GetValue(FV_PredLevel)
		float PlayerPreyLevel = Game.GetPlayer().GetValue(FV_PreyLevel)
		FV_CompanionVoreXP.SetValue(Game.GetPlayer().GetValue(FV_VoreXP))
		If(PlayerPredLevel > FV_CompanionPredLevel.GetValue())
			FV_CompanionPredLevel.SetValue(PlayerPredLevel)
		EndIf
		If(PlayerPreyLevel > FV_CompanionPreyLevel.GetValue())
			FV_CompanionPreyLevel.SetValue(PlayerPreyLevel)
		EndIf
	ElseIf(ActiveCompanions.Find(ActorToLevel) >= 0 && Game.GetPlayer().GetValue(FV_HasHadNukaAcid) == 0)
		Int i = 0
		FV_CompanionVoreXP.SetValue(ActorToLevel.GetValue(FV_VoreXP))
		While(i < ActiveCompanions.GetCount())
			If((ActiveCompanions.GetAt(i) as Actor).GetValue(FV_PredLevel) > FV_CompanionPredLevel.GetValue())
				FV_CompanionPredLevel.SetValue((ActiveCompanions.GetAt(i) as Actor).GetValue(FV_PredLevel))
			EndIf
			If((ActiveCompanions.GetAt(i) as Actor).GetValue(FV_PreyLevel) > FV_CompanionPreyLevel.GetValue())
				FV_CompanionPreyLevel.SetValue((ActiveCompanions.GetAt(i) as Actor).GetValue(FV_PreyLevel))
			EndIf
			i += 1
		EndWhile
	EndIf
EndFunction

Function LevelActor(Actor ActorToLevel)
	
	If(ActorToLevel == Game.GetPlayer() || ActiveCompanions.Find(ActorToLevel) >= 0)
		Int i = 0
		;FV_ConsumptionRegistry.trace(self, "  Parsed active companions for max level")			;Remove this line before release
		Actor Companion
		While(i < ActiveCompanions.GetCount())
			Companion = ActiveCompanions.GetAt(i) as Actor
			If(Companion.Is3DLoaded() && Companion.IsInFaction(HasBeenCompanionFaction))
				If(Companion.GetValue(FV_PredLevel) > 0 && FV_CompanionPredLevel.GetValue() > Companion.GetValue(FV_PredLevel))
					Companion.ModValue(FV_PredLevel, FV_CompanionPredLevel.GetValue() - Companion.GetValue(FV_PredLevel))
					Companion.ModValue(FV_VoreXP, FV_CompanionVoreXP.GetValue() - Companion.GetValue(FV_VoreXP))
					FV_spNPC_PerkCheck.Cast(Game.GetPlayer(), Companion)
					CheckTraits(Companion)
				ElseIf(FV_CompanionPreyLevel.GetValue() > Companion.GetValue(FV_PreyLevel))
					Companion.ModValue(FV_PreyLevel, FV_CompanionPreyLevel.GetValue() - Companion.GetValue(FV_PreyLevel))
					Companion.ModValue(FV_VoreXP, FV_CompanionVoreXP.GetValue() - Companion.GetValue(FV_VoreXP))
					FV_spNPC_PerkCheck.Cast(Game.GetPlayer(), Companion)
				EndIf
			EndIf
			i += 1
		EndWhile		
	ElseIf(ActiveCompanions.Find(ActorToLevel) < 0)
		FV_spNPC_PerkCheck.Cast(ActorToLevel, ActorToLevel)
		CheckTraits(ActorToLevel)
	EndIf
	FV_ConsumptionRegistry.trace(self, "Finished level up event for " + ActorToLevel)
EndFunction