//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($processClass : 4D:C1709.Class; $formName : Text; $windowType : Integer; $h : Integer; $v : Integer; $params : Object)

Case of 
	: (Count parameters:C259=6)
		
		var $form : Object
		$form:=$processClass.new()
		
		var $window : Integer
		$window:=Open form window:C675($formName; $windowType; $h; $v)
		DIALOG:C40($formName; $form; *)
		
	: (Count parameters:C259=5)
		
		CALL WORKER:C1389(1; Current method name:C684; $processClass; $formName; $windowType; $h; $v; {})
		
End case 