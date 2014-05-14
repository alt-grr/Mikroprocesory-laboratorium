;===============================================================================
;      DODAWANIE 24-BITOWYCH LICZB U2, ZAPISANYCH W FORMACIE BIG ENDIAN
;===============================================================================

org 0000h

	ljmp	main

org 1000h

;===============================================================================
 main:
;===============================================================================

; przenosimy stos
	mov	sp,#30h

	lcall	dodaj

stop:
	nop
	ljmp	stop

;===============================================================================
 dodaj:
;===============================================================================
; DANE WEJŚCIOWE:
; 	2 liczby zapisane pod adresami 00h,01h,02h oraz 08h,09h,0Ah
;
; WYNIK DZIAŁANIA:
; 	ich suma zapisana jako liczba 32-bitowa pod adresami 10h,11h,12h,13h
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
	jc	dodaj_ustaw_a
dodaj_ustaw_a_powrot:

; sprawdzamy znak liczby b
	clr	c
	mov	a,08h
	rlc	a
; jeśli liczba jest ujemna, uzupełniamy ją na najstarszym bajcie wartością 0xFF
; zamiast 0x00
	jc	dodaj_ustaw_b
dodaj_ustaw_b_powrot:

; dodajemy po kolei wszystkie 4 bajty
	clr	c
	mov	a,02h
	add	a,0Ah
	mov	13h,a

	mov	a,01h
	addc	a,09h
	mov	12h,a

	mov	a,00h
	addc	a,08h
	mov	11h,a

	mov	a,07h
	addc	a,0Fh
	mov	10h,a

dodaj_koniec:

; przywracamy zawartość akumulatora
	mov	a,18h

ret

;-------------------------------------------------------------------------------

dodaj_ustaw_a:
	mov	07h,#0FFh
	ljmp	dodaj_ustaw_a_powrot

dodaj_ustaw_b:
	mov	0Fh,#0FFh
	ljmp	dodaj_ustaw_b_powrot

END
