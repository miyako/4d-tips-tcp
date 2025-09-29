property port : Integer
property listener : 4D:C1709.TCPListener

Class constructor($port : Integer)
	
	This:C1470.port:=$port=0 ? 1440 : $port
	This:C1470.listener:=4D:C1709.TCPListener.new(This:C1470.port; This:C1470)
	
Function onConnection($listener : 4D:C1709.TCPListener; $event : 4D:C1709.TCPEvent) : cs:C1710.Server
	
	return cs:C1710.Server.new($listener)
	
Function onError($listener : 4D:C1709.TCPListener; $event : 4D:C1709.TCPEvent)
	
Function onTerminate($listener : 4D:C1709.TCPListener; $event : 4D:C1709.TCPEvent)