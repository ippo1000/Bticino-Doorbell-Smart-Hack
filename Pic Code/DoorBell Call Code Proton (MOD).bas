'****************************************************************
'*  Name    : UNTITLED.BAS                                      *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2020 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 14/12/2020                                        *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
Device 16F648A       

Declare Xtal 4
All_Digital true
 
Symbol OffHook = PORTB.0  ' Off Hook RED LED
Symbol PE_Enable = PORTB.1  ' Posto Esterno Enable GREEN LED
Symbol In64 = PORTB.2  ' Segnalazione active low

Symbol TelCall = PORTB.3  'Chiamata telefonica

Symbol Local_Start = PORTB.4
Symbol END_Call = PORTB.5
Symbol Intcom_64  = PORTB.6


Input PORTB.4
Input PORTB.5
Input PORTB.6
Input PORTB.7

Dim secs As Word
secs = 0

Dim i As Byte
i = 0

Dim MakeCall As Byte
MakeCall = 0

Low In64
Low OffHook
Low PE_Enable                 
Low TelCall
  
Stbyloop:

DelayMS 170
If Intcom_64  = 1 Then MakeCall = 1 : GoTo PE_Activate
DelayMS 80
If Local_Start = 1 Then MakeCall = 0 : GoTo PE_Activate


GoTo Stbyloop


talkloop:

DelayMS 80
If END_Call = 1 Then GoTo Comm_End
DelayMS 170

    
secs = secs +1     'A second off hook has passed
If secs = 248 Then High PE_Enable : DelayMS 250: Low PE_Enable              ' 62s
If secs >= 480 Then GoTo Comm_End                                          ' 120s

GoTo talkloop
 
 
PE_Activate:
secs = 0
High OffHook :High In64:High PE_Enable
DelayMS 250
Low PE_Enable
If MakeCall = 1 Then High TelCall 
DelayMS 350
MakeCall = 0
GoTo talkloop


Comm_End:
DelayMS 100
Low OffHook:Low In64:Low TelCall
DelayMS 300
GoTo Stbyloop


  End
