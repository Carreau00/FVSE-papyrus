;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname followersript:Fragments:TopicInfos:TIF_FV_FrighteningGrowlQuest_0100AB17 Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE FV_FrighteningGrowlQuestScript
FV_FrighteningGrowlQuestScript kmyQuest = GetOwningQuest() as FV_FrighteningGrowlQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.SwallowDesire(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
