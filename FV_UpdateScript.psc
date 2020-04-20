ScriptName FV_UpdateScript extends Quest

Group Update301
	Perk Property FV_ReformPerk01 Auto
EndGroup

Group Update302
	GlobalVariable Property FV_VoreRaiderEnabled Auto
	GlobalVariable Property FV_VoreRoyaltyEnabled Auto
EndGroup

Actor PlayerRef

Bool Update301Finished = false
Bool Update302Finished = false

Event OnInit()
	PlayerRef = Game.GetPlayer()
	RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
	Update302Finished = true
	UpdateMod()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	UpdateMod()
EndEvent

Function UpdateMod()
	If(!Update301Finished)
		If(PlayerRef.HasPerk(FV_ReformPerk01))
			PlayerRef.RemovePerk(FV_ReformPerk01)
			PlayerRef.AddPerk(FV_ReformPerk01)
		EndIf
		Update301Finished = true
	EndIf
	
	If(!Update302Finished)
		FV_VoreRaiderEnabled.SetValue(1)
		FV_VoreRoyaltyEnabled.SetValue(1)
		Update302Finished = true
	EndIf
EndFunction
