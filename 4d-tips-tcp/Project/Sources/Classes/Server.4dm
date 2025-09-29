Class extends Communication

property listener : 4D:C1709.TCPListener
property total : Integer
property data : 4D:C1709.Blob

Class constructor($listener : 4D:C1709.TCPListener)
	
	Super:C1705()
	
	This:C1470.listener:=$listener
	This:C1470.clear()
	
Function clear()
	
	This:C1470.total:=0
	This:C1470.data:=4D:C1709.Blob.new()
	
Function onData($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
	var $data : 4D:C1709.Blob
	$data:=$event.data
	
	If ($data.size<1000)
		var $header : Object
		$header:=This:C1470.fromHeader($data)
		Case of 
			: ($header=Null:C1517) || ($header.size=Null:C1517) || ($header.size<=0)
				//no header detected
			Else 
				This:C1470.clear()
				This:C1470.total:=$header.size
				$connection.send(This:C1470.toHeader({\
					message: ["Sure! send me"; $header.size; "bytes!"].join(" "); \
					size: This:C1470.data.size; \
					total: This:C1470.total; \
					complete: False:C215}))
				return 
		End case 
	End if 
	
	If (This:C1470.total#0)
		
		var $buf : Blob
		$buf:=This:C1470.data
		COPY BLOB:C558($data; $buf; 0; This:C1470.data.size; $data.size)
		This:C1470.data:=$buf
		
		If (This:C1470.data.size=This:C1470.total)
			$connection.send(This:C1470.toHeader({\
				message: ["Thanks! got all"; This:C1470.data.size; "bytes!"].join(" "); \
				size: This:C1470.data.size; \
				total: This:C1470.total; \
				complete: True:C214}))
			This:C1470.clear()
		End if 
		
	End if 
	
Function onConnection($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent) : Object
	
Function onError($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
Function onTerminate($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
Function onShutdown($connection : 4D:C1709.TCPConnection; $event : 4D:C1709.TCPEvent)
	
	