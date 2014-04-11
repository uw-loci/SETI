#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Copywrite 2013 Jeremy Bredfeldt - Morgridge Institute for Research, LOCI

 Script Function:
	Cuts and images with SETI.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;*** I M P O R T A N T *** (order is also important)

;open mach3, turn on controller, hit reset
;check to make sure spindle can spin freely!!!
;make sure vacuum is set up, and plugged into m8/m9 outlet, turn on vac
;make sure spindle power is connected to m3/m5 outlet
;turn on mill spindle and outlet box
;set mach3 to the toolpath page
;move the sample table such that the vice is centered on the right opening to the mill shroud
;zero the x-y position
;mount the sample into the vice using parallels
;cut one section off the top of the sample
;zero the z-position on mach3
;choose whether to use Clara or Q, or both, if only Q, then skip to QCAM*****
;align the sample under the clara microscope
;the sample should be in the upper left corner of the image to start
; above is for stitching
;turn on clara and open micromanager
;capture one image and save in a new directory, with imagej
;write the starting position and image dimensions into this script for clara
;QCAM******, only do the following using Qcam
;align the sample under the Q microscope
;open qcapture
;save one image in the new directory with q-capture
;set camera exposure time
;write the starting position and image dimensions into this script for Q
;!!!maximize mach3!!! before starting

;Typical Q capture settings:
;30 ms exposure Time
;8 bit depth
;gain 1, offset 0
;color balance = green 1, red 1.16, blue 1.88
;read out 20 MHz, Bayer interp = average, trigger mode = internals

#include <Inet.au3>

Local $s_SmtpServer = "smtp.wiscmail.wisc.edu"
Local $s_FromName = "Jeremy Bredfeldt"
Local $s_FromAddress = "bredfeldt@wisc.edu"
Local $s_ToAddress = "bredfeldt@wisc.edu"
Local $s_Subject = "SETI AutoUpdate"
Local $as_Body[2]

;select which imaging system to use, both is ok
$useClara = 1 ;set to 1 to use the Clara, zero to not use Clara
$useQ = 0     ;set to 1 to use Q, zero to not use Q
   
;values below will change for every new imaging session
$xstClara = -1.8118 ;starting x position for imaging
$ystClara = -0.8064  ;starting y position for imaging
$xdimClara = 1
$ydimClara = 1

$xstQ = -6.0258
$ystQ = 0.6166
$xdimQ = 1
$ydimQ = 1

;The values below shouldn't change, unless mag changes on cameras
$xstepClara = 0.08
$ystepClara = 0.059   
$xstepQ = 0.245
$ystepQ = 0.184

;These values potentially need to change each new acquisition
$zstart = 1
$zstop = 500

For $z = $zstart to $zstop
   
   If ($useClara = 1) Then
	  ;Image with Clara
	  MoveAbs($xstClara,$ystClara,20)
	  Sleep(5000)
	  For $y = 1 to $ydimClara
		 For $x = 1 to $xdimClara
			;Convert number into string
			$s = StringFormat("%03d_%03d_%03d",$x,$y,$z)

			CaptureSaveClara($s)
			
			If ($x < $xdimClara) Then
			   ;move in X direction
			   MoveRel("x",$xstepClara,5)
			EndIf
		 Next 
		 
		 ;moves stage back to original position
		 MoveRel("x",-1*($xdimClara-1)*$xstepClara,5)
	   
		 If ($y < $ydimClara) Then
			;move in Y direction
			MoveRel("y",-1*$ystepClara,5)
		 EndIf
	  Next
   EndIf
	
   If ($useQ = 1) Then   
	  ;Move to Q camera and capture
	  MoveAbs($xstQ,$ystQ,20)
	  Sleep(15000)
	  For $y = 1 to $ydimQ
		 For $x = 1 to $xdimQ
			;Convert number into string
			$s = StringFormat("%03d_%03d_%03d",$x,$y,$z)
			
			CaptureSaveQ($s)
			
			If ($x < $xdimQ) Then
			   ;move in X direction
			   MoveRel("x",$xstepQ,10)
			EndIf
		 Next
		 
		 ;moves stage back to original position
		 MoveRel("x",-1*($xdimQ-1)*$xstepQ,10)
		
		 If ($y < $ydimQ) Then
			;move in Y direction
			MoveRel("y",-1*$ystepQ,10)
		 EndIf
	  Next	
   EndIf

   ;Cut and move to Clara
   MoveToCut()
   
   If (Mod($z,10) = 0) Then
	  ;send email
	  $as_Body[0] = StringFormat("Finished section #%03d of %03d.",$z,$zstop)
	  $as_Body[1] = ""
 	  Local $Response = _INetSmtpMail($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $as_Body)
   EndIf
Next

;Below are functions
Func MoveAbs($x,$y,$r)
   ;x and y are absolute positions in inches
   WinActivate("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")
   WinWaitActive("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005") 
   Send("{Enter}") ;activate MDI Line
   Sleep(100)
   
   $s = StringFormat("g90") ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")   
   Sleep(100)
   
   $s = StringFormat("g01") ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)

   ;move to x position
   $s = StringFormat("x%7.4f f%d",$x,$r) ;construct command
   Send($s) ;send command   
   Sleep(100)
   Send("{Enter}")
   Sleep(100)

   ;move to y position
   $s = StringFormat("y%7.4f f%d",$y,$r) ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)

   Send("{Enter}")
   
   ;don't know how much to sleep, since we don't know how far the move is . . .
EndFunc

Func MoveToCut()
   WinActivate("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")
   WinWaitActive("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")   
   
   Sleep(100)
   MouseMove(335,523,0)
   Sleep(100)
   MouseDown("left")
   Sleep(100)
   MouseUp("left")
   ;open the file
   Sleep(300)
   Send("MoveToCut.txt")
   Sleep(100)
   Send("{Enter}")
   Sleep(1000)
   ;start the program
   Send("!r")
   Sleep(150000)
EndFunc

Func MoveRel($axis,$dist,$rate)
   ;Make sure step is selected!!!
   ;axis is the axis (x,y, or z) string
   ;dist is the distance we want to move
   ;rate is the feed rate
   WinActivate("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")
   WinWaitActive("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")
   
   Send("{Enter}") ;activate MDI Line
   Sleep(100)
   
   $s = StringFormat("g91") ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)

   $s = StringFormat("g01") ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)

   ;make move
   $s = StringFormat("%s%7.4f f%d",$axis,$dist,$rate) ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)
   
   Send("{Enter}")
   Sleep(Abs(60000*$dist/$rate)+1000)
EndFunc
	
Func CaptureSaveQ($filename)
   ;Turn on the lamp   
   WinActivate("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")
   WinWaitActive("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005") 
   Send("{Enter}") ;activate MDI Line
   Sleep(100)   
   $s = StringFormat("m8") ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)

   ;Capture and save image
   WinActivate("QCapture")
   WinWaitActive("QCapture")
   Send("!a")
   Send("{ENTER}")
   Sleep(2000)
   Send("!f")
   Send("s")
   WinWaitActive("Save As")
   Send($filename)
   Sleep(500)
   Send("{ENTER}")
   Sleep(2000)
   Send("!f")
   Send("c")	

   ;Turn off the lamp   
   WinActivate("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005")
   WinWaitActive("Mach3 CNC  Licensed To: MicroProto Systems Serial:10111005") 
   Send("{Enter}") ;activate MDI Line
   Sleep(100)   
   $s = StringFormat("m9") ;construct command
   Send($s) ;send command
   Sleep(100)
   Send("{Enter}")
   Sleep(100)
   ;exit 
   Sleep(100)
   Send("{Enter}")
   Sleep(100)
   
EndFunc

Func CaptureSaveClara($filename)
   ;Capture and save Clara image
   WinActivate("System: E:\Program Files\Micro-Manager-1.4\AndorOnly.cfg")
   WinWaitActive("System: E:\Program Files\Micro-Manager-1.4\AndorOnly.cfg")
   Send("{SPACE}") ;this captures an image, but must be in short cut list
   Sleep(4000)
   Send("s")
   WinWaitActive("Save as TIFF")
   Sleep(500)
   Send($filename)
   Sleep(200)
   Send("{ENTER}")
   Sleep(3000)
   Send("!{F4}")

EndFunc