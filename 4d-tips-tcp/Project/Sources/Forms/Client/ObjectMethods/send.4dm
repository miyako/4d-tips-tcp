If (FORM Event:C1606.code=On Clicked:K2:4)
	
	var $data : Blob
	var $KB; $MB : Integer
	$KB:=1024
	$MB:=1024^2
	
	Case of 
		: (Form:C1466.small)
			SET BLOB SIZE:C606($data; 1*$MB)
		: (Form:C1466.medium)
			SET BLOB SIZE:C606($data; 10*$MB)
		: (Form:C1466.large)
			SET BLOB SIZE:C606($data; 100*$MB)
	End case 
	
	Form:C1466.sendData($data)
	
End if 