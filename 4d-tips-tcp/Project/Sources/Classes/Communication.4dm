Class constructor
	
Function fromHeader($data : 4D:C1709.Blob) : Object
	
	var $header : Object
	$header:=Try(JSON Parse:C1218(Convert to text:C1012($data; "utf-8"); Is object:K8:27))
	
	return $header
	
Function toHeader($data : Object) : 4D:C1709.Blob
	
	var $header : Blob
	Try(CONVERT FROM TEXT:C1011(JSON Stringify:C1217($data); "utf-8"; $header))
	
	return $header