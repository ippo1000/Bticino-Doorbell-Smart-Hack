
Device 16F877A
All_Digital true
Xtal = 4

Symbol R2 = PORTB.7
Symbol R3 = PORTB.6
Symbol R4 = PORTB.5
Symbol HOOK = PORTB.4
Symbol C1 = PORTB.3
Symbol R1 = PORTB.2
Symbol C3 = PORTB.1
Symbol C2 = PORTB.0
Symbol LED01 = PORTD.7

Input PORTA.0  'Memory 1
Input PORTA.1  'Memory 2
Input PORTA.2  'Memory 3

Symbol M1 = PORTA.0   'EXT INPUT MUST STAY ALWAYS HIGH OR WILL END CALL
Symbol M2 = PORTA.1
Symbol M3 = PORTA.2

 ' MT8870 DTMF Decoder
Symbol STD = PORTC.1
Symbol Q4 = PORTC.2
Symbol Q3 = PORTC.3
Symbol Q2 = PORTD.0
Symbol Q1 = PORTD.1
Symbol Opengate = PORTD.3
Symbol EndCall = PORTD.2
Symbol Opengate2 = PORTC.4
Symbol Opengate3 = PORTC.5

Dim rxtone As Byte
Dim w As Byte  '1-16
Dim key[8] As Byte


rxtone = 0
key[1]    = "X"


Dim kpd As Byte  'durata pressione tasto
kpd = 100  'millisecondi

Dim itk As Byte  'pausa tra 2 pressioni dei tasti
itk = 100  'millisecondi

Dim OnDial As Byte = 0 'Ongoing call
Dim i As Byte = 0

High LED01
Low C1:Low C2:Low C3:Low HOOK:Low R1:Low R2:Low R3:Low R4
DelayMS 250
Low LED01

mainloop: 


If M1 = 1  Then OnDial = 1 : GoTo call_01        ' call 1234567899
DelayMS 200
If M2 = 1 Then OnDial = 1 : GoTo call_02         ' call 9987654321
DelayMS 200
'If M3 = 1 Then OnDial = 1 : goto call_03
'DelayMS 200

GoTo mainloop



call_01:    ' OFF HOOK LOOP 
High HOOK:High LED01

For i=1 To 10
DelayMS 100
GoSub tonecheck
Next i
 
If OnDial = 1 Then   'WILL DIAL ONLY ONCE WHILE IN OFF HOOK LOOP
GoSub num1: GoSub num2:GoSub num3:GoSub num4:GoSub num5:GoSub num6:GoSub num7:GoSub num8:GoSub num9:GoSub num9
OnDial = 0
EndIf
If M1 = 0 Then  Low HOOK : Low LED01:GoTo mainloop  'FORCE END CALL

GoTo call_01


call_02:
High HOOK:High LED01

For i=1 To 10
DelayMS 100
GoSub tonecheck
Next i

If OnDial = 1 Then
GoSub num9: GoSub num9:GoSub num8:GoSub Num7:GoSub num6:GoSub num5:GoSub num4:GoSub num3:GoSub num2:GoSub num1
OnDial = 0
EndIf
If M2 = 0 Then  Low HOOK : Low LED01:GoTo mainloop
GoTo call_02


call_03:






num1:
High R1:High C1: DelayMS kpd: Low R1:Low C1:DelayMS itk:Return

num2:
High R1:High C2: DelayMS kpd: Low R1:Low C2:DelayMS itk:Return

num3:
High R1:High C3: DelayMS kpd: Low R1:Low C3:DelayMS itk:Return

num4:
High R2:High C1: DelayMS kpd: Low R2:Low C1:DelayMS itk:Return

num5:
High R2:High C2: DelayMS kpd: Low R2:Low C2:DelayMS itk:Return

num6:
High R2:High C3: DelayMS kpd: Low R2:Low C3:DelayMS itk:Return

num7:
High R3:High C1: DelayMS kpd: Low R3:Low C1:DelayMS itk:Return

Num8:
High R3:High C2: DelayMS kpd: Low R3:Low C2:DelayMS itk:Return

num9:
High R3:High C3: DelayMS kpd: Low R3:Low C3:DelayMS itk:Return

num0:
High R4:High C2: DelayMS kpd: Low R4:Low C2:DelayMS itk:Return




tonecheck:

If STD=0 Then rxtone=0 :Return  'TONE NOT RECEIVED / PREVIOUS TONE END  ; RESET ALREADY DECODED TONE

If STD=1 And rxtone= 0 Then
key[1]    = "X"
w=0                               ' Bit Weight
If Q4=1 Then w = w+8
If Q3=1 Then w = w+4
If Q2=1 Then w = w+2
If Q1=1 Then w = w+1

If w=0 Then key[1] = "D"
If w=1 Then key[1] = "1"
If w=2 Then key[1] = "2"
If w=3 Then key[1] = "3"
If w=4 Then key[1] = "4"
If w=5 Then key[1] = "5"
If w=6 Then key[1] = "6"
If w=7 Then key[1] = "7"
If w=8 Then key[1] = "8"
If w=9 Then key[1] = "9"
If w=10 Then key[1] = "0"
If w=11 Then key[1] = "*"
If w=12 Then key[1] = "#"
If w=13 Then key[1] = "A"
If w=14 Then key[1] = "B"
If w=15 Then key[1] = "C"

If key[1] = "4" Then High Opengate: DelayMS 250: Low Opengate
If key[1] = "0" Then High EndCall : DelayMS 350: Low EndCall : Low HOOK : Low LED01
EndIf

DelayMS 20
rxtone = 1    'TONE HAS BEEN DECODED YET - if key is kept pressed too long
Return



