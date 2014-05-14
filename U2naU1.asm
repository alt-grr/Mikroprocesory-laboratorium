;===============================================================================
;        KONWERSJA 8-BITOWEJ LICZBY U2 NA FORMAT ZNAK LICZBY + U1
;===============================================================================

org 0000h

	ljmp	main

org 1000h

;===============================================================================
 main:
;===============================================================================

; przenosimy stos
	mov	sp,#30h

	lcall	u2_u1

stop:
	nop
	ljmp	stop

;===============================================================================
 u2_u1:
;===============================================================================
; DANE WEJŚCIOWE:
; 	8-bitowa liczba U2 pod adresem 10h
;
; WYNIK DZIAŁANIA:
; 	znak liczby w 20h, liczba U1 w 21h
;-------------------------------------------------------------------------------

	clr	c
	mov	a,10h

; odczytujemy znak liczby
; jeśli jest ujemna musimy wziąć liczbę do niej przeciwną i dodać 1
	rlc	a
	jc	odwroc

	mov	20h,#00h
	mov	21h,10h

ret

odwroc:
	mov	a,10h
	cpl	a
	add	a,#01h

	mov	20h,#01h
	mov	21h,a

ret

END
