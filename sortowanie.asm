;===============================================================================
;  SORTOWANIE PRZEZ WYBÓR LICZB 16-BITOWYCH, ZAPISANYCH W FORMACIE BIG ENDIAN
;===============================================================================

org 0000h
	ljmp	1000h

org 1000h

;===============================================================================
 main:
;===============================================================================

; przenosimy stos
	mov	sp,#40h

	lcall	kopiuj
	lcall	sortuj

stop:
	nop
	ljmp	stop

;===============================================================================
 sortuj:
;===============================================================================
; DANE WEJŚCIOWE:
; 	liczby w zewnętrznym RAMie pod adresami 4000h-4FFFh
;
; WYNIK DZIAŁANIA:
; 	posortowane malejąco liczby umieszczone w tym samym miejscu
;
; UŻYWANA PAMIĘĆ:
;	1Eh,1Fh,20h-25h,30h-35h
;-------------------------------------------------------------------------------

; ustawiamy wskaźnik na pierwszą liczbę
	mov	DPH,#40h
	mov	DPL,#00h

; zapisujemy wartość wskaźnika na pierwszą liczbę poza zakresem danych
	mov	1Eh,#050h
	mov	1Fh,#000h

;-------------------------------------------------------------------------------
; główna pętla sortująca
;-------------------------------------------------------------------------------
sortuj_petla:

; zapisujemy wskaźnik na bierzacą liczbę
	mov	20h,DPH
	mov	21h,DPL

; zapisujemy wskaźnik dotychczasowej maksymalnej liczby
	mov	22h,DPH
	mov	23h,DPL

; pobieramy liczbę z RAMu
; starszy bajt
	movx	A,@DPTR
	mov	30h,A

; młodszy bajt
	inc	DPTR
	movx	A,@DPTR
	mov	31h,A

; ustawiamy DPTR na następną liczbę
	inc	DPTR

; zapisujemy wartość dotychczasowej maksymalnej liczby
	mov	32h,30h
	mov	33h,31h

;-------------------------------------------------------------------------------
; w pętli szukamy do końca tablicy wartości maksymalnej
;-------------------------------------------------------------------------------
szukaj_maks:
	; sprawdzamy czy to nie koniec tablicy
		lcall	sprawdz_licznik
		jz	szukaj_maks_koniec

	; zapisujemy wskaźnik na nowego potencjalnego maksa
		mov	24h,DPH
		mov	25h,DPL

	; pobieramy liczbę z RAMu
	; starszy bajt
		movx	A,@DPTR
		mov	34h,A

	; młodszy bajt
		inc	DPTR
		movx	A,@DPTR
		mov	35h,A

	; porównujemy ją z dotychczasową maksymalną wartością
	; (odejmujemy aktualny maks od nowej liczby)
		clr	c
		mov	A,33h
		subb	A,35h

		mov	A,32h
		subb	A,34h

	; jeżeli pożyczka nie wystąpi to szukamy dalej
	jnc	szukaj_maks_dalej
	; jeżeli wystąpi, trzeba zapisać dane nowego maksa

	; zapisujemy wskaźnik nowego maksa
		mov	22h,24h
		mov	23h,25h
	; zapisujemy wartość nowego maksa
		mov	32h,34h
		mov	33h,35h

	szukaj_maks_dalej:
	; przestawiamy wskaźnik na następną liczbę
		inc	DPTR

;-------------------------------------------------------------------------------
ljmp	szukaj_maks
;-------------------------------------------------------------------------------
szukaj_maks_koniec:

; znaleźliśmy liczbę która powinna być na bierzącym miejscu w tablicy
; musimy ją zamienić miejscami z bierzącą

; wczytujemy wskaźnik nowego miejsca
	mov	DPH,22h
	mov	DPL,23h
; zapisujemy tam wartość bierzącej liczby
	mov	A,30h
	movx	@DPTR,A
	inc	DPTR
	mov	A,31h
	movx	@DPTR,A

; wczytujemy wskaźnik bierzącego miejsca
	mov	DPH,20h
	mov	DPL,21h
; wpisujemy tam wartość znalezionej liczby
	mov	A,32h
	movx	@DPTR,A
	inc	DPTR
	mov	A,33h
	movx	@DPTR,A

; przestawiamy wskaźnik na następną liczbę
	inc	DPTR

; sprawdzamy czy to nie koniec zakresu
	lcall	sprawdz_licznik
	jz	sortuj_koniec

;-------------------------------------------------------------------------------
ljmp	sortuj_petla
;-------------------------------------------------------------------------------
sortuj_koniec:

ret

;===============================================================================
 sprawdz_licznik:
;===============================================================================
; Porównuje zawartość DPTR z daną zawartą w 1Eh i 1Fh
; Ustawia A na zero jeśli równe
;-------------------------------------------------------------------------------

; młodszy bajt
	clr	c
	mov	A,DPL
	subb	A,1Fh

; jak są równe nie może być pożyczki
	jc	sprawdz_licznik_koniec

; starszy bajt
	clr	c
	mov	A,DPH
	subb	A,1Eh

sprawdz_licznik_koniec:

ret

;===============================================================================
 kopiuj:
;===============================================================================
; Kopiuje dane zapisane w zewnętrznym RAMie pod adresami 3000h-3FFFh pod adresy
; 4000h-4FFFh
;
; UŻYWANA PAMIĘĆ:
;	1Eh,1Fh,20h-23h,30h,31h
;-------------------------------------------------------------------------------

; ustawiamy wskaźnik na pierwszą liczbę
	mov	DPH,#030h
	mov	DPL,#000h

; zapisujemy wartość wskaźnika na pierwszą liczbę poza zakresem danych
	mov	1Eh,#040h
	mov	1Fh,#000h

; zapisujemy wskaźnik początku skąd kopiować
	mov	20h,DPH
	mov	21h,DPL

; zapisujemy wskaźnik początku dokąd kopiować
	mov	22h,#40h
	mov	23h,#00h

;-------------------------------------------------------------------------------
kopiuj_petla:
;-------------------------------------------------------------------------------

	; sprawdzamy czy to nie koniec tablicy
		lcall	sprawdz_licznik
		jz	kopiuj_petla_koniec

	; zapisujemy wartość Hi
		movx	A,@DPTR
		mov	30h,A

	; zapisujemy wartość Lo
		inc	DPTR
		movx	A,@DPTR
		mov	31h,A

	; przenosimy
		mov	DPH,22h
		mov	DPL,23h

	; kopiujemy wartość Hi
		mov	A,30h
		movx	@DPTR,A

	; kopiujemy wartość Lo
		inc	DPTR
		mov	A,31h
		movx	@DPTR,A

	; inkrementujemy i zapisujemy wskaźnik dokąd kopiować
		inc	DPTR
		mov	22h,DPH
		mov	23h,DPL

	; inkrementujemy i zapisujemy wskaźnik skąd kopiować
		mov	DPH,20h
		mov	DPL,21h
		inc	DPTR
		inc	DPTR
		mov	20h,DPH
		mov	21h,DPL

;-------------------------------------------------------------------------------
ljmp	kopiuj_petla
;-------------------------------------------------------------------------------
kopiuj_petla_koniec:

ret

END
