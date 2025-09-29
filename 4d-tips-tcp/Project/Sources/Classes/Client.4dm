Class extends Communication

property port : Integer
property host : Text
property connection : 4D:C1709.TCPConnection
property data : 4D:C1709.Blob

Class constructor($port : Integer; $host : Text)
	
	Super:C1705()
	
	This:C1470.port:=$port=0 ? 1440 : $port
	This:C1470.host:=$host="" ? "127.0.0.1" : $host
	
Function start() : cs:C1710.Client
	
/*
do this here, not in the costructor.
this way we can receive callbacks in the form's event cycle (after DIALOG)
on in a pure worker divoced from any UI 
*/
	
	This:C1470.connection:=4D:C1709.TCPConnection.new(This:C1470.host; This:C1470.port; This:C1470)
	
	return This:C1470
	
Function onData($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent) : Object
	
	$header:=This:C1470.fromHeader($event.data)
	
	Case of 
		: ($header=Null:C1517)
		: ($header.message=Null:C1517)
		Else 
			
			Case of 
				: ($header.message="Oops!@")
					//abort transmission
				: ($header.message="Thanks!@")
					//  end transmission
				: ($header.message="Sure!@")
					//begin transmission
					This:C1470.connection.send(This:C1470.data)
			End case 
			
	End case 
	
	return $header
	
Function sendData($data : 4D:C1709.Blob) : cs:C1710.Client
	
	If (This:C1470.isConnected)
		
		var $header : 4D:C1709.Blob
		$header:=This:C1470.toHeader({\
			size: BLOB size:C605($data); \
			message: "Hey! I want to send some data!"\
			})
		
		This:C1470.connection.send($header)
		This:C1470.data:=$data
		
	End if 
	
	return This:C1470
	
Function get isConnected() : Boolean
	
	return (This:C1470.connection#Null:C1517) && (Not:C34(This:C1470.connection.closed))
	
Function onConnection($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent) : Object
	
Function onError($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
Function onTerminate($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
Function onShutdown($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	