		ORG 0H 		; 0H adresiyle basla
		SJMP MAIN	; MAIN'e git
		
		ORG 0BH		; TIMER0 interrupt bolgesine konuslan
INTRP_T:LJMP OP 	; OP'e dallan
		
		ORG 30H				; 30H adresine konuslan
MAIN:	SETB P1.0			; P1 i giris ayarlandi
		MOV TMOD,#01H		; TMOD 1 olarak ayarlandi
		MOV IE,#82H			; Interrupt ayarlandi

CLEAN:  MOV P3,#0			; P3'e 0 degeri verildi(sifirlama islemi)
		MOV R4,#20			; R4 e 20 degeri verildi
		MOV TH0,#HIGH(15536); 50000 saymak icin yuksek tarafi ayarla
		MOV TL0,#LOW(15536) ; 50000 saymak icin dusuk tarafi ayarla

START:	CLR A				; A temizleniyor
		MOV DPTR,#008FH		; DPTR 8FH adresini tasi
		MOV R7, #80H		; R7'e 80H adresini tasi
		MOV P0,R7			; P0 portuna R7'deki(80H) degeri tasi
		CLR TR0				; TR0 sifirlaniyor
		JB P1.0, CLEAN		; P1 1 degerindeyse TEMIZLE etiketine dallan
		SETB TR0			; saymayi baslat
		
WORK:	JB P3.0,SONUK 	; P3.0 1e esitse SONUK'e git
		MOV R6,A 		; A degerini R6 ya tasi
		MOV A,R7 		; R7 deki degeri A ya aktar
		RL A 			; A'yi sola dondur
		MOV R7,A		; A'nin degerini R7'e at
		MOV A,R6 		; R6'daki degeri tekrar A'ya al
		MOV P0,R7 		; P0 portuna R7'yi tasi

SONUK:	CALL COUNTER 	; COUNTER cagiriliyor
		MOV P2,A 		; A'daki degeri P2'ye aktar
		MOV A,R2 		; R2'deki degeri akumulatore aktar
		CALL DELAY 	    ; DELAY cagiriliyor
		CJNE A,#4,WORK  ; A, 4 olmadiysa WORK'e git
		SJMP START 		; START'a git

DELAY:  MOV R0,#10		; R0'a 10 degerini ver
		MOV R1,#10		; R1'e 10 degerini ver
WAIT:	DJNZ R0,WAIT 	; R0'i 1 azalt 0 degilse WAIT'e git
		MOV R0,#10		; R0'a 10 degerini ver
		DJNZ R1,WAIT	; R1'i 1 azalt 0 degilse WAIT'e git
		RET 			; alt programdan dön

COUNTER:INC A 			; A'daki degeri 1 arttirir
		MOV R2,A 		; Table'daki indisi R2'ye tasi
		MOVC A,@A+DPTR	; akumulator ile DPTR'yi topla adresteki degeri A'ya yukle
		RET

		ORG 90h 									; 90H adresine git
TABLE:	DB 1111001B, 1101110B, 1011111B, 1111000B 	; E Y A T harflerinin 7 segmentteki karsiliklari ve yazdirilmasi

		ORG 120H			; 120H adresine git
OP: 	DJNZ R4,CONT		; R4'u bir azalt 0 degilse CONT'a git
		CLR TF0				; TF0'i temizle
		CPL P3.0			; P3.0'i tersle
		MOV R4,#20			; R4'u 20 olarak ayarla
		MOV TH0,#HIGH(15536); 50000 saymak icin yuksek tarafi ayarla
		MOV TL0,#LOW(15536)	; 50000 saymak icin dusuk tarafi ayarla
		RETI				; interruptsiz donus
		
		ORG 140H			; 140H adresine git
CONT:   CLR TF0				; TF0'i temizle
		MOV TH0,#HIGH(15536); 50000 saymak icin yuksek tarafi ayarla
		MOV TL0,#LOW(15536) ; 50000 saymak icin dusuk tarafi ayarla
		RETI				; interruptsiz donus
		
		END					; program bitti