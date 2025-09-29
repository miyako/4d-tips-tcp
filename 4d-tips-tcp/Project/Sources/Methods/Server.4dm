//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($processClass : 4D:C1709.Class; $processName : Text)

Case of 
	: (Count parameters:C259=2)
		
		If ($processName=Current process name:C1392)
			$processClass.new()
		Else 
			var $processes : Collection
			$processes:=Process activity:C1495(Processes only:K5:35).processes.query("name == :1 and type == :2"; $processName; Worker process:K36:32)
			If ($processes.length=0)
				CALL WORKER:C1389($processName; Current method name:C684; $processClass; $processName)
			End if 
		End if 
		
End case 