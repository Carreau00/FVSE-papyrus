ScriptName FV_UpdateScript extends Quest

Perk Property FV_ReformPerk01 Auto

Actor PlayerRef

Bool Update301Finished = false
Event OnInit()
	PlayerRef = Game.GetPlayer()
	RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
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
EndFunction
