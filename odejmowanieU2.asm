;===============================================================================
;     ODEJMOWANIE 24-BITOWYCH LICZB U2, ZAPISANYCH W FORMACIE BIG ENDIAN
;===============================================================================

org 0000h

	ljmp	main

org 1000h

;===============================================================================
 main:
;===============================================================================

; przenosimy stos
	mov	sp,#30h

	lcall	odejmij

stop:
	nop
	ljmp	stop

;===============================================================================
 odejmij:
;===============================================================================
; DANE WEJŚCIOWE:
; 	2 liczby zapisane pod adresami 00h,01h,02h oraz 08h,09h,0Ah
;
; WYNIK DZIAŁANIA:
; 	ich różnica zapisana jako liczba 32-bitowa pod adresami 10h,11h,12h,13h
;
; UŻYWANA PAMIĘĆ:
;	07h,0Fh,18h
;-------------------------------------------------------------------------------

	clr	c

; zapisujemy zawartość akumulatora
	mov	18h,a

; uzupełniamy obie liczby do 32 bitów
	mov	07h,#00h
	mov	0Fh,#00h

; sprawdzamy znak liczby a
	mov	a,00h
	rlc	a
; jeśli liczba jest ujemna, uzupełniamy ją na najstarszym bajcie wartością 0xFF
; zamiast 0x00
	jc	odejmij_ustaw_a
odejmij_ustaw_a_powrot:

; sprawdzamy znak liczby b
	clr	c
	mov	a,08h
	rlc	a
; jeśli liczba jest ujemna, uzupełniamy ją na najstarszym bajcie wartością 0xFF
; zamiast 0x00
	jc	odejmij_ustaw_b
odejmij_ustaw_b_powrot:

; odejmujemy po kolei wszystkie 4 bajty
	clr	c
	mov	a,02h
	subb	a,0Ah
	mov	13h,a

	mov	a,01h
	subb	a,09h
	mov	12h,a

	mov	a,00h
	subb	a,08h
	mov	11h,a

	jnc	odejmij_koniec

; jeśli była pożyczka, korygujemy także najstarszy bajt
	clr	c
	mov	a,07h
	subb	a,0Fh
	jnc	odejmij_koniec
; przy podwójnej pożyczce (z bitu znaku i z poza niego) musimy zmienić znak
; wyniku na ujemny
	mov	10h,#0FFh

odejmij_koniec:
; przywracamy akumulator
	mov	a,18h

ret

;-------------------------------------------------------------------------------

odejmij_ustaw_a:
	mov	07h,#0FFh
	ljmp	odejmij_ustaw_a_powrot

odejmij_ustaw_b:
	mov	0Fh,#0FFh
	ljmp	odejmij_ustaw_b_powrot

END
