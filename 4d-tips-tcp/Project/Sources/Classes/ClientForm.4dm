Class extends Client

property small; medium; large : Boolean

Class constructor()
	
	Super:C1705()
	
Function onLoad() : cs:C1710.ClientForm
	
	This:C1470.small:=True:C214
	This:C1470.medium:=False:C215
	This:C1470.large:=False:C215
	
	This:C1470.start()
	
	var $property : Text
	For each ($property; This:C1470.connection)
		This:C1470[$property]:=This:C1470.connection[$property]
	End for each 
	
	return This:C1470
	
Function onUnload()
	
	If (This:C1470.isConnected)
		This:C1470.connection.shutdown()
	End if 
	
	KILL WORKER:C1390
	
Function onData($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
	var $header : Object
	$header:=Super:C1706.onData($connection; $event)
	
	If ($header#Null:C1517)
		If ($header.complete)
			ALERT:C41("data sent!")
		End if 
	End if 