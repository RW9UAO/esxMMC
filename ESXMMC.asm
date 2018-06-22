; Disassembly of the file "C:\work\xilinx_proj\esxmmc\ESXMMC.BIN"
; 
; CPU Type: Z80
; 
; Created with dZ80 2.0
; 
; on Wednesday, 20 of June 2018 at 10:23 AM
; 

ESXDOS.SYS loaded from two part - page 0(x2000), page 1(x3000)
;ram:
2000h -  ESXDOS.SYS / BETADISK.SYS load buff
201bh - ReadDelay param from config
2352h-2353h - trdos flags
2515h - 
2d24h - 
2dceh - sys path full path
2c00h - 
2f00h - NMI.SYS loaded
3000h - ESXDOS.SYS load buff
32E3h - proc
3d00h - betadisk proc 0x89 bytes len
3d30h - flag, c9|00
3deeh - proc addr ????
3df4h
3df8h
3dfah - sd card readin flag
3dfeh - byte read from SD card

And here is paging port #E3 of DIVMMC:
D0-D5 = 8kB ram page 0-63 (for full 512kB memory)
D6 = bit mapram
D7 = bit conmem

DIVMMC SD port functionality is same as ZXMMC interface, only address of SD ports are different:
- port #1F(ZXMMC) for writing is replaced with new port #E7(DIVMMC)
- port #3F(ZXMMC) for read/write data is replaced with new port #EB(DIVMMC)

PORT              ADDRESS         DECODING
hex/dec         A15 ... A0       A15 ... A0          READ            WRITE
#E3/227      xxxxxxxx11100011 xxxxxxxx11100011         -        divIDEcontrol	
#E7/231      xxxxxxxx11100111 xxxxxxxx11100111         -        SD control		
#EB/235      xxxxxxxx11101011 xxxxxxxx11101011 SD SPIdata       SD SPIdata	

#E7 aka SD control bit0 - CS of sd card




0000 f3        di      			; disable interrupt
0001 31005e    ld      sp,5e00h		; set stack
0004 c30101    jp      0101h

0007 ff        rst     38h

0008 c38509    jp      0985h		; read_sd_card_sector

000b 2a5d5c    ld      hl,(5c5dh)
000e 1805      jr      0015h

0010 c34508    jp      0845h		; print byte

0013 ff        rst     38h
0014 ff        rst     38h
0015 c3d40c    jp      0cd4h

0018 c3bd0c    jp      0cbdh

001b ff        rst     38h
001c ff        rst     38h
001d ff        rst     38h
001e ff        rst     38h

; interrupt calling
001f 182a      jr      004bh

0021 5d        ld      e,l
0022 5c        ld      e,h
0023 225f5c    ld      (5c5fh),hl
0026 1825      jr      004dh

; jmp to addr (3deeh)
0028 e5        push    hl
0029 2aee3d    ld      hl,(3deeh)
002c e3        ex      (sp),hl
002d c9        ret     

002e ff        rst     38h
002f ff        rst     38h

0030 185f      jr      0091h

0032 2f 42 49 4e 2f 					/BIN/
0037 ff        rst     38h

0038 18e5      jr      001fh				; interrupt calling

003a 213900    ld      hl,0039h
003d c3f41f    jp      1ff4h

0040 50 4c 55 53 33 44 4f 53 				PLUS3DOS

0048 1a		ld      a,(de)
0049 0100fb    ld      bc,0fb00h
004c c9        ret     

004d c3060c    jp      0c06h

0050 44 65 74 65 63 74 69 6e 67 20 44 65 76 69 63 65	Detecing Device
0060 73 2e 2e 2e 0d					s...

0065 00        nop     

0066 c9        ret     					; NMI vector

0067 00        nop     

0068 22f43d    ld      (3df4h),hl
006b 2af93d    ld      hl,(3df9h)
006e 67        ld      h,a
006f 3e00      ld      a,00h
0071 d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0
0073 227a2e    ld      (2e7ah),hl

0076 7d        ld      a,l
0077 d3e3      out     (0e3h),a		port E3 = [2e7a]
0079 2af43d    ld      hl,(3df4h)
007c 3e00      ld      a,00h
007e d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0
0080 3a7b2e    ld      a,(2e7bh)
0083 c31e20    jp      201eh

0086 fb        ei      
0087 f5        push    af
0088 3a7a2e    ld      a,(2e7ah)
008b d3e3      out     (0e3h),a		port E3 = [2e7a]
008d f1        pop     af
008e c3fa1f    jp      1ffah

0091 22f43d    ld      (3df4h),hl
0094 e1        pop     hl
0095 23        inc     hl
0096 e5        push    hl
0097 2b        dec     hl
0098 d5        push    de
0099 1600      ld      d,00h
009b 5e        ld      e,(hl)
009c 21a005    ld      hl,05a0h
009f 19        add     hl,de
00a0 19        add     hl,de
00a1 5e        ld      e,(hl)
00a2 23        inc     hl
00a3 66        ld      h,(hl)
00a4 6b        ld      l,e
00a5 d1        pop     de
00a6 e5        push    hl
00a7 2af43d    ld      hl,(3df4h)
00aa c9        ret     

00ab 2f 53 59 53 00					/SYS

00b0 13
00b1 01 17 12
00b4 01 13 00
00b7 20 76 30 2e 38 2e 35 2d 44				v0.8.5-DivMMC

00c6 13
00c7 01 17 15
00ca 01 13 00
00cd 7f	20 32 30 30 35 2d 32 30 31 33 0d		(c)2005-2013

00d9 13        inc     de
00da 011713    ld      bc,1317h
00dd 011300    ld      bc,0013h

00e0 50 61 70 61 79 61 20 44 65 7a 69 67 6e 0d		Papaya Dezign

00ee 8d        adc     a,l

set_basic48_rom:
;11 - BASIC48
00ef 01fd1f    ld      bc,1ffdh
00f2 3e04      ld      a,04h
00f4 ed79      out     (c),a		port 1ffd = 04; старший бит номера страницы ПЗУ
00f6 067f      ld      b,7fh
00f8 3e10      ld      a,10h
00fa ed79      out     (c),a		port 7ffd = 10; младший - D4 порта #7FFD
00fc c9        ret     

00fd 00        nop     
00fe 00        nop     
00ff 5a        ld      e,d
0100 3d        dec     a

start:
0101 01302a    ld      bc,2a30h
0104 af        xor     a
0105 d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0

0107 0b        dec     bc
0108 00        nop     
0109 00        nop     
010a 00        nop     
010b 00        nop     
010c 78        ld      a,b
010d b1        or      c
010e 20f7      jr      nz,0107h		; loop

0110 cdef00    call    00efh		; set_basic48_rom
0113 cdff04    call    04ffh		; sound_init
0116 3e0e      ld      a,0eh
0118 321f20    ld      (201fh),a
011b 3a422d    ld      a,(2d42h)
011e feaa      cp      0aah
0120 2008      jr      nz,012ah
0122 3e7f      ld      a,7fh
0124 dbfe      in      a,(0feh)			; keyboard input
0126 1f        rra     				; check for space
0127 da5102    jp      c,0251h			; jump to basic48

012a af        xor     a
012b d3fe      out     (0feh),a			port FE = 0; border 0
012d 21ff5e    ld      hl,5effh		; from
0130 11fe5e    ld      de,5efeh		; to
0133 01ff1e    ld      bc,1effh		; counter
0136 77        ld      (hl),a
0137 edb8      lddr    			; move from [hl] to [de], decrement addr
0139 3e04      ld      a,04h
013b d3e3      out     (0e3h),a		port E3 = 04; conmem off, page 4 (x8000)
013d 210020    ld      hl,2000h		; from
0140 110120    ld      de,2001h		; to
0143 01ff1f    ld      bc,1fffh		; counter
0146 75        ld      (hl),l		; [x2000] = x04
0147 edb0      ldir    			; move from [hl] to [de], increment addr
0149 32f93d    ld      (3df9h),a
014c 21fd3d    ld      hl,3dfdh
014f 36c9      ld      (hl),0c9h
0151 21303d    ld      hl,3d30h
0154 36c9      ld      (hl),0c9h
0156 3d        dec     a
0157 feff      cp      0ffh
0159 20e0      jr      nz,013bh
015b 3e04      ld      a,04h
015d d3e3      out     (0e3h),a		port E3 = 04; conmem off, page 4 (x8000)
015f 210020    ld      hl,2000h
0162 7e        ld      a,(hl)
0163 34        inc     (hl)
0164 be        cp      (hl)
0165 2002      jr      nz,0169h
0167 2e1c      ld      l,1ch
0169 af        xor     a
016a d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0
016c 7d        ld      a,l
016d 328c2e    ld      (2e8ch),a
0170 3eaa      ld      a,0aah
0172 32422d    ld      (2d42h),a
0175 21f409    ld      hl,09f4h
0178 224f5c    ld      (5c4fh),hl
017b 214f5c    ld      hl,5c4fh
017e 22515c    ld      (5c51h),hl
0181 3e07      ld      a,07h
0183 328f5c    ld      (5c8fh),a		; ATTR_T = 07
0186 210040    ld      hl,4000h			; video mem
0189 22845c    ld      (5c84h),hl		; DF_CC
018c 212118    ld      hl,1821h
018f 22885c    ld      (5c88h),hl		; SPOSN
0192 21003c    ld      hl,3c00h			; font addr
0195 22365c    ld      (5c36h),hl		; CHARS
0198 21b000    ld      hl,00b0h			"??????"
019b cd900c    call    0c90h			; print
019e 21ce00    ld      hl,00ceh			"2005-2013"
01a1 cd900c    call    0c90h			; print
01a4 cd6304    call    0463h			; screen
01a7 cd1c03    call    031ch			; var_init
01aa cda703    call    03a7h
01ad 210720    ld      hl,2007h
01b0 3e3e      ld      a,3eh
01b2 77        ld      (hl),a
01b3 2c        inc     l
01b4 3e14      ld      a,14h
01b6 77        ld      (hl),a
01b7 2c        inc     l
01b8 3e37      ld      a,37h
01ba 77        ld      (hl),a
01bb 2c        inc     l
01bc 3ec9      ld      a,0c9h
01be 77        ld      (hl),a
01bf 321420    ld      (2014h),a
01c2 211208    ld      hl,0812h
01c5 221720    ld      (2017h),hl
01c8 21f1c3    ld      hl,0c3f1h
01cb 221e20    ld      (201eh),hl
01ce 21f71f    ld      hl,1ff7h
01d1 222020    ld      (2020h),hl
01d4 3ec9      ld      a,0c9h
01d6 32002f    ld      (2f00h),a
01d9 2137c9    ld      hl,0c937h
01dc 225723    ld      (2357h),hl
01df 221525    ld      (2515h),hl
01e2 215000    ld      hl,0050h			"Detecing Devices..."
01e5 cd3e08    call    083eh			; print
01e8 3e0d      ld      a,0dh			; CR
01ea d7        rst     10h			; jp      0845h		; print byte
01eb 3e80      ld      a,80h
01ed cd7d02    call    027dh
01f0 3e88      ld      a,88h
01f2 cd7d02    call    027dh
01f5 217006    ld      hl,0670h			"Mounting drives..."
01f8 cd3e08    call    083eh			;print
01fb cde106    call    06e1h			; read sector
01fe 3a012d    ld      a,(2d01h)
0201 32462d    ld      (2d46h),a
0204 324a2d    ld      (2d4ah),a
0207 cd1e04    call    041eh
020a 3e0d      ld      a,0dh			; CR
020c d7        rst     10h			;jp      0845h		; print byte

load_sys_files:
020d 21581c    ld      hl,1c58h		"ESXDOS"
0210 cd5702    call    0257h		;show_filename_sys
0213 cdc502    call    02c5h		; load_file(ESXDOS.SYS)
0216 f5        push    af
0217 cd7202    call    0272h		;print_error
021a f1        pop     af
021b 3825      jr      c,0242h		; error exit
021d 21d906    ld      hl,06d9h		"NMI"
0220 cd5702    call    0257h		; show_filename_sys
0223 cdb302    call    02b3h		; load_file(NMI.SYS)
0226 cd7202    call    0272h		;print_error
0229 2017      jr      nz,0242h		; error exit
022b 3a8c2e    ld      a,(2e8ch)
022e a7        and     a
022f 2011      jr      nz,0242h		; error exit
0231 21b206    ld      hl,06b2h		"BETADISK"
0234 cd5702    call    0257h		; show_filename_sys
0237 cda102    call    02a1h		; load_file (BETADISK.SYS)
023a f5        push    af
023b d4c403    call    nc,03c4h		;execute_code_page1
023e f1        pop     af
023f cd7202    call    0272h		;print_error

0242 3e7f      ld      a,7fh                                              	
0244 dbfe      in      a,(0feh)		; keyboard input
0246 1f        rra     
0247 3802      jr      c,024bh		; no keypress
0249 18f7      jr      0242h		; loop for any key pressed
024b 11d007    ld      de,07d0h
024e cd9702    call    0297h		; pause (2000)
0251 210100    ld      hl,0001h
0254 c3fb1f    jp      1ffbh		; jump to basic48

show_filename_sys:
; hl - filename
0257 eb        ex      de,hl
0258 21d006    ld      hl,06d0h			"Loading "
025b cd3e08    call    083eh			;print
025e eb        ex      de,hl
025f cdef02    call    02efh			; make_full_path_filename
0262 e5        push    hl
0263 110500    ld      de,0005h			; add len
0266 19        add     hl,de
0267 cd3e08    call    083eh			;print
026a 21dd06    ld      hl,06ddh			"..."
026d cd3e08    call    083eh			;print
0270 e1        pop     hl
0271 c9        ret     

print_error:
0272 21c706    ld      hl,06c7h			"[OK]"
0275 3003      jr      nc,027ah
0277 21bb06    ld      hl,06bbh			"[ERROR]"
027a c33e08    jp      083eh			;print

; param in 'a'
027d 11f22d    ld      de,2df2h
0280 cf        rst     08h			;jp      0985h ; read_sd_card_sector
0281 80        add     a,b
0282 d8        ret     c

0283 e6f8      and     0f8h
0285 f7        rst     30h			; jr      0091h
0286 0e3e      ld      c,3eh
0288 3ad73e    ld      a,(3ed7h)
028b 20d7      jr      nz,0264h
028d 21f22d    ld      hl,2df2h
0290 cd3e08    call    083eh			;print
0293 3e0d      ld      a,0dh                    ; CR
0295 d7        rst     10h			;jp      0845h		; print byte
0296 c9        ret     

pause:
; de - delay time
0297 06ff      ld      b,0ffh
0299 10fe      djnz    0299h
029b 1b        dec     de
029c 7a        ld      a,d
029d b3        or      e
029e 20f7      jr      nz,0297h
02a0 c9        ret     

load_file_BETADISK_SYS:
02a1 cde802    call    02e8h		; open file
02a4 d8        ret     c		; error, no file
02a5 f5        push    af
02a6 3e03      ld      a,03h
02a8 d3e3      out     (0e3h),a		port E3 = 03; conmem off, page 3 (x6000)
02aa f1        pop     af
02ab 210020    ld      hl,2000h		; buffer
02ae 01001c    ld      bc,1c00h		; counter
02b1 180a      jr      02bdh		; load sector

load_file_NMI_SYS:
; hl - filename addr
02b3 cde802    call    02e8h		; open file
02b6 d8        ret     c		; error, no file
02b7 21002f    ld      hl,2f00h		; buffer
02ba 01000e    ld      bc,0e00h		; counter
02bd 5f        ld      e,a
02be d5        push    de
02bf cf        rst     08h		; jp 0985h ; read_sd_card_sector
02c0 9d        sbc     a,l
02c1 d1        pop     de
02c2 7b        ld      a,e
02c3 181c      jr      02e1h

load_file_ESXDOS_SYS:
; hl - filename addr
02c5 cde802    call    02e8h		; open file
02c8 d8        ret     c		; error, no file
02c9 f5        push    af
02ca 210020    ld      hl,2000h         ; buffer
02cd 011a06    ld      bc,061ah		; counter, 1562 bytes
02d0 cf        rst     08h		; jp 0985h ; read_sd_card_sector
02d1 9d        sbc     a,l
02d2 3e01      ld      a,01h
02d4 d3e3      out     (0e3h),a		port E3 = 01; conmem off, page 1
02d6 f1        pop     af
02d7 f5        push    af
02d8 210030    ld      hl,3000h		; buffer
02db 01ca07    ld      bc,07cah		; len 1994 bytes
02de cf        rst     08h		; jp      0985h ; read_sd_card_sector
02df 9d        sbc     a,l
02e0 f1        pop     af
02e1 cf        rst     08h		; jp      0985h ; read_sd_card_sector
02e2 9b        sbc     a,e
02e3 3e00      ld      a,00h
02e5 d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0
02e7 c9        ret     

open_file:
; hl - addr of file name
02e8 3e24      ld      a,24h		; flag
02ea 0601      ld      b,01h		; bc - counter
02ec cf        rst     08h		; jp 0985h ; read_sd_card_sector
02ed 9a        sbc     a,d
02ee c9        ret     

make_full_path_filename:
02ef cd0503    call    0305h		; make_sys_path
02f2 21ac00    ld      hl,00ach		"SYS"
02f5 cd9805    call    0598h		; strcpy
02f8 12        ld      (de),a		; last zero
02f9 21ce2d    ld      hl,2dceh		; return link to full path "/SYS/filename.SYS"
02fc c9        ret     

02fd cd0503    call    0305h		; make_sys_path
0300 211b20    ld      hl,201bh
0303 18f0      jr      02f5h

make_sys_path:
0305 e5        push    hl
0306 11ce2d    ld      de,2dceh		; full path name
0309 21ab00    ld      hl,00abh		"/SYS"
030c cd9805    call    0598h		; strcpy
030f 3e2f      ld      a,2fh		'/'
0311 12        ld      (de),a
0312 13        inc     de
0313 e1        pop     hl
0314 cd9805    call    0598h		; strcpy
0317 3e2e      ld      a,2eh		'.'
0319 12        ld      (de),a
031a 13        inc     de
031b c9        ret     

var_init:
031c 21242d    ld      hl,2d24h		; ram area
031f 116d1c    ld      de,1c6dh		; rom area
0322 73        ld      (hl),e
0323 23        inc     hl
0324 72        ld      (hl),d
0325 23        inc     hl
0326 111525    ld      de,2515h
0329 73        ld      (hl),e
032a 23        inc     hl
032b 72        ld      (hl),d
032c 23        inc     hl
032d c9        ret     

032e 4f        ld      c,a
032f 3a472d    ld      a,(2d47h)
0332 fe06      cp      06h
0334 37        scf     
0335 c8        ret     z

0336 21002c    ld      hl,2c00h
0339 7e        ld      a,(hl)
033a a7        and     a
033b 2806      jr      z,0343h
033d 3e28      ld      a,28h
033f 85        add     a,l
0340 6f        ld      l,a
0341 18f6      jr      0339h
0343 71        ld      (hl),c
0344 e5        push    hl
0345 fde1      pop     iy
0347 21472d    ld      hl,2d47h
034a 34        inc     (hl)
034b c9        ret     

034c cd6303    call    0363h
034f d8        ret     c

0350 af        xor     a
0351 77        ld      (hl),a
0352 21472d    ld      hl,2d47h
0355 35        dec     (hl)
0356 b7        or      a
0357 c9        ret     

0358 e5        push    hl
0359 c5        push    bc
035a cd6303    call    0363h
035d e5        push    hl
035e fde1      pop     iy
0360 c1        pop     bc
0361 e1        pop     hl
0362 c9        ret     

0363 4f        ld      c,a
0364 0606      ld      b,06h
0366 21002c    ld      hl,2c00h
0369 7e        ld      a,(hl)
036a a9        xor     c
036b e6f8      and     0f8h
036d 2808      jr      z,0377h
036f 3e28      ld      a,28h
0371 85        add     a,l
0372 6f        ld      l,a
0373 10f4      djnz    0369h
0375 37        scf     
0376 c9        ret     

0377 7e        ld      a,(hl)
0378 b9        cp      c
0379 d8        ret     c

037a 79        ld      a,c
037b e607      and     07h
037d c9        ret     

037e e5        push    hl
037f 2afb3d    ld      hl,(3dfbh)
0382 e3        ex      (sp),hl
0383 c9        ret     

0384 d5        push    de
0385 e5        push    hl
0386 fd7d      ld      a,iyl
0388 dd6f      ld      ixl,a
038a 110024    ld      de,2400h
038d 2600      ld      h,00h
038f dd7c      ld      a,ixh
0391 87        add     a,a
0392 87        add     a,a
0393 87        add     a,a
0394 87        add     a,a
0395 87        add     a,a
0396 6f        ld      l,a
0397 cb14      rl      h
0399 19        add     hl,de
039a fd7c      ld      a,iyh
039c cdd403    call    03d4h
039f dd7d      ld      a,ixl
03a1 e5        push    hl
03a2 dde1      pop     ix
03a4 e1        pop     hl
03a5 d1        pop     de
03a6 c9        ret     

03a7 212a2d    ld      hl,2d2ah
03aa 11f10d    ld      de,0df1h
03ad 018403    ld      bc,0384h
03b0 3e01      ld      a,01h
03b2 77        ld      (hl),a
03b3 23        inc     hl
03b4 73        ld      (hl),e
03b5 23        inc     hl
03b6 72        ld      (hl),d
03b7 23        inc     hl
03b8 36ff      ld      (hl),0ffh
03ba d3e3      out     (0e3h),a		port E3 = 01; conmem off, page 1 (x2000)
03bc ed43fb3d  ld      (3dfbh),bc
03c0 af        xor     a
03c1 d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0 (x0000)
03c3 c9        ret     

execute_code_page1:
03c4 00        nop     
03c5 00        nop     
03c6 00        nop     
03c7 00        nop     
03c8 00        nop     
03c9 3e03      ld      a,03h
03cb d3e3      out     (0e3h),a		port E3 = 03; conmem off, page 3 (x6000)
03cd cd0020    call    2000h
03d0 af        xor     a
03d1 d3e3      out     (0e3h),a		port E3 = 00; conmem off, page 0
03d3 c9        ret     

03d4 c5        push    bc
03d5 fd210020  ld      iy,2000h
03d9 0604      ld      b,04h
03db fdbe00    cp      (iy+00h)
03de 2807      jr      z,03e7h
03e0 fd24      inc     iyh
03e2 10f7      djnz    03dbh
03e4 c1        pop     bc
03e5 37        scf     
03e6 c9        ret     

03e7 b7        or      a
03e8 c1        pop     bc
03e9 c9        ret     

03ea 47        ld      b,a
03eb 212a2d    ld      hl,2d2ah
03ee cde704    call    04e7h
03f1 dd67      ld      ixh,a
03f3 7e        ld      a,(hl)
03f4 feff      cp      0ffh
03f6 2813      jr      z,040bh
03f8 5f        ld      e,a
03f9 d5        push    de
03fa 23        inc     hl
03fb 5e        ld      e,(hl)
03fc 23        inc     hl
03fd 56        ld      d,(hl)
03fe 23        inc     hl
03ff e5        push    hl
0400 c5        push    bc
0401 cd0f04    call    040fh
0404 c1        pop     bc
0405 e1        pop     hl
0406 dde1      pop     ix
0408 d0        ret     nc

0409 18e3      jr      03eeh
040b 3e1e      ld      a,1eh
040d 37        scf     
040e c9        ret     

; a - ram page
; de
040f e5        push    hl
0410 e5        push    hl
0411 d3e3      out     (0e3h),a		port E3 = param
0413 32f83d    ld      (3df8h),a
0416 62        ld      h,d
0417 6b        ld      l,e
0418 cd7e03    call    037eh
041b c35a0b    jp      0b5ah

; bc - read len
041e 21f22d    ld      hl,2df2h			; buffer
0421 e5        push    hl
0422 cf        rst     08h			; jp 0985h ; read_sd_card_sector
0423 8a        adc     a,d
0424 e1        pop     hl
0425 47        ld      b,a
0426 a7        and     a
0427 c8        ret     z

0428 c5        push    bc
0429 cd3004    call    0430h
042c c1        pop     bc
042d 10f9      djnz    0428h
042f c9        ret     

0430 7e        ld      a,(hl)
0431 f7        rst     30h			; jr      0091h
0432 09        add     hl,bc
0433 3e20      ld      a,20h			; ' '
0435 d7        rst     10h			;jp      0845h		; print byte
0436 23        inc     hl
0437 23        inc     hl
0438 23        inc     hl
0439 f7        rst     30h			; jr      0091h
043a 01c5e5    ld      bc,0e5c5h
043d 01ff00    ld      bc,00ffh
0440 af        xor     a
0441 edb1      cpir    
0443 cd5804    call    0458h
0446 44        ld      b,h
0447 4d        ld      c,l
0448 e1        pop     hl
0449 cd5804    call    0458h
044c 6b        ld      l,e
044d 62        ld      h,d
044e d1        pop     de
044f c5        push    bc
0450 cd9a08    call    089ah
0453 3e0d      ld      a,0dh			; CR
0455 d7        rst     10h			; jp      0845h		; print byte
0456 e1        pop     hl
0457 c9        ret     

print_1:
0458 cd3e08    call    083eh			;print
045b 23        inc     hl
045c 3e2c      ld      a,2ch                    ; ','
045e d7        rst     10h			;jp      0845h		; print byte
045f 3e20      ld      a,20h                    ; ' '
0461 d7        rst     10h			;jp      0845h		; print byte
0462 c9        ret     

screen:
0463 21371b    ld      hl,1b37h
0466 110040    ld      de,4000h		; screen memory
0469 0e10      ld      c,10h
046b 7e        ld      a,(hl)
046c 04        inc     b
046d e6f0      and     0f0h
046f fea0      cp      0a0h
0471 7e        ld      a,(hl)
0472 23        inc     hl
0473 2005      jr      nz,047ah
0475 e60f      and     0fh
0477 c8        ret     z

0478 47        ld      b,a
0479 af        xor     a
047a 12        ld      (de),a
047b cd8105    call    0581h
047e 10f9      djnz    0479h
0480 18e9      jr      046bh
0482 6f        ld      l,a
0483 e6e0      and     0e0h
0485 c8        ret     z

print_hd_name:
0486 1e30      ld      e,30h
0488 0e66      ld      c,66h			; 'f'
048a fe20      cp      20h
048c 2810      jr      z,049eh
048e 0e76      ld      c,76h			; 'v'
0490 fe60      cp      60h
0492 280a      jr      z,049eh
0494 1e61      ld      e,61h
0496 fe80      cp      80h
0498 0e73      ld      c,73h			; 's'
049a 2802      jr      z,049eh
049c 0e68      ld      c,68h
049e 79        ld      a,c                      ; 'h'
049f d7        rst     10h			; jp      0845h		; print byte
04a0 3e64      ld      a,64h                    ; 'd'
04a2 d7        rst     10h			; jp      0845h		; print byte
04a3 7d        ld      a,l
04a4 0f        rrca    
04a5 0f        rrca    
04a6 0f        rrca    
04a7 e603      and     03h
04a9 83        add     a,e                      ; 'hd name a-b-c-d'
04aa d7        rst     10h			;jp      0845h		; print byte
04ab 7d        ld      a,l
04ac e607      and     07h
04ae c8        ret     z

print_digit:
04af c630      add     a,30h                    ; 'digit 0-9'
04b1 d7        rst     10h			;jp      0845h		; print byte
04b2 c9        ret     

04b3 00        nop     
04b4 00        nop     
04b5 00        nop     
04b6 00        nop     
04b7 00        nop     
04b8 00        nop     
04b9 00        nop     
04ba 00        nop     
04bb 00        nop     
04bc 00        nop     
04bd 00        nop     
04be 00        nop     
04bf 00        nop     
04c0 00        nop     
04c1 00        nop     
04c2 00        nop     
04c3 00        nop     
04c4 00        nop     
04c5 00        nop     
04c6 21801f    ld      hl,1f80h
04c9 e5        push    hl
04ca 47        ld      b,a
04cb af        xor     a
04cc d3e3      out     (0e3h),a		port E3 = 00
04ce 3a4c2d    ld      a,(2d4ch)
04d1 a7        and     a
04d2 78        ld      a,b
04d3 280c      jr      z,04e1h
04d5 d5        push    de
04d6 c5        push    bc
04d7 cdc423    call    23c4h		;mem copy execute_code_page1
04da c1        pop     bc
04db d1        pop     de
04dc e1        pop     hl
04dd 78        ld      a,b
04de d21120    jp      nc,2011h
04e1 21c904    ld      hl,04c9h
04e4 c3f41f    jp      1ff4h
04e7 e5        push    hl
04e8 c5        push    bc
04e9 21f12c    ld      hl,2cf1h
04ec 010f00    ld      bc,000fh
04ef af        xor     a
04f0 edb1      cpir    
04f2 3e0c      ld      a,0ch
04f4 37        scf     
04f5 ccfb04    call    z,04fbh
04f8 c1        pop     bc
04f9 e1        pop     hl
04fa c9        ret     

04fb 3e0f      ld      a,0fh
04fd 91        sub     c
04fe c9        ret     

sound_init:
04ff 01fdff    ld      bc,0fffdh
0502 3e07      ld      a,07h
0504 ed79      out     (c),a		port FFFD = 07; регистр адреса AY-3-8910
0506 06bf      ld      b,0bfh
0508 3eff      ld      a,0ffh
050a ed79      out     (c),a		port BFFD = FF; регистр данных AY-3-8910
050c c9        ret     

050d f5        push    af
050e dde5      push    ix
0510 e5        push    hl
0511 dde1      pop     ix
0513 2af83d    ld      hl,(3df8h)
0516 0ee3      ld      c,0e3h
0518 067f      ld      b,7fh
051a ed69      out     (c),l		port E3 = [3df8]
051c dd7e00    ld      a,(ix+00h)
051f ed61      out     (c),h		port E3 = [3df8]
0521 12        ld      (de),a
0522 dd23      inc     ix
0524 13        inc     de
0525 a7        and     a
0526 2802      jr      z,052ah
0528 10f0      djnz    051ah
052a dde5      push    ix
052c e1        pop     hl
052d dde1      pop     ix
052f f1        pop     af
0530 c9        ret     

0531 c5        push    bc
0532 fe2a      cp      2ah
0534 2010      jr      nz,0546h
0536 3af93d    ld      a,(3df9h)
0539 47        ld      b,a
053a 3e00      ld      a,00h
053c d3e3      out     (0e3h),a			port E3 = 00
053e 3a462d    ld      a,(2d46h)
0541 4f        ld      c,a
0542 78        ld      a,b
0543 d3e3      out     (0e3h),a			port E3 = ??
0545 79        ld      a,c
0546 f5        push    af
0547 e6f8      and     0f8h
0549 cb3f      srl     a
054b cb3f      srl     a
054d cb3f      srl     a
054f f660      or      60h                      ; '???'
0551 d7        rst     10h			;jp      0845h		; print byte
0552 3e64      ld      a,64h                    ; 'd'
0554 d7        rst     10h			;jp      0845h		; print byte
0555 f1        pop     af
0556 f5        push    af
0557 e607      and     07h
0559 c630      add     a,30h                    ; 'digit'
055b d7        rst     10h			;jp      0845h		; print byte
055c 3e3a      ld      a,3ah                    ; ':'
055e d7        rst     10h			;jp      0845h		; print byte
055f f1        pop     af
0560 c1        pop     bc
0561 c9        ret     

0562 dbfe      in      a,(0feh)			; keyboard input
0564 3e00      ld      a,00h
0566 d3e3      out     (0e3h),a			port E3 = 00
0568 3a4b2d    ld      a,(2d4bh)
056b a7        and     a
056c 2009      jr      nz,0577h
056e e5        push    hl
056f 216405    ld      hl,0564h
0572 dbfe      in      a,(0feh)			; keyboard input
0574 c3f41f    jp      1ff4h
0577 d5        push    de
0578 cdc423    call    23c4h			;execute_code_page1
057b d1        pop     de
057c 38f0      jr      c,056eh
057e c30e20    jp      200eh
0581 1c        inc     e
0582 0d        dec     c
0583 c0        ret     nz

0584 0e10      ld      c,10h
0586 7b        ld      a,e
0587 91        sub     c
0588 5f        ld      e,a
0589 14        inc     d
058a 7a        ld      a,d
058b e607      and     07h
058d c0        ret     nz

058e 7b        ld      a,e
058f c620      add     a,20h
0591 5f        ld      e,a
0592 d8        ret     c

0593 7a        ld      a,d
0594 d608      sub     08h
0596 57        ld      d,a
0597 c9        ret     

strcpy:
; hl - addr from
; de - addr to
0598 7e        ld      a,(hl)
0599 a7        and     a
059a c8        ret     z
059b 12        ld      (de),a
059c 23        inc     hl
059d 13        inc     de
059e 18f8      jr      0598h		; loop

05a0 a9        xor     c
05a1 0686      ld      b,86h
05a3 06f3      ld      b,0f3h
05a5 05        dec     b
05a6 a5        and     l
05a7 064b      ld      b,4bh
05a9 060d      ld      b,0dh
05ab 05        dec     b
05ac 43        ld      b,e
05ad 0619      ld      b,19h
05af 0694      ld      b,94h
05b1 0631      ld      b,31h
05b3 05        dec     b
05b4 be        cp      (hl)
05b5 05        dec     b
05b6 c305dd    jp      0dd05h
05b9 05        dec     b
05ba 8f        adc     a,a
05bb 0682      ld      b,82h
05bd 04        inc     b
05be 110020    ld      de,2000h
05c1 1805      jr      05c8h
05c3 210020    ld      hl,2000h
05c6 1800      jr      05c8h
05c8 cdd605    call    05d6h
05cb c8        ret     z

05cc 3e04      ld      a,04h
05ce d3e3      out     (0e3h),a			port E3 = 04
05d0 edb0      ldir    
05d2 af        xor     a
05d3 d3e3      out     (0e3h),a			port E3 = 00
05d5 c9        ret     

05d6 3a8c2e    ld      a,(2e8ch)
05d9 fe1c      cp      1ch
05db 37        scf     
05dc c9        ret     

05dd 5f        ld      e,a
05de cdd605    call    05d6h
05e1 c8        ret     z

load_sector_to_page4:
; bc - len
; e -
05e2 3e04      ld      a,04h
05e4 d3e3      out     (0e3h),a			;port E3 = 04, page 4
05e6 7b        ld      a,e
05e7 210020    ld      hl,2000h			; buffer
05ea cf        rst     08h			; jp 0985h ; read_sd_card_sector
05eb 9e        sbc     a,(hl)
05ec 5f        ld      e,a
05ed 3e00      ld      a,00h
05ef d3e3      out     (0e3h),a			;port E3 = 00
05f1 7b        ld      a,e
05f2 c9        ret     

05f3 df        rst     18h			;jp      0cbdh
05f4 2000      jr      nz,05f6h
05f6 c9        ret     

05f7 dde5      push    ix
05f9 e5        push    hl
05fa dde1      pop     ix
05fc 2af83d    ld      hl,(3df8h)
05ff c5        push    bc
0600 0ee3      ld      c,0e3h
0602 ed69      out     (c),l			port E3 = ??
0604 dd7e00    ld      a,(ix+00h)
0607 ed61      out     (c),h			port E3 = ??
0609 12        ld      (de),a
060a dd23      inc     ix
060c 13        inc     de
060d c1        pop     bc
060e 0b        dec     bc
060f 78        ld      a,b
0610 b1        or      c
0611 20ec      jr      nz,05ffh
0613 dde5      push    ix
0615 e1        pop     hl
0616 dde1      pop     ix
0618 c9        ret     

0619 7a        ld      a,d
061a fe40      cp      40h
061c 38d9      jr      c,05f7h
061e edb0      ldir    
0620 c9        ret     

0621 dde5      push    ix
0623 e5        push    hl
0624 dde1      pop     ix
0626 2af83d    ld      hl,(3df8h)
0629 c5        push    bc
062a 0ee3      ld      c,0e3h
062c dd7e00    ld      a,(ix+00h)
062f ed69      out     (c),l			port E3 = ??
0631 12        ld      (de),a
0632 ed61      out     (c),h			port E3 = ??
0634 dd23      inc     ix
0636 13        inc     de
0637 c1        pop     bc
0638 0b        dec     bc
0639 78        ld      a,b
063a b1        or      c
063b 20ec      jr      nz,0629h
063d dde5      push    ix
063f e1        pop     hl
0640 dde1      pop     ix
0642 c9        ret     

0643 7a        ld      a,d
0644 fe40      cp      40h
0646 38d9      jr      c,0621h
0648 edb0      ldir    
064a c9        ret     

064b f5        push    af
064c dde5      push    ix
064e e5        push    hl
064f dde1      pop     ix
0651 2af83d    ld      hl,(3df8h)
0654 7c        ld      a,h
0655 65        ld      h,l
0656 6f        ld      l,a
0657 0ee3      ld      c,0e3h
0659 067f      ld      b,7fh
065b ed69      out     (c),l			port E3 = ??
065d dd7e00    ld      a,(ix+00h)
0660 ed61      out     (c),h			port E3 = ??
0662 12        ld      (de),a
0663 dd23      inc     ix
0665 13        inc     de
0666 a7        and     a
0667 2802      jr      z,066bh
0669 10f0      djnz    065bh
066b ed69      out     (c),l			port E3 = ??
066d c32a05    jp      052ah

0670 0d 4d 6f 75 6e 74 69 6e 67 20 64 72 69 76 65 73		Mounting drives
0680 2e 2e 2e 0d 0d						...

0685 00        nop     
0686 5e        ld      e,(hl)
0687 23        inc     hl
0688 56        ld      d,(hl)
0689 23        inc     hl
068a 4e        ld      c,(hl)
068b 23        inc     hl
068c 46        ld      b,(hl)
068d 23        inc     hl
068e c9        ret     

068f 78        ld      a,b
0690 b1        or      c
0691 b2        or      d
0692 b3        or      e
0693 c9        ret     

;compare bc:de and [hl:hl]
0694 7e        ld      a,(hl)
0695 b8        cp      b	;compare b and a
0696 c0        ret     nz
0697 2b        dec     hl
0698 7e        ld      a,(hl)
0699 b9        cp      c
069a c0        ret     nz
069b 2b        dec     hl
069c 7e        ld      a,(hl)
069d ba        cp      d
069e c0        ret     nz
069f 2b        dec     hl
06a0 7e        ld      a,(hl)
06a1 bb        cp      e
06a2 c0        ret     nz
06a3 37        scf     
06a4 c9        ret     

06a5 df        rst     18h			;jp      0cbdh
06a6 3025      jr      nc,06cdh
06a8 c9        ret     

06a9 73        ld      (hl),e
06aa 23        inc     hl
06ab 72        ld      (hl),d
06ac 23        inc     hl
06ad 71        ld      (hl),c
06ae 23        inc     hl
06af 70        ld      (hl),b
06b0 23        inc     hl
06b1 c9        ret     

06b2 42 45 54 41 44 49 53 4b 00				BETADISK

06bb 17
06bc 18 01
06be 5b xx xx...					[ERROR]

06c7 17
06c8 1b 01
06ca 5b 4f 4b 5d 0d 00					[OK]

06d0 4c 6f 61 64 69 6e 67 20 00			Loading

06d9 4e 4d 49 00				NMI

06dd 2e 2e 2e 00				...

; bc - len
06e1 21f22d    ld      hl,2df2h		; buffer
06e4 e5        push    hl
06e5 cf        rst     08h		;jp      0985h ; read_sd_card_sector
06e6 84        add     a,h
06e7 e1        pop     hl
06e8 7e        ld      a,(hl)
06e9 a7        and     a
06ea c8        ret     z

; hl - buffer
06eb e5        push    hl
06ec 010000    ld      bc,0000h		; len - 0 bytes
06ef cf        rst     08h		; jp      0985h ; read_sd_card_sector
06f0 98        sbc     a,b
06f1 e1        pop     hl
06f2 110600    ld      de,0006h
06f5 19        add     hl,de
06f6 18f0      jr      06e8h
06f8 cd1407    call    0714h
06fb 37        scf     
06fc c8        ret     z

06fd 6f        ld      l,a
06fe e5        push    hl
06ff cd190b    call    0b19h
0702 e1        pop     hl
0703 d8        ret     c

0704 7d        ld      a,l
0705 cdc307    call    07c3h
0708 d8        ret     c

0709 af        xor     a
070a fde5      push    iy
070c e1        pop     hl
070d 77        ld      (hl),a
070e 23        inc     hl
070f 77        ld      (hl),a
0710 23        inc     hl
0711 77        ld      (hl),a
0712 b7        or      a
0713 c9        ret     

0714 c5        push    bc
0715 21f02c    ld      hl,2cf0h
0718 010f00    ld      bc,000fh
071b edb1      cpir    
071d c1        pop     bc
071e c0        ret     nz

071f 3e1d      ld      a,1dh
0721 c9        ret     

0722 21002d    ld      hl,2d00h
0725 060c      ld      b,0ch
0727 be        cp      (hl)
0728 2806      jr      z,0730h
072a 23        inc     hl
072b 23        inc     hl
072c 23        inc     hl
072d 10f8      djnz    0727h
072f c9        ret     

0730 3e1f      ld      a,1fh
0732 37        scf     
0733 c9        ret     

0734 6f        ld      l,a
0735 e5        push    hl
0736 c5        push    bc
0737 cd2207    call    0722h
073a c1        pop     bc
073b e1        pop     hl
073c d8        ret     c

073d 79        ld      a,c
073e a7        and     a
073f 2807      jr      z,0748h
0741 cdc307    call    07c3h
0744 3e0b      ld      a,0bh
0746 3f        ccf     
0747 d8        ret     c

0748 0c        inc     c
0749 7d        ld      a,l
074a 21f22d    ld      hl,2df2h		; buffer
074d c5        push    bc
074e e5        push    hl
074f cf        rst     08h		; jp      0985h ; read_sd_card_sector
0750 84        add     a,h
0751 e1        pop     hl
0752 3002      jr      nc,0756h
0754 c1        pop     bc
0755 c9        ret     

0756 cde607    call    07e6h
0759 c1        pop     bc
075a 7e        ld      a,(hl)
075b cd7f07    call    077fh
075e 0d        dec     c
075f 2008      jr      nz,0769h
0761 e5        push    hl
0762 c5        push    bc
0763 cdab07    call    07abh
0766 c1        pop     bc
0767 e1        pop     hl
0768 4f        ld      c,a
0769 eb        ex      de,hl
076a 1a        ld      a,(de)
076b e5        push    hl
076c c5        push    bc
076d cdea03    call    03eah
0770 c1        pop     bc
0771 e1        pop     hl
0772 d8        ret     c

0773 77        ld      (hl),a
0774 23        inc     hl
0775 71        ld      (hl),c
0776 23        inc     hl
0777 78        ld      a,b
0778 ddb5      or      ixl
077a f680      or      80h
077c 77        ld      (hl),a
077d 79        ld      a,c
077e c9        ret     

077f e5        push    hl
0780 c5        push    bc
0781 23        inc     hl
0782 e6e0      and     0e0h
0784 fe80      cp      80h
0786 2013      jr      nz,079bh
0788 7e        ld      a,(hl)
0789 cb7f      bit     7,a
078b 3e40      ld      a,40h
078d 280c      jr      z,079bh
078f 0640      ld      b,40h
0791 e607      and     07h
0793 fe05      cp      05h
0795 3e30      ld      a,30h
0797 2002      jr      nz,079bh
0799 3e18      ld      a,18h			;jp      0cbdh
079b 2b        dec     hl
079c 4f        ld      c,a
079d 7e        ld      a,(hl)
079e e6e0      and     0e0h
07a0 fe60      cp      60h
07a2 2002      jr      nz,07a6h
07a4 0eb0      ld      c,0b0h
07a6 79        ld      a,c
07a7 e1        pop     hl
07a8 4d        ld      c,l
07a9 e1        pop     hl
07aa c9        ret     

07ab 4f        ld      c,a
07ac cdb407    call    07b4h
07af 79        ld      a,c
07b0 d8        ret     c

07b1 3c        inc     a
07b2 18f7      jr      07abh
07b4 21012d    ld      hl,2d01h
07b7 060c      ld      b,0ch
07b9 7e        ld      a,(hl)
07ba b9        cp      c
07bb c8        ret     z

07bc 23        inc     hl
07bd 23        inc     hl
07be 23        inc     hl
07bf 10f8      djnz    07b9h
07c1 37        scf     
07c2 c9        ret     

07c3 c5        push    bc
07c4 cdfe07    call    07feh
07c7 3810      jr      c,07d9h
07c9 fd21002d  ld      iy,2d00h
07cd 060c      ld      b,0ch
07cf fdbe01    cp      (iy+01h)
07d2 280a      jr      z,07deh
07d4 cdf707    call    07f7h
07d7 10f6      djnz    07cfh
07d9 c1        pop     bc
07da 3e0b      ld      a,0bh
07dc 37        scf     
07dd c9        ret     

07de fd7e02    ld      a,(iy+02h)
07e1 e60f      and     0fh
07e3 b7        or      a
07e4 c1        pop     bc
07e5 c9        ret     

07e6 11002d    ld      de,2d00h
07e9 060c      ld      b,0ch
07eb 1a        ld      a,(de)
07ec a7        and     a
07ed c8        ret     z

07ee 13        inc     de
07ef 13        inc     de
07f0 13        inc     de
07f1 10f8      djnz    07ebh
07f3 3e0b      ld      a,0bh
07f5 37        scf     
07f6 c9        ret     

07f7 fd23      inc     iy
07f9 fd23      inc     iy
07fb fd23      inc     iy
07fd c9        ret     

07fe 47        ld      b,a
07ff a7        and     a
0800 37        scf     
0801 c8        ret     z

0802 fe2a      cp      2ah
0804 3a462d    ld      a,(2d46h)
0807 c8        ret     z

0808 78        ld      a,b
0809 fe24      cp      24h
080b 3a4a2d    ld      a,(2d4ah)
080e c8        ret     z

080f 78        ld      a,b
0810 b7        or      a
0811 c9        ret     

0812 80        add     a,b
0813 4e        ld      c,(hl)
0814 6f        ld      l,a
0815 20

0816 53 59 53 54 45 cd			No SYSTE


081c 1c		inc	e
081d c0		ret	nz

081e 14        inc     d
081f c0        ret     nz

0820 0c        inc     c
0821 c0        ret     nz

0822 04        inc     b
0823 c9        ret     

0824 3eff      ld      a,0ffh
0826 1d        dec     e
0827 bb        cp      e
0828 c0        ret     nz

0829 15        dec     d
082a ba        cp      d
082b c0        ret     nz

082c 0d        dec     c
082d b9        cp      c
082e c0        ret     nz

082f 05        dec     b
0830 c9        ret     

0831 19        add     hl,de
0832 eb        ex      de,hl
0833 d0        ret     nc

0834 03        inc     bc
0835 c9        ret     

0836 b7        or      a
0837 eb        ex      de,hl
0838 ed52      sbc     hl,de
083a eb        ex      de,hl
083b d0        ret     nc

083c 0b        dec     bc
083d c9        ret     

print:
; hl - string addr
; print asciz string
083e 7e        ld      a,(hl)
083f a7        and     a			; a &= a
0840 c8        ret     z			; ret if a == 0
0841 d7        rst     10h			;jp      0845h		; print byte
0842 23        inc     hl
0843 18f9      jr      083eh

print_byte:
; a - byte for print
0845 e5        push    hl
0846 d5        push    de
0847 c5        push    bc
0848 f5        push    af
0849 fde5      push    iy
084b fd213a5c  ld      iy,5c3ah			; ERR_NR value
084f df        rst     18h			;jp      0cbdh
0850 1000      djnz    0852h
0852 fde1      pop     iy
0854 f1        pop     af
0855 c1        pop     bc
0856 d1        pop     de
0857 e1        pop     hl
0858 c9        ret     

proc:
0859 0e30      ld      c,30h
085b 2600      ld      h,00h
085d 1814      jr      0873h

085f 0e20      ld      c,20h
0861 111027    ld      de,2710h
0864 cd7d08    call    087dh
0867 11e803    ld      de,03e8h
086a cd7d08    call    087dh
086d 116400    ld      de,0064h
0870 cd7d08    call    087dh
0873 110a00    ld      de,000ah
0876 cd7d08    call    087dh
0879 1e01      ld      e,01h
087b 0e30      ld      c,30h

087d 3e2f      ld      a,2fh
087f 3c        inc     a
0880 b7        or      a
0881 ed52      sbc     hl,de
0883 30fa      jr      nc,087fh
0885 19        add     hl,de
0886 fe3a      cp      3ah			':'
0888 300a      jr      nc,0894h
088a fe30      cp      30h			'0'
088c 2008      jr      nz,0896h
088e 79        ld      a,c
088f b7        or      a
0890 c41000    call    nz,0010h			; print byte
0893 c9        ret     

print_some:
0894 c607      add     a,07h
0896 0e30      ld      c,30h
0898 d7        rst     10h			;jp      0845h		; print byte
0899 c9        ret     

089a 7a        ld      a,d
089b b3        or      e
089c 200f      jr      nz,08adh
089e 5c        ld      e,h
089f 65        ld      h,l
08a0 2e00      ld      l,00h
08a2 cb24      sla     h
08a4 cb13      rl      e
08a6 cb12      rl      d
08a8 cdd308    call    08d3h
08ab 181e      jr      08cbh
08ad 6c        ld      l,h
08ae 63        ld      h,e
08af 5a        ld      e,d
08b0 1600      ld      d,00h
08b2 cb3b      srl     e
08b4 cb1c      rr      h
08b6 cb1d      rr      l
08b8 cb3b      srl     e
08ba cb1c      rr      h
08bc cb1d      rr      l
08be cb3b      srl     e
08c0 cb1c      rr      h
08c2 cb1d      rr      l
08c4 af        xor     a
08c5 cdda08    call    08dah
08c8 3e4d      ld      a,4dh			; 'M'
08ca d7        rst     10h			;jp      0845h		; print byte
08cb 78        ld      a,b
08cc fe42      cp      42h
08ce c8        ret     z

08cf 3e42      ld      a,42h			; 'B'
08d1 d7        rst     10h			;jp      0845h		; print byte
08d2 c9        ret     

08d3 af        xor     a
08d4 cdda08    call    08dah
08d7 78        ld      a,b                      ; '???'
08d8 d7        rst     10h			;jp      0845h		; print byte
08d9 c9        ret     

08da 010042    ld      bc,4200h
08dd 08        ex      af,af'
08de 7b        ld      a,e
08df b2        or      d
08e0 280e      jr      z,08f0h
08e2 cd0209    call    0902h
08e5 7b        ld      a,e
08e6 b7        or      a
08e7 064b      ld      b,4bh
08e9 2805      jr      z,08f0h
08eb cd0209    call    0902h
08ee 064d      ld      b,4dh
08f0 c5        push    bc
08f1 08        ex      af,af'
08f2 4f        ld      c,a
08f3 cd6108    call    0861h
08f6 c1        pop     bc
08f7 79        ld      a,c
08f8 b7        or      a
08f9 c8        ret     z

print_dot_digit:
; c - param 0 to 9
08fa 3e2e      ld      a,2eh			; '.'
08fc d7        rst     10h			;jp      0845h		; print byte
08fd 3e30      ld      a,30h
08ff 81        add     a,c                      ; 'digit'
0900 d7        rst     10h			;jp      0845h		; print byte
0901 c9        ret     

0902 af        xor     a
0903 6c        ld      l,h
0904 63        ld      h,e
0905 5a        ld      e,d
0906 57        ld      d,a
0907 cb3b      srl     e
0909 cb1c      rr      h
090b cb1d      rr      l
090d 3002      jr      nc,0911h
090f c602      add     a,02h
0911 cb3b      srl     e
0913 cb1c      rr      h
0915 cb1d      rr      l
0917 3002      jr      nc,091bh
0919 c605      add     a,05h
091b 4f        ld      c,a
091c c9        ret     

091d 0c
091e 0a
091f 51
0920 0a
0921 51
0922 0a
0923 5f
0924 0a
0925 83        add     a,e
0926 0b        dec     bc
0927 ee09      xor     09h
0929 c8        ret     z

092a 09        add     hl,bc
092b c8        ret     z

092c 09        add     hl,bc
092d c8        ret     z

092e 09        add     hl,bc
092f d9        exx     
0930 09        add     hl,bc
0931 e40a00    call    po,000ah
0934 2007      jr      nz,093dh
0936 20cc      jr      nz,0904h
0938 09        add     hl,bc
0939 d1        pop     de
093a 09        add     hl,bc
093b 3d        dec     a
093c 24        inc     h
093d a1        and     c
093e 22c809    ld      (09c8h),hl
0941 c8        ret     z

0942 09        add     hl,bc
0943 c8        ret     z

0944 09        add     hl,bc
0945 c8        ret     z

0946 09        add     hl,bc
0947 c8        ret     z

0948 09        add     hl,bc
0949 c8        ret     z

094a 09        add     hl,bc
094b c8        ret     z

094c 09        add     hl,bc
094d 34        inc     (hl)
094e 07        rlca    
094f f8        ret     m

0950 06a2      ld      b,0a2h
0952 0a        ld      a,(bc)
0953 ba        cp      d
0954 0a        ld      a,(bc)
0955 d0        ret     nc

0956 0a        ld      a,(bc)
0957 d0        ret     nc

0958 0a        ld      a,(bc)
0959 d0        ret     nc

095a 0a        ld      a,(bc)
095b d0        ret     nc

095c 0a        ld      a,(bc)
095d d0        ret     nc

095e 0a        ld      a,(bc)
095f d0        ret     nc

0960 0a        ld      a,(bc)
0961 d0        ret     nc

0962 0a        ld      a,(bc)
0963 a2        and     d
0964 0a        ld      a,(bc)
0965 d0        ret     nc

0966 0a        ld      a,(bc)
0967 d0        ret     nc

0968 0a        ld      a,(bc)
0969 d0        ret     nc

096a 0a        ld      a,(bc)
096b d0        ret     nc

096c 0a        ld      a,(bc)
096d 19        add     hl,de
096e 0b        dec     bc
096f 19        add     hl,de
0970 0b        dec     bc
0971 19        add     hl,de
0972 0b        dec     bc
0973 19        add     hl,de
0974 0b        dec     bc
0975 19        add     hl,de
0976 0b        dec     bc
0977 19        add     hl,de
0978 0b        dec     bc
0979 19        add     hl,de
097a 0b        dec     bc
097b 19        add     hl,de
097c 0b        dec     bc
097d 19        add     hl,de
097e 0b        dec     bc
097f 19        add     hl,de
0980 0b        dec     bc
0981 060b      ld      b,0bh
0983 19        add     hl,de
0984 0b        dec     bc

read_sd_card_sector:
; hl - mem addr
; bc - counter
; a - 
0985 e3        ex      (sp),hl
0986 32fa3d    ld      (3dfah),a
0989 7e        ld      a,(hl)
098a 23        inc     hl
098b e3        ex      (sp),hl
098c fde5      push    iy
098e dde5      push    ix
0990 d680      sub     80h
0992 fd6f      ld      iyl,a
0994 dd2af93d  ld      ix,(3df9h)
0998 af        xor     a
0999 d3e3      out     (0e3h),a			port E3 = 00
099b dd7d      ld      a,ixl
099d 32f83d    ld      (3df8h),a
09a0 dde5      push    ix
09a2 cdb409    call    09b4h		; load index from ROM??
09a5 dde1      pop     ix
09a7 fd6f      ld      iyl,a
09a9 dd7d      ld      a,ixl
09ab d3e3      out     (0e3h),a			port E3 = ??
09ad fd7d      ld      a,iyl
09af dde1      pop     ix
09b1 fde1      pop     iy
09b3 c9        ret     

09b4 fd7d      ld      a,iyl
09b6 e5        push    hl
09b7 211d09    ld      hl,091dh		; var
09ba 87        add     a,a
09bb 85        add     a,l
09bc 6f        ld      l,a
09bd 3001      jr      nc,09c0h		; 
09bf 24        inc     h
09c0 7e        ld      a,(hl)
09c1 23        inc     hl
09c2 66        ld      h,(hl)
09c3 6f        ld      l,a
09c4 dd7c      ld      a,ixh
09c6 e3        ex      (sp),hl
09c7 c9        ret     

09c8 3e14      ld      a,14h
09ca 37        scf     
09cb c9        ret     

09cc 3a322e    ld      a,(2e32h)
09cf b7        or      a
09d0 c9        ret     

09d1 110000    ld      de,0000h
09d4 019704    ld      bc,0497h
09d7 b7        or      a
09d8 c9        ret     

09d9 a7        and     a
09da 2005      jr      nz,09e1h
09dc 3a462d    ld      a,(2d46h)
09df b7        or      a
09e0 c9        ret     

09e1 fe2a      cp      2ah
09e3 c8        ret     z

09e4 4f        ld      c,a
09e5 cdc307    call    07c3h
09e8 d8        ret     c

09e9 79        ld      a,c
09ea 32462d    ld      (2d46h),a
09ed c9        ret     

09ee e6f8      and     0f8h
09f0 4f        ld      c,a
09f1 21002d    ld      hl,2d00h
09f4 060c      ld      b,0ch
09f6 7e        ld      a,(hl)
09f7 23        inc     hl
09f8 23        inc     hl
09f9 23        inc     hl
09fa e6f8      and     0f8h
09fc b9        cp      c
09fd 37        scf     
09fe c8        ret     z

09ff 10f5      djnz    09f6h
0a01 79        ld      a,c
0a02 c5        push    bc
0a03 cd5f0a    call    0a5fh
0a06 c1        pop     bc
0a07 d8        ret     c

0a08 79        ld      a,c
0a09 c34c03    jp      034ch

0a0c 22f43d    ld      (3df4h),hl
0a0f 32fa3d    ld      (3dfah),a
0a12 ed43f63d  ld      (3df6h),bc
0a16 ed53f23d  ld      (3df2h),de
0a1a cd6303    call    0363h
0a1d 3f        ccf     
0a1e 3e1f      ld      a,1fh
0a20 d8        ret     c

0a21 21242d    ld      hl,2d24h
0a24 5e        ld      e,(hl)
0a25 23        inc     hl
0a26 56        ld      d,(hl)
0a27 23        inc     hl
0a28 7a        ld      a,d
0a29 a7        and     a
0a2a 3e0e      ld      a,0eh
0a2c 37        scf     
0a2d c8        ret     z

0a2e e5        push    hl
0a2f cd360a    call    0a36h
0a32 e1        pop     hl
0a33 d0        ret     nc

0a34 18ee      jr      0a24h
0a36 2af43d    ld      hl,(3df4h)
0a39 ed4bf63d  ld      bc,(3df6h)
0a3d 3afa3d    ld      a,(3dfah)
0a40 d5        push    de
0a41 ed5bf23d  ld      de,(3df2h)
0a45 c9        ret     

0a46 d5        push    de
0a47 fd5d      ld      e,iyl
0a49 dd7c      ld      a,ixh
0a4b dd63      ld      ixh,e
0a4d d1        pop     de
0a4e c35803    jp      0358h
0a51 cd460a    call    0a46h
0a54 d8        ret     c

0a55 e5        push    hl
0a56 cd770a    call    0a77h
0a59 e1        pop     hl
0a5a 3007      jr      nc,0a63h
0a5c 3e0a      ld      a,0ah
0a5e c9        ret     

0a5f cd460a    call    0a46h
0a62 d8        ret     c

0a63 e5        push    hl
0a64 fd6603    ld      h,(iy+03h)
0a67 dd7c      ld      a,ixh
0a69 87        add     a,a
0a6a fd8602    add     a,(iy+02h)
0a6d 6f        ld      l,a
0a6e 3001      jr      nc,0a71h
0a70 24        inc     h
0a71 7e        ld      a,(hl)
0a72 23        inc     hl
0a73 66        ld      h,(hl)
0a74 6f        ld      l,a
0a75 e3        ex      (sp),hl
0a76 c9        ret     

0a77 fde5      push    iy
0a79 e1        pop     hl
0a7a a7        and     a
0a7b 2007      jr      nz,0a84h
0a7d 3e07      ld      a,07h
0a7f 85        add     a,l
0a80 6f        ld      l,a
0a81 c39406    jp      0694h		; compare bc:de and [hl:hl]

0a84 87        add     a,a
0a85 87        add     a,a
0a86 87        add     a,a
0a87 85        add     a,l
0a88 6f        ld      l,a
0a89 e5        push    hl
0a8a c607      add     a,07h
0a8c 6f        ld      l,a
0a8d cd9406    call    0694h		; compare bc:de and [hl:hl]
0a90 e1        pop     hl
0a91 d8        ret     c

0a92 7e        ld      a,(hl)
0a93 23        inc     hl
0a94 83        add     a,e
0a95 5f        ld      e,a
0a96 7e        ld      a,(hl)
0a97 23        inc     hl
0a98 8a        adc     a,d
0a99 57        ld      d,a
0a9a 7e        ld      a,(hl)
0a9b 23        inc     hl
0a9c 89        adc     a,c
0a9d 4f        ld      c,a
0a9e 7e        ld      a,(hl)
0a9f 88        adc     a,b
0aa0 47        ld      b,a
0aa1 c9        ret     

0aa2 cd190b    call    0b19h
0aa5 d8        ret     c

0aa6 e5        push    hl
0aa7 21f02c    ld      hl,2cf0h
0aaa dd7c      ld      a,ixh
0aac f5        push    af
0aad 85        add     a,l
0aae 6f        ld      l,a
0aaf fd7c      ld      a,iyh
0ab1 77        ld      (hl),a
0ab2 dd7c      ld      a,ixh
0ab4 cd730b    call    0b73h
0ab7 f1        pop     af
0ab8 e1        pop     hl
0ab9 c9        ret     

0aba cdd00a    call    0ad0h
0abd d8        ret     c

0abe dd7c      ld      a,ixh
0ac0 f5        push    af
0ac1 21f02c    ld      hl,2cf0h
0ac4 cdcb0a    call    0acbh
0ac7 f1        pop     af
0ac8 21222e    ld      hl,2e22h
0acb 85        add     a,l
0acc 6f        ld      l,a
0acd af        xor     a
0ace 77        ld      (hl),a
0acf c9        ret     

0ad0 d5        push    de
0ad1 11f02c    ld      de,2cf0h
0ad4 83        add     a,e
0ad5 5f        ld      e,a
0ad6 1a        ld      a,(de)
0ad7 a7        and     a
0ad8 57        ld      d,a
0ad9 dd7c      ld      a,ixh
0adb dd62      ld      ixh,d
0add 203f      jr      nz,0b1eh
0adf 3e0d      ld      a,0dh
0ae1 d1        pop     de
0ae2 37        scf     
0ae3 c9        ret     

0ae4 11012d    ld      de,2d01h
0ae7 060c      ld      b,0ch
0ae9 0e00      ld      c,00h
0aeb 1a        ld      a,(de)
0aec a7        and     a
0aed 2810      jr      z,0affh
0aef 0c        inc     c
0af0 d5        push    de
0af1 c5        push    bc
0af2 4f        ld      c,a
0af3 dd7d      ld      a,ixl
0af5 d3e3      out     (0e3h),a			port E3 = ??
0af7 79        ld      a,c
0af8 cf        rst     08h			;jp      0985h ; read_sd_card_sector
0af9 b2        or      d
0afa af        xor     a
0afb d3e3      out     (0e3h),a			port E3 = 00
0afd c1        pop     bc
0afe d1        pop     de
0aff 13        inc     de
0b00 13        inc     de
0b01 13        inc     de
0b02 10e7      djnz    0aebh
0b04 79        ld      a,c
0b05 c9        ret     

0b06 fde5      push    iy
0b08 cdc307    call    07c3h
0b0b c1        pop     bc
0b0c d8        ret     c

0b0d fd7e01    ld      a,(iy+01h)
0b10 47        ld      b,a
0b11 fd5600    ld      d,(iy+00h)
0b14 fd5e02    ld      e,(iy+02h)
0b17 fd69      ld      iyl,c
0b19 cde704    call    04e7h
0b1c d8        ret     c

0b1d d5        push    de
0b1e 5f        ld      e,a
0b1f fd55      ld      d,iyl
0b21 dd7c      ld      a,ixh
0b23 fe2a      cp      2ah
0b25 2003      jr      nz,0b2ah
0b27 3a462d    ld      a,(2d46h)
0b2a cdc307    call    07c3h
0b2d 38b2      jr      c,0ae1h
0b2f f5        push    af
0b30 fd7e01    ld      a,(iy+01h)
0b33 fd67      ld      iyh,a
0b35 fd6a      ld      iyl,d
0b37 dd63      ld      ixh,e
0b39 f1        pop     af
0b3a d1        pop     de
0b3b dde5      push    ix
0b3d fde5      push    iy
0b3f d3e3      out     (0e3h),a			port E3 = ??
0b41 dd7d      ld      a,ixl
0b43 32f83d    ld      (3df8h),a
0b46 22f43d    ld      (3df4h),hl
0b49 cd7e03    call    037eh
0b4c d618      sub     18h			;jp      0cbdh
0b4e fd6e02    ld      l,(iy+02h)
0b51 fd6603    ld      h,(iy+03h)
0b54 87        add     a,a
0b55 85        add     a,l
0b56 6f        ld      l,a
0b57 3001      jr      nc,0b5ah
0b59 24        inc     h
0b5a 7e        ld      a,(hl)
0b5b 23        inc     hl
0b5c 66        ld      h,(hl)
0b5d 6f        ld      l,a
0b5e cd6e0b    call    0b6eh
0b61 dd67      ld      ixh,a
0b63 3e00      ld      a,00h
0b65 d3e3      out     (0e3h),a			port E3 = 00
0b67 dd7c      ld      a,ixh
0b69 fde1      pop     iy
0b6b dde1      pop     ix
0b6d c9        ret     

0b6e e5        push    hl
0b6f 2af43d    ld      hl,(3df4h)
0b72 c9        ret     

0b73 dd67      ld      ixh,a
0b75 21222e    ld      hl,2e22h
0b78 85        add     a,l
0b79 6f        ld      l,a
0b7a dd7d      ld      a,ixl
0b7c fe02      cp      02h
0b7e c0        ret     nz

0b7f dd7c      ld      a,ixh
0b81 77        ld      (hl),a
0b82 c9        ret     

0b83 a7        and     a
0b84 2832      jr      z,0bb8h
0b86 47        ld      b,a
0b87 cd5803    call    0358h
0b8a 3003      jr      nc,0b8fh
0b8c 3e0e      ld      a,0eh
0b8e c9        ret     

0b8f 4f        ld      c,a
0b90 78        ld      a,b
0b91 e607      and     07h
0b93 b9        cp      c
0b94 38f6      jr      c,0b8ch
0b96 e5        push    hl
0b97 fde5      push    iy
0b99 e1        pop     hl
0b9a 11f22d    ld      de,2df2h
0b9d 78        ld      a,b
0b9e 12        ld      (de),a
0b9f 13        inc     de
0ba0 23        inc     hl
0ba1 eda0      ldi     
0ba3 23        inc     hl
0ba4 23        inc     hl
0ba5 e607      and     07h
0ba7 87        add     a,a
0ba8 87        add     a,a
0ba9 87        add     a,a
0baa 85        add     a,l
0bab 6f        ld      l,a
0bac 3001      jr      nc,0bafh
0bae 24        inc     h
0baf 010400    ld      bc,0004h
0bb2 edb0      ldir    
0bb4 0e06      ld      c,06h
0bb6 1846      jr      0bfeh
0bb8 e5        push    hl
0bb9 0606      ld      b,06h
0bbb 21002c    ld      hl,2c00h
0bbe 11f22d    ld      de,2df2h
0bc1 c5        push    bc
0bc2 e5        push    hl
0bc3 7e        ld      a,(hl)
0bc4 23        inc     hl
0bc5 a7        and     a
0bc6 2825      jr      z,0bedh
0bc8 47        ld      b,a
0bc9 e6f8      and     0f8h
0bcb 4f        ld      c,a
0bcc 78        ld      a,b
0bcd e607      and     07h
0bcf 47        ld      b,a
0bd0 7e        ld      a,(hl)
0bd1 dd6f      ld      ixl,a
0bd3 2b        dec     hl
0bd4 af        xor     a
0bd5 f5        push    af
0bd6 b1        or      c
0bd7 12        ld      (de),a
0bd8 13        inc     de
0bd9 dd7d      ld      a,ixl
0bdb 12        ld      (de),a
0bdc 13        inc     de
0bdd c5        push    bc
0bde 23        inc     hl
0bdf 23        inc     hl
0be0 23        inc     hl
0be1 23        inc     hl
0be2 010400    ld      bc,0004h
0be5 edb0      ldir    
0be7 c1        pop     bc
0be8 f1        pop     af
0be9 b8        cp      b
0bea 3c        inc     a
0beb 38e8      jr      c,0bd5h
0bed e1        pop     hl
0bee 012800    ld      bc,0028h
0bf1 09        add     hl,bc
0bf2 c1        pop     bc
0bf3 10cc      djnz    0bc1h
0bf5 af        xor     a
0bf6 12        ld      (de),a
0bf7 13        inc     de
0bf8 210ed2    ld      hl,0d20eh
0bfb 19        add     hl,de
0bfc 44        ld      b,h
0bfd 4d        ld      c,l
0bfe 21f22d    ld      hl,2df2h
0c01 d1        pop     de
0c02 f7        rst     30h			; jr      0091h
0c03 06b7      ld      b,0b7h
0c05 c9        ret     

0c06 323a5c    ld      (5c3ah),a
0c09 fdcb01ae  res     5,(iy+01h)
0c0d ed7b3d5c  ld      sp,(5c3dh)
0c11 df        rst     18h			;jp      0cbdh
0c12 3025      jr      nc,0c39h
0c14 21c516    ld      hl,16c5h
0c17 cafb1f    jp      z,1ffbh		; jump to x16c5

0c1a 210000    ld      hl,0000h
0c1d fd7437    ld      (iy+37h),h
0c20 fd7426    ld      (iy+26h),h
0c23 220b5c    ld      (5c0bh),hl
0c26 2c        inc     l
0c27 22165c    ld      (5c16h),hl
0c2a df        rst     18h			;jp      0cbdh
0c2b b0        or      b
0c2c 163a      ld      d,3ah
0c2e b0        or      b
0c2f 5c        ld      e,h
0c30 a7        and     a
0c31 c2cd24    jp      nz,24cdh
0c34 fdcb37ae  res     5,(iy+37h)
0c38 df        rst     18h			;jp      0cbdh
0c39 6e        ld      l,(hl)
0c3a 0d        dec     c
0c3b fdcb02ee  set     5,(iy+02h)
0c3f fdcb029e  res     3,(iy+02h)
0c43 3a3a5c    ld      a,(5c3ah)
0c46 a7        and     a
0c47 2ae83d    ld      hl,(3de8h)
0c4a 2836      jr      z,0c82h
0c4c 47        ld      b,a
0c4d 3af93d    ld      a,(3df9h)
0c50 f5        push    af
0c51 af        xor     a
0c52 d3e3      out     (0e3h),a			port E3 = 00
0c54 21bd23    ld      hl,23bdh
0c57 c5        push    bc
0c58 cd5723    call    2357h
0c5b c1        pop     bc
0c5c 301a      jr      nc,0c78h
0c5e fe0c      cp      0ch
0c60 2005      jr      nz,0c67h
0c62 21aa0c    ld      hl,0caah
0c65 181b      jr      0c82h
0c67 78        ld      a,b
0c68 fe01      cp      01h
0c6a 280c      jr      z,0c78h
0c6c 219c0c    ld      hl,0c9ch			"ESXDOS error"
0c6f cd900c    call    0c90h			;print
0c72 68        ld      l,b
0c73 cd5908    call    0859h
0c76 180d      jr      0c85h
0c78 2a1720    ld      hl,(2017h)
0c7b cb7e      bit     7,(hl)
0c7d 23        inc     hl
0c7e 28fb      jr      z,0c7bh
0c80 10f9      djnz    0c7bh
0c82 cd900c    call    0c90h			;print
0c85 f1        pop     af
0c86 d3e3      out     (0e3h),a			port E3 = ??
0c88 33        inc     sp
0c89 33        inc     sp
0c8a 214913    ld      hl,1349h
0c8d c3fb1f    jp      1ffbh		; jump to x1349

print:
; hl - addr of byte to print
0c90 7e        ld      a,(hl)
0c91 fe7f      cp      7fh
0c93 f5        push    af
0c94 e67f      and     7fh
0c96 d7        rst     10h			;jp      0845h		; print byte
0c97 f1        pop     af
0c98 d0        ret     nc

0c99 23        inc     hl
0c9a 18f4      jr      0c90h

0c9c 45 53 58 44				ESXD
0ca0 4f xx xx xx				OS error Too ma
0cb0 6e xx xx xx				ny OPEN FILE

0cbc d3

call_from_print_byte:
0cbd ed53f23d  ld      (3df2h),de
0cc1 e35e23    jp      po,235eh
0cc4 56        ld      d,(hl)
0cc5 23        inc     hl
0cc6 e3        ex      (sp),hl
0cc7 e5        push    hl
0cc8 21fd3d    ld      hl,3dfdh
0ccb e3        ex      (sp),hl
0ccc d5        push    de
0ccd ed5bf23d  ld      de,(3df2h)
0cd1 c3fa1f    jp      1ffah

0cd4 225f5c    ld      (5c5fh),hl		; X_PTR
0cd7 6f        ld      l,a
0cd8 3af93d    ld      a,(3df9h)
0cdb 67        ld      h,a
0cdc af        xor     a
0cdd d3e3      out     (0e3h),a			port E3 = 00
0cdf 7c        ld      a,h
0ce0 32f83d    ld      (3df8h),a
0ce3 7d        ld      a,l
0ce4 32fa3d    ld      (3dfah),a
0ce7 e1        pop     hl
0ce8 df        rst     18h			;jp      0cbdh
0ce9 7b        ld      a,e
0cea 00        nop     
0ceb 23        inc     hl
0cec e5        push    hl
0ced feff      cp      0ffh
0cef 2017      jr      nz,0d08h
0cf1 7c        ld      a,h
0cf2 fe40      cp      40h
0cf4 380f      jr      c,0d05h
0cf6 ed7b3d5c  ld      sp,(5c3dh)
0cfa 3af83d    ld      a,(3df8h)
0cfd d3e3      out     (0e3h),a			port E3 = ??
0cff 21c516    ld      hl,16c5h
0d02 c3fb1f    jp      1ffbh		; jump to x16c5

0d05 3e01      ld      a,01h
0d07 e7        rst     20h
0d08 fe1b      cp      1bh
0d0a 380c      jr      c,0d18h			;jp      0cbdh
0d0c dde5      push    ix
0d0e e1        pop     hl
0d0f cd8c09    call    098ch
0d12 e5        push    hl
0d13 dde1      pop     ix
0d15 c3fa1f    jp      1ffah
0d18 fdcb007e  bit     7,(iy+00h)
0d1c 323a5c    ld      (5c3ah),a
0d1f 2a5d5c    ld      hl,(5c5dh)
0d22 225f5c    ld      (5c5fh),hl
0d25 ca720d    jp      z,0d72h
0d28 fe0b      cp      0bh
0d2a 280d      jr      z,0d39h
0d2c fe0e      cp      0eh
0d2e 2809      jr      z,0d39h
0d30 fe17      cp      17h
0d32 2805      jr      z,0d39h
0d34 fe01      cp      01h
0d36 c2720d    jp      nz,0d72h
0d39 fdcb376e  bit     5,(iy+37h)
0d3d c2720d    jp      nz,0d72h
0d40 ed5b595c  ld      de,(5c59h)
0d44 a7        and     a
0d45 ed52      sbc     hl,de
0d47 3809      jr      c,0d52h
0d49 df        rst     18h			;jp      0cbdh
0d4a fb        ei      
0d4b 19        add     hl,de
0d4c 2a5d5c    ld      hl,(5c5dh)
0d4f 2b        dec     hl
0d50 1809      jr      0d5bh
0d52 2a455c    ld      hl,(5c45h)
0d55 df        rst     18h			;jp      0cbdh
0d56 6e        ld      l,(hl)
0d57 19        add     hl,de
0d58 23        inc     hl
0d59 23        inc     hl
0d5a 23        inc     hl
0d5b fd560d    ld      d,(iy+0dh)
0d5e 1e00      ld      e,00h
0d60 df        rst     18h			;jp      0cbdh
0d61 8b        adc     a,e
0d62 19        add     hl,de
0d63 f7        rst     30h			; jr      0091h
0d64 03        inc     bc
0d65 2003      jr      nz,0d6ah
0d67 df        rst     18h			;jp      0cbdh
0d68 a7        and     a
0d69 11dfbf    ld      de,0bfdfh
0d6c 16f7      ld      d,0f7h
0d6e 02        ld      (bc),a
0d6f cd1420    call    2014h
0d72 3af83d    ld      a,(3df8h)
0d75 d3e3      out     (0e3h),a			port E3 = ??
0d77 fdcb029e  res     3,(iy+02h)
0d7b 215800    ld      hl,0058h
0d7e f7        rst     30h			; jr      0091h
0d7f 03        inc     bc
0d80 cafb1f    jp      z,1ffbh		; jump to ??

0d83 3ab05c    ld      a,(5cb0h)
0d86 a7        and     a
0d87 cafb1f    jp      z,1ffbh		; jump to ??

0d8a fdcb00fe  set     7,(iy+00h)
0d8e 217d1b    ld      hl,1b7dh
0d91 c3fb1f    jp      1ffbh		; jump to x1b7d

0d94 cdcf0d    call    0dcfh
0d97 da2000    jp      c,0020h
0d9a cdeb0d    call    0debh
0d9d 2a462e    ld      hl,(2e46h)
0da0 3e02      ld      a,02h
0da2 d3e3      out     (0e3h),a			port E3 = 02
0da4 cd0020    call    2000h
0da7 22e83d    ld      (3de8h),hl
0daa da2000    jp      c,0020h
0dad 3e00      ld      a,00h
0daf d3e3      out     (0e3h),a			port E3 = 00
0db1 c3cd24    jp      24cdh
0db4 e5        push    hl
0db5 cdcf0d    call    0dcfh
0db8 e1        pop     hl
0db9 3807      jr      c,0dc2h
0dbb 3e02      ld      a,02h
0dbd d3e3      out     (0e3h),a			port E3 = 02
0dbf cd0020    call    2000h
0dc2 f5        push    af
0dc3 3e00      ld      a,00h
0dc5 d3e3      out     (0e3h),a			port E3 = 00
0dc7 3af03d    ld      a,(3df0h)
0dca 32f83d    ld      (3df8h),a
0dcd f1        pop     af
0dce c9        ret     

0dcf 47        ld      b,a
0dd0 3e02      ld      a,02h
0dd2 d3e3      out     (0e3h),a			port E3 = 02
0dd4 78        ld      a,b
0dd5 c5        push    bc
0dd6 210020    ld      hl,2000h
0dd9 01001c    ld      bc,1c00h
0ddc cf        rst     08h			;jp      0985h ; read_sd_card_sector
0ddd 9d        sbc     a,l
0dde c1        pop     bc
0ddf f5        push    af
0de0 78        ld      a,b
0de1 cf        rst     08h			;jp      0985h ; read_sd_card_sector
0de2 9b        sbc     a,e
0de3 f1        pop     af
0de4 47        ld      b,a
0de5 3e00      ld      a,00h
0de7 d3e3      out     (0e3h),a			port E3 = 00
0de9 78        ld      a,b
0dea c9        ret     

0deb 3e02      ld      a,02h
0ded df        rst     18h			;jp      0cbdh
0dee 0116c9    ld      bc,0c916h
0df1 56        ld      d,(hl)
0df2 0eb2      ld      c,0b2h
0df4 31de16    ld      sp,16deh
0df7 8f        adc     a,a
0df8 1697      ld      d,97h
0dfa 16de      ld      d,0deh
0dfc 1842      jr      0e40h
0dfe 319a36    ld      sp,369ah
0e01 c619      add     a,19h
0e03 ff        rst     38h
0e04 35        dec     (hl)
0e05 6e        ld      l,(hl)
0e06 36d2      ld      (hl),0d2h
0e08 33        inc     sp
0e09 02        ld      (bc),a
0e0a 34        inc     (hl)
0e0b 47        ld      b,a
0e0c 35        dec     (hl)
0e0d 90        sub     b
0e0e 3694      ld      (hl),94h
0e10 3677      ld      (hl),77h
0e12 16ad      ld      d,0adh
0e14 33        inc     sp
0e15 fb        ei      
0e16 324c35    ld      (354ch),a
0e19 e3        ex      (sp),hl
0e1a 35        dec     (hl)
0e1b 9d        sbc     a,l
0e1c 35        dec     (hl)
0e1d 3a36a9    ld      a,(0a936h)
0e20 32c431    ld      (31c4h),a
0e23 0b        dec     bc
0e24 35        dec     (hl)
0e25 2a0e29    ld      hl,(290eh)
0e28 0ec9      ld      c,0c9h
0e2a eb        ex      de,hl
0e2b 78        ld      a,b
0e2c cd4c0e    call    0e4ch
0e2f 7a        ld      a,d
0e30 cd4c0e    call    0e4ch
0e33 7b        ld      a,e
0e34 cd4c0e    call    0e4ch
0e37 fde5      push    iy
0e39 e1        pop     hl
0e3a 2e18      ld      l,18h			;jp      0cbdh
0e3c 010400    ld      bc,0004h
0e3f f7        rst     30h			; jr      0091h
0e40 062e      ld      b,2eh
0e42 04        inc     b
0e43 f7        rst     30h			; jr      0091h
0e44 04        inc     b
0e45 2e0c      ld      l,0ch
0e47 f7        rst     30h			; jr      0091h
0e48 04        inc     b
0e49 eb        ex      de,hl
0e4a b7        or      a
0e4b c9        ret     

0e4c 21fa3d    ld      hl,3dfah
0e4f 77        ld      (hl),a
0e50 010100    ld      bc,0001h
0e53 f7        rst     30h			; jr      0091h
0e54 06c9      ld      b,0c9h
0e56 c5        push    bc
0e57 cd6d0e    call    0e6dh
0e5a c1        pop     bc
0e5b d8        ret     c

0e5c e5        push    hl
0e5d fde1      pop     iy
0e5f 71        ld      (hl),c
0e60 2c        inc     l
0e61 70        ld      (hl),b
0e62 2c        inc     l
0e63 73        ld      (hl),e
0e64 2c        inc     l
0e65 72        ld      (hl),d
0e66 cd800e    call    0e80h
0e69 fd7e01    ld      a,(iy+01h)
0e6c c9        ret     

0e6d 210020    ld      hl,2000h
0e70 0604      ld      b,04h
0e72 7e        ld      a,(hl)
0e73 a7        and     a
0e74 c8        ret     z

0e75 24        inc     h
0e76 10fa      djnz    0e72h
0e78 37        scf     
0e79 c9        ret     

0e7a af        xor     a
0e7b fd7700    ld      (iy+00h),a
0e7e 37        scf     
0e7f c9        ret     

0e80 21002d    ld      hl,2d00h
0e83 010000    ld      bc,0000h
0e86 110000    ld      de,0000h
0e89 e5        push    hl
0e8a cd9610    call    1096h
0e8d e1        pop     hl
0e8e 38ea      jr      c,0e7ah
0e90 24        inc     h
0e91 2efe      ld      l,0feh
0e93 7e        ld      a,(hl)
0e94 2c        inc     l
0e95 a6        and     (hl)
0e96 20e2      jr      nz,0e7ah
0e98 25        dec     h
0e99 2e0b      ld      l,0bh
0e9b 7e        ld      a,(hl)
0e9c 2c        inc     l
0e9d b6        or      (hl)
0e9e fe02      cp      02h
0ea0 20d8      jr      nz,0e7ah
0ea2 2e10      ld      l,10h
0ea4 7e        ld      a,(hl)
0ea5 fe02      cp      02h
0ea7 20d1      jr      nz,0e7ah
0ea9 21002d    ld      hl,2d00h
0eac 2e13      ld      l,13h
0eae 5e        ld      e,(hl)
0eaf 2c        inc     l
0eb0 56        ld      d,(hl)
0eb1 7a        ld      a,d
0eb2 b3        or      e
0eb3 200a      jr      nz,0ebfh
0eb5 2e20      ld      l,20h
0eb7 f7        rst     30h			; jr      0091h
0eb8 01fd70    ld      bc,70fdh
0ebb 1b        dec     de
0ebc fd711a    ld      (iy+1ah),c
0ebf fd7219    ld      (iy+19h),d
0ec2 fd7318    ld      (iy+18h),e
0ec5 2e0d      ld      l,0dh
0ec7 7e        ld      a,(hl)
0ec8 fd7725    ld      (iy+25h),a
0ecb 2c        inc     l
0ecc 5e        ld      e,(hl)
0ecd 2c        inc     l
0ece 56        ld      d,(hl)
0ecf fd721e    ld      (iy+1eh),d
0ed2 fd731d    ld      (iy+1dh),e
0ed5 2e3a      ld      l,3ah
0ed7 7e        ld      a,(hl)
0ed8 fe32      cp      32h
0eda 289e      jr      z,0e7ah
0edc 2d        dec     l
0edd 7e        ld      a,(hl)
0ede 2e36      ld      l,36h
0ee0 fe31      cp      31h
0ee2 3e00      ld      a,00h
0ee4 2803      jr      z,0ee9h
0ee6 2e52      ld      l,52h
0ee8 3c        inc     a
0ee9 fd771c    ld      (iy+1ch),a
0eec d5        push    de
0eed fde5      push    iy
0eef d1        pop     de
0ef0 1e04      ld      e,04h
0ef2 010500    ld      bc,0005h
0ef5 edb0      ldir    
0ef7 d1        pop     de
0ef8 fe01      cp      01h
0efa 2842      jr      z,0f3eh
0efc e5        push    hl
0efd 2e16      ld      l,16h
0eff 7e        ld      a,(hl)
0f00 2c        inc     l
0f01 66        ld      h,(hl)
0f02 6f        ld      l,a
0f03 af        xor     a
0f04 fd7722    ld      (iy+22h),a
0f07 fd7721    ld      (iy+21h),a
0f0a fd7420    ld      (iy+20h),h
0f0d fd751f    ld      (iy+1fh),l
0f10 cb25      sla     l
0f12 cb14      rl      h
0f14 19        add     hl,de
0f15 eb        ex      de,hl
0f16 fd7224    ld      (iy+24h),d
0f19 fd7323    ld      (iy+23h),e
0f1c e1        pop     hl
0f1d 2e11      ld      l,11h
0f1f 7e        ld      a,(hl)
0f20 2c        inc     l
0f21 66        ld      h,(hl)
0f22 6f        ld      l,a
0f23 cb3c      srl     h
0f25 cb1d      rr      l
0f27 cb3c      srl     h
0f29 cb1d      rr      l
0f2b cb3c      srl     h
0f2d cb1d      rr      l
0f2f cb3c      srl     h
0f31 cb1d      rr      l
0f33 fd7542    ld      (iy+42h),l
0f36 010000    ld      bc,0000h
0f39 cd3108    call    0831h
0f3c 182a      jr      0f68h
0f3e fde5      push    iy
0f40 d1        pop     de
0f41 1e26      ld      e,26h
0f43 2e2c      ld      l,2ch
0f45 eda0      ldi     
0f47 eda0      ldi     
0f49 eda0      ldi     
0f4b eda0      ldi     
0f4d 2e24      ld      l,24h
0f4f f7        rst     30h			; jr      0091h
0f50 01fd70    ld      bc,70fdh
0f53 22fd71    ld      (71fdh),hl
0f56 21fd72    ld      hl,72fdh
0f59 20fd      jr      nz,0f58h
0f5b 73        ld      (hl),e
0f5c 1f        rra     
0f5d cb23      sla     e
0f5f cb12      rl      d
0f61 cb11      rl      c
0f63 cb10      rl      b
0f65 cd7311    call    1173h
0f68 2600      ld      h,00h
0f6a fd6e25    ld      l,(iy+25h)
0f6d cb25      sla     l
0f6f cb14      rl      h
0f71 cd3608    call    0836h
0f74 fd702d    ld      (iy+2dh),b
0f77 fd712c    ld      (iy+2ch),c
0f7a fd722b    ld      (iy+2bh),d
0f7d fd732a    ld      (iy+2ah),e
0f80 cd8e0f    call    0f8eh
0f83 cdbe0f    call    0fbeh
0f86 cd6510    call    1065h
0f89 cd2110    call    1021h
0f8c b7        or      a
0f8d c9        ret     

0f8e fd6619    ld      h,(iy+19h)
0f91 fd6e18    ld      l,(iy+18h)
0f94 b7        or      a
0f95 ed52      sbc     hl,de
0f97 eb        ex      de,hl
0f98 fd661b    ld      h,(iy+1bh)
0f9b fd6e1a    ld      l,(iy+1ah)
0f9e ed42      sbc     hl,bc
0fa0 fd7e25    ld      a,(iy+25h)
0fa3 cb3f      srl     a
0fa5 380a      jr      c,0fb1h
0fa7 cb3c      srl     h
0fa9 cb1d      rr      l
0fab cb1a      rr      d
0fad cb1b      rr      e
0faf 18f2      jr      0fa3h
0fb1 fd733e    ld      (iy+3eh),e
0fb4 fd723f    ld      (iy+3fh),d
0fb7 fd7540    ld      (iy+40h),l
0fba fd7441    ld      (iy+41h),h
0fbd c9        ret     

0fbe fd7e1c    ld      a,(iy+1ch)
0fc1 fe01      cp      01h
0fc3 204a      jr      nz,100fh
0fc5 21302d    ld      hl,2d30h
0fc8 7e        ld      a,(hl)
0fc9 3d        dec     a
0fca 2043      jr      nz,100fh
0fcc 21003e    ld      hl,3e00h
0fcf 010000    ld      bc,0000h
0fd2 110100    ld      de,0001h
0fd5 e5        push    hl
0fd6 cd9610    call    1096h
0fd9 e1        pop     hl
0fda 3833      jr      c,100fh
0fdc 24        inc     h
0fdd 2ee4      ld      l,0e4h
0fdf 7e        ld      a,(hl)
0fe0 2c        inc     l
0fe1 ae        xor     (hl)
0fe2 2c        inc     l
0fe3 86        add     a,(hl)
0fe4 2c        inc     l
0fe5 a6        and     (hl)
0fe6 fe41      cp      41h
0fe8 2025      jr      nz,100fh
0fea 2efe      ld      l,0feh
0fec 7e        ld      a,(hl)
0fed 2c        inc     l
0fee a6        and     (hl)
0fef 201e      jr      nz,100fh
0ff1 3e01      ld      a,01h
0ff3 fd773d    ld      (iy+3dh),a
0ff6 3a412d    ld      a,(2d41h)
0ff9 e601      and     01h
0ffb 2012      jr      nz,100fh
0ffd 2ee8      ld      l,0e8h
0fff f7        rst     30h			; jr      0091h
1000 0178b1    ld      bc,0b178h
1003 b2        or      d
1004 b3        or      e
1005 2808      jr      z,100fh
1007 cdd011    call    11d0h
100a f7        rst     30h			; jr      0091h
100b 01c3b6    ld      bc,0b6c3h
100e 1101ff    ld      de,0ff01h
1011 ff        rst     38h
1012 11ffff    ld      de,0ffffh
1015 cdd011    call    11d0h
1018 010000    ld      bc,0000h
101b 110200    ld      de,0002h
101e c3b611    jp      11b6h
1021 211614    ld      hl,1416h
1024 3e08      ld      a,08h
1026 cd7014    call    1470h
1029 3003      jr      nc,102eh
102b 212b2d    ld      hl,2d2bh
102e fde5      push    iy
1030 d1        pop     de
1031 1e0c      ld      e,0ch
1033 7e        ld      a,(hl)
1034 a7        and     a
1035 2003      jr      nz,103ah
1037 215c10    ld      hl,105ch			"UNNAMED"
103a cd3e10    call    103eh
103d c9        ret     

103e 060b      ld      b,0bh
1040 7e        ld      a,(hl)
1041 fe20      cp      20h
1043 2806      jr      z,104bh
1045 12        ld      (de),a
1046 23        inc     hl
1047 13        inc     de
1048 10f6      djnz    1040h
104a c9        ret     

104b 23        inc     hl
104c 7e        ld      a,(hl)
104d fe20      cp      20h
104f 2b        dec     hl
1050 7e        ld      a,(hl)
1051 20f2      jr      nz,1045h
1053 78        ld      a,b
1054 fe0b      cp      0bh
1056 28df      jr      z,1037h
1058 3e00      ld      a,00h
105a 12        ld      (de),a
105b c9        ret     

105c 55 xx xx xx				UNNAMED

1065 cd6911    call    1169h
1068 cd7b10    call    107bh
106b fde5      push    iy
106d e1        pop     hl
106e 2e80      ld      l,80h
1070 3e2f      ld      a,2fh
1072 77        ld      (hl),a
1073 2c        inc     l
1074 7d        ld      a,l
1075 fd757f    ld      (iy+7fh),l
1078 af        xor     a
1079 77        ld      (hl),a
107a c9        ret     

107b fd7e1c    ld      a,(iy+1ch)
107e fe01      cp      01h
1080 2007      jr      nz,1089h
1082 78        ld      a,b
1083 b1        or      c
1084 b2        or      d
1085 b3        or      e
1086 cc6911    call    z,1169h
1089 fd7031    ld      (iy+31h),b
108c fd7130    ld      (iy+30h),c
108f fd722f    ld      (iy+2fh),d
1092 fd732e    ld      (iy+2eh),e
1095 c9        ret     

1096 c5        push    bc
1097 d5        push    de
1098 fd7e01    ld      a,(iy+01h)
109b cf        rst     08h			;jp      0985h ; read_sd_card_sector
109c 81        add     a,c
109d d1        pop     de
109e c1        pop     bc
109f c9        ret     

10a0 fd7e01    ld      a,(iy+01h)
10a3 cf        rst     08h			;jp      0985h ; read_sd_card_sector
10a4 82        add     a,d
10a5 c9        ret     

10a6 c5        push    bc
10a7 d5        push    de
10a8 3a253c    ld      a,(3c25h)
10ab cf        rst     08h			;jp      0985h ; read_sd_card_sector
10ac 82        add     a,d
10ad d1        pop     de
10ae c1        pop     bc
10af c9        ret     

10b0 cd7f11    call    117fh
10b3 18f1      jr      10a6h
10b5 cd7f11    call    117fh
10b8 18dc      jr      1096h

10ba 3a253c    ld      a,(3c25h)
10bd fdbe01    cp      (iy+01h)
10c0 2006      jr      nz,10c8h
10c2 21143c    ld      hl,3c14h
10c5 cd9406    call    0694h		; compare bc:de and [hl:hl]
10c8 210028    ld      hl,2800h
10cb 3f        ccf     
10cc c8        ret     z

10cd cdf310    call    10f3h
10d0 d8        ret     c

10d1 d5        push    de
10d2 c5        push    bc
10d3 e5        push    hl
10d4 cd7311    call    1173h
10d7 e5        push    hl
10d8 cd9610    call    1096h
10db e1        pop     hl
10dc dcb510    call    c,10b5h
10df e1        pop     hl
10e0 c1        pop     bc
10e1 d1        pop     de
10e2 f5        push    af
10e3 fd7e01    ld      a,(iy+01h)
10e6 32253c    ld      (3c25h),a
10e9 ed53113c  ld      (3c11h),de
10ed ed43133c  ld      (3c13h),bc
10f1 f1        pop     af
10f2 c9        ret     

10f3 3a2b3c    ld      a,(3c2bh)
10f6 b7        or      a
10f7 c8        ret     z

10f8 c5        push    bc
10f9 d5        push    de
10fa e5        push    hl
10fb ed5b113c  ld      de,(3c11h)
10ff ed4b133c  ld      bc,(3c13h)
1103 cd1111    call    1111h
1106 e1        pop     hl
1107 d1        pop     de
1108 c1        pop     bc
1109 c9        ret     

110a 3eff      ld      a,0ffh
110c 322b3c    ld      (3c2bh),a
110f b7        or      a
1110 c9        ret     

1111 af        xor     a
1112 322b3c    ld      (3c2bh),a
1115 210028    ld      hl,2800h
1118 d5        push    de
1119 c5        push    bc
111a e5        push    hl
111b cd7311    call    1173h
111e e5        push    hl
111f cda610    call    10a6h
1122 e1        pop     hl
1123 3804      jr      c,1129h
1125 cdb010    call    10b0h
1128 b7        or      a
1129 dcb010    call    c,10b0h
112c 3803      jr      c,1131h
112e cddd11    call    11ddh
1131 e1        pop     hl
1132 c1        pop     bc
1133 d1        pop     de
1134 c9        ret     

index_proc:
1135 dd7314    ld      (ix+14h),e
1138 dd7215    ld      (ix+15h),d
113b dd7116    ld      (ix+16h),c
113e dd7017    ld      (ix+17h),b
1141 c9        ret     

index_proc:
1142 dd5e14    ld      e,(ix+14h)
1145 dd5615    ld      d,(ix+15h)
1148 dd4e16    ld      c,(ix+16h)
114b dd4617    ld      b,(ix+17h)
114e c9        ret     

index_proc:
114f dd7318    ld      (ix+18h),e
1152 dd7219    ld      (ix+19h),d
1155 dd711a    ld      (ix+1ah),c
1158 dd701b    ld      (ix+1bh),b
115b c9        ret     

index_proc:
115c dd5e18    ld      e,(ix+18h)
115f dd5619    ld      d,(ix+19h)
1162 dd4e1a    ld      c,(ix+1ah)
1165 dd461b    ld      b,(ix+1bh)
1168 c9        ret     

1169 e5        push    hl
116a fde5      push    iy
116c e1        pop     hl
116d 2e26      ld      l,26h
116f f7        rst     30h			; jr      0091h
1170 01e1c9    ld      bc,0c9e1h
1173 e5        push    hl
1174 fd6e1d    ld      l,(iy+1dh)
1177 fd661e    ld      h,(iy+1eh)
117a cd3108    call    0831h
117d e1        pop     hl
117e c9        ret     

117f e5        push    hl
1180 c5        push    bc
1181 d5        push    de
1182 cd8f11    call    118fh
1185 e1        pop     hl
1186 19        add     hl,de
1187 eb        ex      de,hl
1188 e1        pop     hl
1189 ed4a      adc     hl,bc
118b 44        ld      b,h
118c 4d        ld      c,l
118d e1        pop     hl
118e c9        ret     

118f fd5e1f    ld      e,(iy+1fh)
1192 fd5620    ld      d,(iy+20h)
1195 fd4e21    ld      c,(iy+21h)
1198 fd4622    ld      b,(iy+22h)
119b c9        ret     

119c fd4631    ld      b,(iy+31h)
119f fd4e30    ld      c,(iy+30h)
11a2 fd562f    ld      d,(iy+2fh)
11a5 fd5e2e    ld      e,(iy+2eh)
11a8 c9        ret     

11a9 fd5e35    ld      e,(iy+35h)
11ac fd5636    ld      d,(iy+36h)
11af fd4e37    ld      c,(iy+37h)
11b2 fd4638    ld      b,(iy+38h)
11b5 c9        ret     

11b6 fd7335    ld      (iy+35h),e
11b9 fd7236    ld      (iy+36h),d
11bc fd7137    ld      (iy+37h),c
11bf fd7038    ld      (iy+38h),b
11c2 c9        ret     

11c3 fd5e39    ld      e,(iy+39h)
11c6 fd563a    ld      d,(iy+3ah)
11c9 fd4e3b    ld      c,(iy+3bh)
11cc fd463c    ld      b,(iy+3ch)
11cf c9        ret     

11d0 fd7339    ld      (iy+39h),e
11d3 fd723a    ld      (iy+3ah),d
11d6 fd713b    ld      (iy+3bh),c
11d9 fd703c    ld      (iy+3ch),b
11dc c9        ret     

11dd fd7e3d    ld      a,(iy+3dh)
11e0 b7        or      a
11e1 c8        ret     z

11e2 21e83f    ld      hl,3fe8h
11e5 cdc311    call    11c3h
11e8 f7        rst     30h			; jr      0091h
11e9 00        nop     
11ea cda911    call    11a9h		; indexes
11ed f7        rst     30h			; jr      0091h
11ee 00        nop     
11ef 21003e    ld      hl,3e00h
11f2 010000    ld      bc,0000h
11f5 110100    ld      de,0001h
11f8 c3a010    jp      10a0h
11fb cd5c11    call    115ch			; index_proc
11fe cd9610    call    1096h
1201 c9        ret     

1202 cd5c11    call    115ch			; index_proc
1205 3a263c    ld      a,(3c26h)
1208 fdbe01    cp      (iy+01h)
120b 2006      jr      nz,1213h
120d 212a3c    ld      hl,3c2ah
1210 cd9406    call    0694h		; compare bc:de and [hl:hl]
1213 21002a    ld      hl,2a00h
1216 3f        ccf     
1217 c8        ret     z

1218 fd7e01    ld      a,(iy+01h)
121b 32263c    ld      (3c26h),a
121e ed53273c  ld      (3c27h),de
1222 ed43293c  ld      (3c29h),bc
1226 e5        push    hl
1227 cdfb11    call    11fbh
122a e1        pop     hl
122b c9        ret     

122c e5        push    hl
122d 21002a    ld      hl,2a00h
1230 cd3c31    call    313ch
1233 e1        pop     hl
1234 c9        ret     

1235 cd5c11    call    115ch			; index_proc
1238 fd7e01    ld      a,(iy+01h)
123b d9        exx     
123c c5        push    bc
123d d5        push    de
123e 0ee3      ld      c,0e3h
1240 ed5bf83d  ld      de,(3df8h)
1244 ed59      out     (c),e			port E3 = ??
1246 d9        exx     
1247 cf        rst     08h			;jp      0985h ; read_sd_card_sector
1248 81        add     a,c
1249 d9        exx     
124a ed51      out     (c),d			port E3 = ??
124c d1        pop     de
124d c1        pop     bc
124e d9        exx     
124f c9        ret     

1250 dd3513    dec     (ix+13h)
1253 2809      jr      z,125eh
1255 cd5c11    call    115ch			; index_proc
1258 cd1c08    call    081ch		; inc e
125b c34f11    jp      114fh			; index_proc
125e cdb212    call    12b2h
1261 d8        ret     c

1262 c3a912    jp      12a9h
1265 fd7e1c    ld      a,(iy+1ch)
1268 fe01      cp      01h
126a 2811      jr      z,127dh
126c 7b        ld      a,e
126d b2        or      d
126e 200d      jr      nz,127dh
1270 010000    ld      bc,0000h
1273 fd5624    ld      d,(iy+24h)
1276 fd5e23    ld      e,(iy+23h)
1279 fd7e42    ld      a,(iy+42h)
127c c9        ret     

127d fd7e25    ld      a,(iy+25h)
1280 cb3f      srl     a
1282 380a      jr      c,128eh
1284 cb23      sla     e
1286 cb12      rl      d
1288 cb11      rl      c
128a cb10      rl      b
128c 18f2      jr      1280h
128e fd7e2a    ld      a,(iy+2ah)
1291 83        add     a,e
1292 5f        ld      e,a
1293 fd7e2b    ld      a,(iy+2bh)
1296 8a        adc     a,d
1297 57        ld      d,a
1298 fd7e2c    ld      a,(iy+2ch)
129b 89        adc     a,c
129c 4f        ld      c,a
129d fd7e2d    ld      a,(iy+2dh)
12a0 88        adc     a,b
12a1 47        ld      b,a
12a2 fd7e25    ld      a,(iy+25h)
12a5 c9        ret     

12a6 cd3511    call    1135h			; index_proc
12a9 cd6512    call    1265h
12ac dd7713    ld      (ix+13h),a
12af c34f11    jp      114fh			; index_proc
12b2 cd4211    call    1142h			; index_proc
12b5 cdc712    call    12c7h
12b8 d23511    jp      nc,1135h			; index_proc
12bb fe80      cp      80h
12bd 37        scf     
12be c0        ret     nz

12bf ddcb0156  bit     2,(ix+01h)
12c3 c8        ret     z

12c4 c30030    jp      3000h

12c7 fd7e1c    ld      a,(iy+1ch)
12ca fe01      cp      01h
12cc 2826      jr      z,12f4h
12ce d5        push    de
12cf 5a        ld      e,d
12d0 51        ld      d,c
12d1 48        ld      c,b
12d2 0600      ld      b,00h
12d4 cdba10    call    10bah
12d7 d1        pop     de
12d8 d8        ret     c

12d9 af        xor     a
12da cb23      sla     e
12dc 6b        ld      l,e
12dd 8c        adc     a,h
12de 67        ld      h,a
12df 5e        ld      e,(hl)
12e0 23        inc     hl
12e1 56        ld      d,(hl)
12e2 2b        dec     hl
12e3 010000    ld      bc,0000h
12e6 7a        ld      a,d
12e7 feff      cp      0ffh
12e9 3f        ccf     
12ea c0        ret     nz

12eb 7b        ld      a,e
12ec e6f0      and     0f0h
12ee fef0      cp      0f0h
12f0 3f        ccf     
12f1 3e80      ld      a,80h
12f3 c9        ret     

12f4 d5        push    de
12f5 7b        ld      a,e
12f6 5a        ld      e,d
12f7 51        ld      d,c
12f8 48        ld      c,b
12f9 0600      ld      b,00h
12fb cb27      sla     a
12fd cb13      rl      e
12ff cb12      rl      d
1301 cb11      rl      c
1303 cb10      rl      b
1305 cdba10    call    10bah
1308 d1        pop     de
1309 d8        ret     c

130a af        xor     a
130b cb23      sla     e
130d cb23      sla     e
130f 6b        ld      l,e
1310 8c        adc     a,h
1311 67        ld      h,a
1312 e5        push    hl
1313 f7        rst     30h			; jr      0091h
1314 01e178    ld      bc,78e1h
1317 fe0f      cp      0fh
1319 20cc      jr      nz,12e7h
131b 3eff      ld      a,0ffh
131d a1        and     c
131e a2        and     d
131f 18c6      jr      12e7h
1321 d5        push    de
1322 cdc311    call    11c3h
1325 04        inc     b
1326 280a      jr      z,1332h
1328 05        dec     b
1329 dc1c08    call    c,081ch		; inc e
132c d42408    call    nc,0824h		; math
132f cdd011    call    11d0h
1332 d1        pop     de
1333 c9        ret     

1334 c5        push    bc
1335 d5        push    de
1336 cdc311    call    11c3h
1339 f7        rst     30h			; jr      0091h
133a 0d        dec     c
133b d1        pop     de
133c c1        pop     bc
133d c0        ret     nz

133e 3e09      ld      a,09h
1340 37        scf     				; set the carry flag
1341 c9        ret     

1342 cd5c11    call    115ch			; index_proc
1345 fd7e01    ld      a,(iy+01h)
1348 d9        exx     				; store reg
1349 c5        push    bc
134a d5        push    de
134b 0ee3      ld      c,0e3h
134d ed5bf83d  ld      de,(3df8h)
1351 ed59      out     (c),e			port E3 = ??
1353 d9        exx     				; restore reg     
1354 cf        rst     08h			;jp      0985h ; read_sd_card_sector
1355 82        add     a,d
1356 d9        exx     				; store reg
1357 ed51      out     (c),d			port E3 = ??
1359 d1        pop     de
135a c1        pop     bc
135b d9        exx     				; restore reg
135c c9        ret     

135d cda911    call    11a9h		; indexes
1360 cdc712    call    12c7h
1363 cd5e30    call    305eh
1366 d8        ret     c

1367 62        ld      h,d
1368 6b        ld      l,e
1369 3eff      ld      a,0ffh
136b cde230    call    30e2h
136e d5        push    de
136f ed5b113c  ld      de,(3c11h)
1373 ed4b133c  ld      bc,(3c13h)
1377 c5        push    bc
1378 d5        push    de
1379 cd0a11    call    110ah
137c d1        pop     de
137d c1        pop     bc
137e e1        pop     hl
137f d8        ret     c

1380 cb1c      rr      h
1382 cb1d      rr      l
1384 fd7e1c    ld      a,(iy+1ch)
1387 fe01      cp      01h
1389 200a      jr      nz,1395h
138b cb38      srl     b
138d cb19      rr      c
138f cb1a      rr      d
1391 cb1b      rr      e
1393 cb1d      rr      l
1395 41        ld      b,c
1396 4a        ld      c,d
1397 53        ld      d,e
1398 5d        ld      e,l
1399 b7        or      a
139a c9        ret     

139b 0608      ld      b,08h
139d cde213    call    13e2h
13a0 cdab13    call    13abh
13a3 7e        ld      a,(hl)
13a4 fe2e      cp      2eh
13a6 2001      jr      nz,13a9h
13a8 23        inc     hl
13a9 0603      ld      b,03h
13ab 7e        ld      a,(hl)
13ac 0e20      ld      c,20h
13ae fe2e      cp      2eh
13b0 2829      jr      z,13dbh
13b2 a7        and     a
13b3 2826      jr      z,13dbh
13b5 fe2f      cp      2fh
13b7 2822      jr      z,13dbh
13b9 cdf813    call    13f8h
13bc 3004      jr      nc,13c2h
13be 37        scf     
13bf 3e07      ld      a,07h
13c1 c9        ret     

13c2 fe61      cp      61h
13c4 3806      jr      c,13cch
13c6 fe7b      cp      7bh
13c8 3002      jr      nc,13cch
13ca e6df      and     0dfh
13cc 12        ld      (de),a
13cd 13        inc     de
13ce 23        inc     hl
13cf 10da      djnz    13abh
13d1 7e        ld      a,(hl)
13d2 a7        and     a
13d3 2804      jr      z,13d9h
13d5 fe2f      cp      2fh
13d7 20e5      jr      nz,13beh
13d9 b7        or      a
13da c9        ret     

13db 79        ld      a,c
13dc 12        ld      (de),a
13dd 13        inc     de
13de 10fc      djnz    13dch
13e0 b7        or      a
13e1 c9        ret     

13e2 7e        ld      a,(hl)
13e3 fe2e      cp      2eh
13e5 c0        ret     nz

13e6 01000b    ld      bc,0b00h
13e9 eda0      ldi     
13eb be        cp      (hl)
13ec 2003      jr      nz,13f1h
13ee eda0      ldi     
13f0 05        dec     b
13f1 0e20      ld      c,20h
13f3 cddb13    call    13dbh
13f6 c1        pop     bc
13f7 c9        ret     

13f8 fe21      cp      21h
13fa d8        ret     c

13fb c5        push    bc
13fc e5        push    hl
13fd 210b14    ld      hl,140bh
1400 010c00    ld      bc,000ch
1403 37        scf     
1404 edb1      cpir    
1406 e1        pop     hl
1407 c1        pop     bc
1408 c8        ret     z

1409 3f        ccf     
140a c9        ret     

140b 3f        ccf     
140c 222f3a    ld      (3a2fh),hl
140f 3b        dec     sp
1410 2c        inc     l
1411 3c        inc     a
1412 3e5c      ld      a,5ch
1414 7c        ld      a,h
1415 2e2a      ld      l,2ah
1417 d5        push    de
1418 e5        push    hl
1419 c5        push    bc
141a 060b      ld      b,0bh
141c 1a        ld      a,(de)
141d fe2a      cp      2ah
141f 2807      jr      z,1428h
1421 be        cp      (hl)
1422 2004      jr      nz,1428h
1424 13        inc     de
1425 23        inc     hl
1426 10f4      djnz    141ch
1428 c1        pop     bc
1429 e1        pop     hl
142a d1        pop     de
142b c9        ret     

142c 47        ld      b,a
142d c5        push    bc
142e e5        push    hl
142f cd4211    call    1142h			; index_proc
1432 21223c    ld      hl,3c22h
1435 cd9406    call    0694h		; compare bc:de and [hl:hl]
1438 e1        pop     hl
1439 c1        pop     bc
143a 78        ld      a,b
143b 2802      jr      z,143fh
143d b7        or      a
143e c9        ret     

143f 3e13      ld      a,13h
1441 c9        ret     

1442 47        ld      b,a
1443 c5        push    bc
1444 e5        push    hl
1445 cd4211    call    1142h			; index_proc
1448 fde5      push    iy
144a e1        pop     hl
144b 2e29      ld      l,29h
144d cd9406    call    0694h		; compare bc:de and [hl:hl]
1450 200b      jr      nz,145dh
1452 e1        pop     hl
1453 e5        push    hl
1454 7e        ld      a,(hl)
1455 fe2e      cp      2eh
1457 2004      jr      nz,145dh
1459 2c        inc     l
145a 7e        ld      a,(hl)
145b fe20      cp      20h
145d e1        pop     hl
145e c1        pop     bc
145f 78        ld      a,b
1460 c9        ret     

1461 11002f    ld      de,2f00h
1464 d5        push    de
1465 d9        exx     
1466 cd6911    call    1169h
1469 d9        exx     
146a cd6d33    call    336dh
146d e1        pop     hl
146e b7        or      a
146f c9        ret     

1470 f5        push    af
1471 cd9c11    call    119ch
1474 cded19    call    19edh
1477 cda612    call    12a6h
147a f1        pop     af
147b cd4214    call    1442h
147e 28e1      jr      z,1461h
1480 cd2c14    call    142ch
1483 d8        ret     c

1484 ddcb0196  res     2,(ix+01h)
1488 fd7733    ld      (iy+33h),a
148b fdcb348e  res     1,(iy+34h)
148f 22043c    ld      (3c04h),hl
1492 3e11      ld      a,11h
1494 dd7706    ld      (ix+06h),a
1497 210026    ld      hl,2600h
149a e5        push    hl
149b cdfb11    call    11fbh
149e e1        pop     hl
149f d8        ret     c

14a0 dd3506    dec     (ix+06h)
14a3 2005      jr      nz,14aah
14a5 cd5012    call    1250h
14a8 18e8      jr      1492h
14aa 7e        ld      a,(hl)
14ab a7        and     a
14ac 2857      jr      z,1505h
14ae fee5      cp      0e5h
14b0 2811      jr      z,14c3h
14b2 4d        ld      c,l
14b3 7d        ld      a,l
14b4 c60b      add     a,0bh
14b6 6f        ld      l,a
14b7 7e        ld      a,(hl)
14b8 69        ld      l,c
14b9 fe0f      cp      0fh
14bb 202d      jr      nz,14eah
14bd 012000    ld      bc,0020h
14c0 09        add     hl,bc
14c1 18dd      jr      14a0h
14c3 cdc814    call    14c8h
14c6 18f5      jr      14bdh
14c8 fdcb344e  bit     1,(iy+34h)
14cc c0        ret     nz

14cd fdcb34ce  set     1,(iy+34h)
14d1 dd7e06    ld      a,(ix+06h)
14d4 dd771e    ld      (ix+1eh),a
14d7 dd7e13    ld      a,(ix+13h)
14da dd771f    ld      (ix+1fh),a
14dd cd5c11    call    115ch			; index_proc
14e0 cdd319    call    19d3h
14e3 cd4211    call    1142h			; index_proc
14e6 cdb919    call    19b9h
14e9 c9        ret     

14ea 5f        ld      e,a
14eb fd7e33    ld      a,(iy+33h)
14ee a7        and     a
14ef 2803      jr      z,14f4h
14f1 a3        and     e
14f2 28c9      jr      z,14bdh
14f4 ed5b043c  ld      de,(3c04h)
14f8 cd1714    call    1417h
14fb 20c0      jr      nz,14bdh
14fd dd751c    ld      (ix+1ch),l
1500 dd741d    ld      (ix+1dh),h
1503 b7        or      a
1504 c9        ret     

1505 cdc814    call    14c8h
1508 dd7e1e    ld      a,(ix+1eh)
150b dd7706    ld      (ix+06h),a
150e dd7e1f    ld      a,(ix+1fh)
1511 dd7713    ld      (ix+13h),a
1514 cde019    call    19e0h
1517 cd4f11    call    114fh			; index_proc
151a cdc619    call    19c6h
151d cd3511    call    1135h			; index_proc
1520 3e05      ld      a,05h
1522 37        scf     
1523 c9        ret     

1524 01ffff    ld      bc,0ffffh
1527 ed431f3c  ld      (3c1fh),bc
152b ed43203c  ld      (3c20h),bc
152f 11002c    ld      de,2c00h
1532 d5        push    de
1533 f7        rst     30h			; jr      0091h
1534 05        dec     b
1535 e1        pop     hl
1536 fd7734    ld      (iy+34h),a
1539 1f        rra     
153a 3019      jr      nc,1555h
153c e5        push    hl
153d fde5      push    iy
153f e1        pop     hl
1540 2e80      ld      l,80h
1542 11802c    ld      de,2c80h
1545 d5        push    de
1546 fd7e7f    ld      a,(iy+7fh)
1549 f5        push    af
154a d680      sub     80h
154c 0600      ld      b,00h
154e 4f        ld      c,a
154f edb0      ldir    
1551 f1        pop     af
1552 d1        pop     de
1553 5f        ld      e,a
1554 e1        pop     hl
1555 af        xor     a
1556 dd771d    ld      (ix+1dh),a
1559 7e        ld      a,(hl)
155a a7        and     a
155b ca0916    jp      z,1609h
155e fe2f      cp      2fh
1560 200c      jr      nz,156eh
1562 fdcb3446  bit     0,(iy+34h)
1566 2805      jr      z,156dh
1568 bf        cp      a
1569 1e80      ld      e,80h
156b 12        ld      (de),a
156c 13        inc     de
156d 23        inc     hl
156e ed53ea3d  ld      (3deah),de
1572 cc6911    call    z,1169h
1575 c49c11    call    nz,119ch
1578 22ec3d    ld      (3dech),hl
157b 7e        ld      a,(hl)
157c a7        and     a
157d ca0d16    jp      z,160dh
1580 cded19    call    19edh
1583 cda612    call    12a6h
1586 11063c    ld      de,3c06h
1589 d5        push    de
158a cd9b13    call    139bh
158d d1        pop     de
158e d8        ret     c

158f e5        push    hl
1590 eb        ex      de,hl
1591 af        xor     a
1592 cd7b14    call    147bh
1595 d1        pop     de
1596 da2e16    jp      c,162eh
1599 4d        ld      c,l
159a 7d        ld      a,l
159b c60b      add     a,0bh
159d 6f        ld      l,a
159e cb66      bit     4,(hl)
15a0 69        ld      l,c
15a1 eb        ex      de,hl
15a2 2011      jr      nz,15b5h
15a4 7e        ld      a,(hl)
15a5 a7        and     a
15a6 2804      jr      z,15ach
15a8 3e13      ld      a,13h
15aa 37        scf     
15ab c9        ret     

15ac fd7e34    ld      a,(iy+34h)
15af 17        rla     
15b0 3e11      ld      a,11h
15b2 d8        ret     c

15b3 1860      jr      1615h
15b5 fdcb3446  bit     0,(iy+34h)
15b9 2841      jr      z,15fch
15bb e5        push    hl
15bc 2aec3d    ld      hl,(3dech)
15bf ed5bea3d  ld      de,(3deah)
15c3 7e        ld      a,(hl)
15c4 fe2e      cp      2eh
15c6 280d      jr      z,15d5h
15c8 7e        ld      a,(hl)
15c9 23        inc     hl
15ca a7        and     a
15cb 281b      jr      z,15e8h
15cd fe2f      cp      2fh
15cf 2817      jr      z,15e8h
15d1 12        ld      (de),a
15d2 13        inc     de
15d3 18f3      jr      15c8h
15d5 23        inc     hl
15d6 7e        ld      a,(hl)
15d7 fe2e      cp      2eh
15d9 2011      jr      nz,15ech
15db 1b        dec     de
15dc 1b        dec     de
15dd 1a        ld      a,(de)
15de fe2f      cp      2fh
15e0 2803      jr      z,15e5h
15e2 1b        dec     de
15e3 18f8      jr      15ddh
15e5 13        inc     de
15e6 1804      jr      15ech
15e8 3e2f      ld      a,2fh
15ea 12        ld      (de),a
15eb 13        inc     de
15ec ed53ea3d  ld      (3deah),de
15f0 e1        pop     hl
15f1 7b        ld      a,e
15f2 fe81      cp      81h
15f4 3e15      ld      a,15h
15f6 d8        ret     c

15f7 cc6911    call    z,1169h
15fa 2803      jr      z,15ffh
15fc cd3e16    call    163eh
15ff 7e        ld      a,(hl)
1600 a7        and     a
1601 280a      jr      z,160dh
1603 fe2f      cp      2fh
1605 23        inc     hl
1606 ca7815    jp      z,1578h
1609 37        scf     
160a 3e13      ld      a,13h
160c c9        ret     

160d fd7e34    ld      a,(iy+34h)
1610 17        rla     
1611 3f        ccf     
1612 3e10      ld      a,10h
1614 d8        ret     c

1615 cd1a16    call    161ah
1618 b7        or      a
1619 c9        ret     

161a fdcb3446  bit     0,(iy+34h)
161e c8        ret     z

161f 2aec3d    ld      hl,(3dech)
1622 ed5bea3d  ld      de,(3deah)
1626 7e        ld      a,(hl)
1627 12        ld      (de),a
1628 23        inc     hl
1629 13        inc     de
162a b7        or      a
162b c8        ret     z

162c 18f8      jr      1626h
162e eb        ex      de,hl
162f 7e        ld      a,(hl)
1630 a7        and     a
1631 2804      jr      z,1637h
1633 37        scf     
1634 3e13      ld      a,13h
1636 c9        ret     

1637 cd1a16    call    161ah
163a 37        scf     
163b 3e05      ld      a,05h
163d c9        ret     

163e e5        push    hl
163f dd7e1d    ld      a,(ix+1dh)
1642 a7        and     a
1643 2005      jr      nz,164ah
1645 cd6911    call    1169h
1648 180a      jr      1654h
164a 67        ld      h,a
164b dd7e1c    ld      a,(ix+1ch)
164e c614      add     a,14h
1650 6f        ld      l,a
1651 cd5f16    call    165fh
1654 e1        pop     hl
1655 fd7e1c    ld      a,(iy+1ch)
1658 fe01      cp      01h
165a c8        ret     z

165b 010000    ld      bc,0000h
165e c9        ret     

165f cd6b16    call    166bh
1662 78        ld      a,b
1663 b1        or      c
1664 b2        or      d
1665 b3        or      e
1666 cc6911    call    z,1169h
1669 18ea      jr      1655h
166b 4e        ld      c,(hl)
166c 2c        inc     l
166d 46        ld      b,(hl)
166e 7d        ld      a,l
166f c605      add     a,05h
1671 6f        ld      l,a
1672 5e        ld      e,(hl)
1673 2c        inc     l
1674 56        ld      d,(hl)
1675 2c        inc     l
1676 c9        ret     

1677 eb        ex      de,hl
1678 fde5      push    iy
167a e1        pop     hl
167b 2e80      ld      l,80h
167d f7        rst     30h			; jr      0091h
167e 04        inc     b
167f b7        or      a
1680 c9        ret     

1681 e5        push    hl
1682 ddcb01ee  set     5,(ix+01h)
1686 cdee18    call    18eeh
1689 ddcb01ae  res     5,(ix+01h)
168d e1        pop     hl
168e c9        ret     

168f cd9716    call    1697h
1692 dd360000  ld      (ix+00h),00h
1696 c9        ret     

1697 b7        or      a
1698 ddcb015e  bit     3,(ix+01h)
169c caf310    jp      z,10f3h
169f cdcb16    call    16cbh
16a2 d8        ret     c

16a3 111400    ld      de,0014h
16a6 19        add     hl,de
16a7 cdfa19    call    19fah
16aa 71        ld      (hl),c
16ab 23        inc     hl
16ac 70        ld      (hl),b
16ad 23        inc     hl
16ae 23        inc     hl
16af 23        inc     hl
16b0 23        inc     hl
16b1 23        inc     hl
16b2 73        ld      (hl),e
16b3 23        inc     hl
16b4 72        ld      (hl),d
16b5 23        inc     hl
16b6 cde019    call    19e0h
16b9 f7        rst     30h			; jr      0091h
16ba 00        nop     
16bb cde717    call    17e7h
16be f5        push    af
16bf 211b3c    ld      hl,3c1bh
16c2 f7        rst     30h			; jr      0091h
16c3 01cd4f    ld      bc,4fcdh
16c6 11f1c3    ld      de,0c3f1h
16c9 f3        di      
16ca 10cd      djnz    1699h
16cc 5c        ld      e,h
16cd 11211b    ld      de,1b21h
16d0 3c        inc     a
16d1 f7        rst     30h			; jr      0091h
16d2 00        nop     
16d3 cd141a    call    1a14h
16d6 cd4f11    call    114fh			; index_proc
16d9 cdf417    call    17f4h
16dc eb        ex      de,hl
16dd c9        ret     

16de 78        ld      a,b
16df 32013c    ld      (3c01h),a
16e2 ed53233c  ld      (3c23h),de
16e6 3e01      ld      a,01h
16e8 cd2415    call    1524h
16eb 3010      jr      nc,16fdh
16ed fe05      cp      05h
16ef 37        scf     
16f0 c0        ret     nz

16f1 3a013c    ld      a,(3c01h)
16f4 e60c      and     0ch
16f6 37        scf     
16f7 3e05      ld      a,05h
16f9 c8        ret     z

16fa c31217    jp      1712h
16fd 3a013c    ld      a,(3c01h)
1700 e60c      and     0ch
1702 fe04      cp      04h
1704 2004      jr      nz,170ah
1706 37        scf     
1707 3e12      ld      a,12h
1709 c9        ret     

170a fe0c      cp      0ch
170c ca1518    jp      z,1815h
170f c34a18    jp      184ah
1712 cd3413    call    1334h
1715 d8        ret     c

1716 cdf417    call    17f4h
1719 d8        ret     c

171a 1a        ld      a,(de)
171b f5        push    af
171c cda017    call    17a0h
171f d1        pop     de
1720 d8        ret     c

1721 7a        ld      a,d
1722 fee5      cp      0e5h
1724 2804      jr      z,172ah
1726 cd7a17    call    177ah
1729 d8        ret     c

172a 211b3c    ld      hl,3c1bh
172d f7        rst     30h			; jr      0091h
172e 01cd07    ld      bc,07cdh
1731 1a        ld      a,(de)
1732 cddb17    call    17dbh
1735 cdb919    call    19b9h
1738 3a013c    ld      a,(3c01h)
173b f5        push    af
173c e603      and     03h
173e f602      or      02h
1740 dd7701    ld      (ix+01h),a
1743 f1        pop     af
1744 b7        or      a
1745 cb77      bit     6,a
1747 281e      jr      z,1767h
1749 cdca34    call    34cah
174c cd9231    call    3192h
174f d8        ret     c

1750 21002d    ld      hl,2d00h
1753 cd3c31    call    313ch
1756 d8        ret     c

1757 ddcb01de  set     3,(ix+01h)
175b 3e80      ld      a,80h
175d dd770b    ld      (ix+0bh),a
1760 dd770f    ld      (ix+0fh),a
1763 cd9716    call    1697h
1766 d8        ret     c

1767 cd7317    call    1773h
176a 21802c    ld      hl,2c80h
176d 3af93d    ld      a,(3df9h)
1770 47        ld      b,a
1771 b7        or      a
1772 c9        ret     

1773 fd7e00    ld      a,(iy+00h)
1776 dd7700    ld      (ix+00h),a
1779 c9        ret     

177a 7c        ld      a,h
177b e601      and     01h
177d 85        add     a,l
177e 011f00    ld      bc,001fh
1781 2011      jr      nz,1794h
1783 ddcb01d6  set     2,(ix+01h)
1787 cd5012    call    1250h
178a ddcb0196  res     2,(ix+01h)
178e 210026    ld      hl,2600h
1791 01ff01    ld      bc,01ffh
1794 7e        ld      a,(hl)
1795 54        ld      d,h
1796 5d        ld      e,l
1797 13        inc     de
1798 3600      ld      (hl),00h
179a edb0      ldir    
179c cde717    call    17e7h
179f c9        ret     

17a0 21063c    ld      hl,3c06h
17a3 010b00    ld      bc,000bh
17a6 edb0      ldir    
17a8 af        xor     a
17a9 12        ld      (de),a
17aa eb        ex      de,hl
17ab 23        inc     hl
17ac 77        ld      (hl),a
17ad 23        inc     hl
17ae 77        ld      (hl),a
17af 23        inc     hl
17b0 cf        rst     08h			;jp      0985h ; read_sd_card_sector
17b1 8e        adc     a,(hl)
17b2 f7        rst     30h			; jr      0091h
17b3 00        nop     
17b4 af        xor     a
17b5 77        ld      (hl),a
17b6 2c        inc     l
17b7 77        ld      (hl),a
17b8 2c        inc     l
17b9 77        ld      (hl),a
17ba 2c        inc     l
17bb 77        ld      (hl),a
17bc 2c        inc     l
17bd f7        rst     30h			; jr      0091h
17be 00        nop     
17bf 77        ld      (hl),a
17c0 2c        inc     l
17c1 77        ld      (hl),a
17c2 2c        inc     l
17c3 47        ld      b,a
17c4 48        ld      c,b
17c5 51        ld      d,c
17c6 5a        ld      e,d
17c7 f7        rst     30h			; jr      0091h
17c8 00        nop     
17c9 e5        push    hl
17ca cde717    call    17e7h
17cd e1        pop     hl
17ce d8        ret     c

17cf e5        push    hl
17d0 cd5c11    call    115ch			; index_proc
17d3 211b3c    ld      hl,3c1bh
17d6 f7        rst     30h			; jr      0091h
17d7 00        nop     
17d8 e1        pop     hl
17d9 b7        or      a
17da c9        ret     

17db 0600      ld      b,00h
17dd 48        ld      c,b
17de 51        ld      d,c
17df 5a        ld      e,d
17e0 cd3511    call    1135h			; index_proc
17e3 cdd319    call    19d3h
17e6 c9        ret     

17e7 210026    ld      hl,2600h
17ea cd3c31    call    313ch
17ed f5        push    af
17ee af        xor     a
17ef 32263c    ld      (3c26h),a
17f2 f1        pop     af
17f3 c9        ret     

17f4 210026    ld      hl,2600h
17f7 e5        push    hl
17f8 cdfb11    call    11fbh
17fb e1        pop     hl
17fc d8        ret     c

17fd 3e10      ld      a,10h
17ff dd9606    sub     (ix+06h)
1802 cb27      sla     a
1804 cb27      sla     a
1806 cb27      sla     a
1808 cb27      sla     a
180a cb27      sla     a
180c 5f        ld      e,a
180d 1600      ld      d,00h
180f cb12      rl      d
1811 19        add     hl,de
1812 eb        ex      de,hl
1813 b7        or      a
1814 c9        ret     

1815 cd3e16    call    163eh
1818 c5        push    bc
1819 d5        push    de
181a dd6e1c    ld      l,(ix+1ch)
181d dd661d    ld      h,(ix+1dh)
1820 110c00    ld      de,000ch
1823 19        add     hl,de
1824 cdac17    call    17ach
1827 d1        pop     de
1828 c1        pop     bc
1829 d8        ret     c

182a cd0831    call    3108h
182d d4f310    call    nc,10f3h
1830 d8        ret     c

1831 cddb17    call    17dbh
1834 cdb919    call    19b9h
1837 cd7317    call    1773h
183a 217c1a    ld      hl,1a7ch
183d 22ee3d    ld      (3deeh),hl
1840 cd211a    call    1a21h
1843 dd360000  ld      (ix+00h),00h
1847 c32a17    jp      172ah
184a 3a013c    ld      a,(3c01h)
184d f5        push    af
184e e603      and     03h
1850 dd7701    ld      (ix+01h),a
1853 cd5c11    call    115ch			; index_proc
1856 cd071a    call    1a07h
1859 cd3e16    call    163eh
185c cdd018    call    18d0h
185f dd6e1c    ld      l,(ix+1ch)
1862 dd661d    ld      h,(ix+1dh)
1865 111c00    ld      de,001ch
1868 19        add     hl,de
1869 cd9718    call    1897h
186c f1        pop     af
186d cb77      bit     6,a
186f 2823      jr      z,1894h
1871 21002d    ld      hl,2d00h
1874 018000    ld      bc,0080h
1877 cd8116    call    1681h
187a d8        ret     c

187b cdb318    call    18b3h
187e 2e0f      ld      l,0fh
1880 2809      jr      z,188bh
1882 dd360f00  ld      (ix+0fh),00h
1886 e5        push    hl
1887 cd9e18    call    189eh
188a e1        pop     hl
188b ed5b233c  ld      de,(3c23h)
188f 010800    ld      bc,0008h
1892 f7        rst     30h			; jr      0091h
1893 06c3      ld      b,0c3h
1895 67        ld      h,a
1896 17        rla     
1897 f7        rst     30h			; jr      0091h
1898 01cdd3    ld      bc,0d3cdh
189b 19        add     hl,de
189c b7        or      a
189d c9        ret     

189e f5        push    af
189f 3eff      ld      a,0ffh
18a1 77        ld      (hl),a
18a2 2c        inc     l
18a3 cde019    call    19e0h
18a6 73        ld      (hl),e
18a7 2c        inc     l
18a8 72        ld      (hl),d
18a9 2c        inc     l
18aa 0605      ld      b,05h
18ac af        xor     a
18ad 77        ld      (hl),a
18ae 2c        inc     l
18af 10fc      djnz    18adh
18b1 f1        pop     af
18b2 c9        ret     

18b3 e5        push    hl
18b4 114000    ld      de,0040h
18b7 010900    ld      bc,0009h
18ba 1a        ld      a,(de)
18bb eda1      cpi     
18bd 2004      jr      nz,18c3h
18bf 13        inc     de
18c0 eaba18    jp      pe,18bah
18c3 e1        pop     hl
18c4 c0        ret     nz

18c5 0e7f      ld      c,7fh
18c7 af        xor     a
18c8 86        add     a,(hl)
18c9 eda1      cpi     
18cb eac818    jp      pe,18c8h
18ce be        cp      (hl)
18cf c9        ret     

18d0 cded19    call    19edh
18d3 cda612    call    12a6h
18d6 0600      ld      b,00h
18d8 48        ld      c,b
18d9 51        ld      d,c
18da 5a        ld      e,d
18db c3b919    jp      19b9h
18de ddcb0146  bit     0,(ix+01h)
18e2 3e08      ld      a,08h
18e4 37        scf     
18e5 c8        ret     z

18e6 e5        push    hl
18e7 cd8919    call    1989h
18ea e1        pop     hl
18eb 78        ld      a,b
18ec b1        or      c
18ed c8        ret     z

18ee ddcb0196  res     2,(ix+01h)
18f2 c5        push    bc
18f3 dd5e0f    ld      e,(ix+0fh)
18f6 dd7e10    ld      a,(ix+10h)
18f9 e601      and     01h
18fb 57        ld      d,a
18fc cd3419    call    1934h
18ff 3828      jr      c,1929h
1901 c5        push    bc
1902 e5        push    hl
1903 210002    ld      hl,0200h
1906 ed52      sbc     hl,de
1908 eb        ex      de,hl
1909 60        ld      h,b
190a 69        ld      l,c
190b ed52      sbc     hl,de
190d 3802      jr      c,1911h
190f 42        ld      b,d
1910 4b        ld      c,e
1911 e1        pop     hl
1912 c5        push    bc
1913 cd4519    call    1945h
1916 d1        pop     de
1917 c1        pop     bc
1918 380f      jr      c,1929h
191a 79        ld      a,c
191b 93        sub     e
191c 4f        ld      c,a
191d 78        ld      a,b
191e 9a        sbc     a,d
191f 47        ld      b,a
1920 b1        or      c
1921 eb        ex      de,hl
1922 cdab19    call    19abh
1925 eb        ex      de,hl
1926 20cb      jr      nz,18f3h
1928 b7        or      a
1929 d1        pop     de
192a f5        push    af
192b eb        ex      de,hl
192c b7        or      a
192d ed42      sbc     hl,bc
192f 44        ld      b,h
1930 4d        ld      c,l
1931 eb        ex      de,hl
1932 f1        pop     af
1933 c9        ret     

1934 b3        or      e
1935 c0        ret     nz

1936 d5        push    de
1937 c5        push    bc
1938 e5        push    hl
1939 cdc619    call    19c6h
193c f7        rst     30h			; jr      0091h
193d 0d        dec     c
193e c45012    call    nz,1250h
1941 e1        pop     hl
1942 c1        pop     bc
1943 d1        pop     de
1944 c9        ret     

1945 78        ld      a,b
1946 d602      sub     02h
1948 b1        or      c
1949 2011      jr      nz,195ch
194b ddcb0156  bit     2,(ix+01h)
194f c24213    jp      nz,1342h
1952 ddcb016e  bit     5,(ix+01h)
1956 c2fb11    jp      nz,11fbh
1959 c33512    jp      1235h
195c c5        push    bc
195d e5        push    hl
195e cd0212    call    1202h
1961 d1        pop     de
1962 c1        pop     bc
1963 d8        ret     c

1964 dd6e0f    ld      l,(ix+0fh)
1967 dd7e10    ld      a,(ix+10h)
196a e601      and     01h
196c 84        add     a,h
196d 67        ld      h,a
196e ddcb0156  bit     2,(ix+01h)
1972 200f      jr      nz,1983h
1974 ddcb016e  bit     5,(ix+01h)
1978 2805      jr      z,197fh
197a edb0      ldir    
197c eb        ex      de,hl
197d b7        or      a
197e c9        ret     

197f f7        rst     30h			; jr      0091h
1980 06eb      ld      b,0ebh
1982 c9        ret     

1983 eb        ex      de,hl
1984 f7        rst     30h			; jr      0091h
1985 07        rlca    
1986 c32c12    jp      122ch
1989 c5        push    bc
198a cdc619    call    19c6h
198d dd660c    ld      h,(ix+0ch)
1990 dd6e0b    ld      l,(ix+0bh)
1993 b7        or      a
1994 ed52      sbc     hl,de
1996 eb        ex      de,hl
1997 dd660e    ld      h,(ix+0eh)
199a dd6e0d    ld      l,(ix+0dh)
199d ed42      sbc     hl,bc
199f c1        pop     bc
19a0 7c        ld      a,h
19a1 b5        or      l
19a2 c0        ret     nz

19a3 62        ld      h,d
19a4 6b        ld      l,e
19a5 ed42      sbc     hl,bc
19a7 d0        ret     nc

19a8 42        ld      b,d
19a9 4b        ld      c,e
19aa c9        ret     

19ab d5        push    de
19ac c5        push    bc
19ad cdc619    call    19c6h
19b0 cd3108    call    0831h
19b3 cdb919    call    19b9h
19b6 c1        pop     bc
19b7 d1        pop     de
19b8 c9        ret     

19b9 dd730f    ld      (ix+0fh),e
19bc dd7210    ld      (ix+10h),d
19bf dd7111    ld      (ix+11h),c
19c2 dd7012    ld      (ix+12h),b
19c5 c9        ret     

19c6 dd5e0f    ld      e,(ix+0fh)
19c9 dd5610    ld      d,(ix+10h)
19cc dd4e11    ld      c,(ix+11h)
19cf dd4612    ld      b,(ix+12h)
19d2 c9        ret     

19d3 dd730b    ld      (ix+0bh),e
19d6 dd720c    ld      (ix+0ch),d
19d9 dd710d    ld      (ix+0dh),c
19dc dd700e    ld      (ix+0eh),b
19df c9        ret     

19e0 dd5e0b    ld      e,(ix+0bh)
19e3 dd560c    ld      d,(ix+0ch)
19e6 dd4e0d    ld      c,(ix+0dh)
19e9 dd460e    ld      b,(ix+0eh)
19ec c9        ret     

19ed dd7307    ld      (ix+07h),e
19f0 dd7208    ld      (ix+08h),d
19f3 dd7109    ld      (ix+09h),c
19f6 dd700a    ld      (ix+0ah),b
19f9 c9        ret     

19fa dd5e07    ld      e,(ix+07h)
19fd dd5608    ld      d,(ix+08h)
1a00 dd4e09    ld      c,(ix+09h)
1a03 dd460a    ld      b,(ix+0ah)
1a06 c9        ret     

1a07 dd7302    ld      (ix+02h),e
1a0a dd7203    ld      (ix+03h),d
1a0d dd7104    ld      (ix+04h),c
1a10 dd7005    ld      (ix+05h),b
1a13 c9        ret     

1a14 dd5e02    ld      e,(ix+02h)
1a17 dd5603    ld      d,(ix+03h)
1a1a dd4e04    ld      c,(ix+04h)
1a1d dd4605    ld      b,(ix+05h)
1a20 c9        ret     

1a21 c5        push    bc
1a22 d5        push    de
1a23 212024    ld      hl,2420h
1a26 060f      ld      b,0fh
1a28 7e        ld      a,(hl)
1a29 a7        and     a
1a2a 280d      jr      z,1a39h
1a2c dd7c      ld      a,ixh
1a2e bc        cp      h
1a2f 2005      jr      nz,1a36h
1a31 dd7d      ld      a,ixl
1a33 bd        cp      l
1a34 2803      jr      z,1a39h
1a36 cd431a    call    1a43h
1a39 112000    ld      de,0020h
1a3c 19        add     hl,de
1a3d 10e9      djnz    1a28h
1a3f d1        pop     de
1a40 c1        pop     bc
1a41 b7        or      a
1a42 c9        ret     

1a43 7e        ld      a,(hl)
1a44 ddbe00    cp      (ix+00h)
1a47 c0        ret     nz

1a48 e5        push    hl
1a49 3e06      ld      a,06h
1a4b 85        add     a,l
1a4c 6f        ld      l,a
1a4d 7e        ld      a,(hl)
1a4e ddbe06    cp      (ix+06h)
1a51 e1        pop     hl
1a52 c0        ret     nz

1a53 c5        push    bc
1a54 e5        push    hl
1a55 3e05      ld      a,05h
1a57 85        add     a,l
1a58 6f        ld      l,a
1a59 cd141a    call    1a14h
1a5c cd9406    call    0694h		; compare bc:de and [hl:hl]
1a5f cc2800    call    z,0028h
1a62 e1        pop     hl
1a63 c1        pop     bc
1a64 c9        ret     

1a65 e1        pop     hl
1a66 e1        pop     hl
1a67 e1        pop     hl
1a68 e1        pop     hl
1a69 d1        pop     de
1a6a c1        pop     bc
1a6b 37        scf     			; set the carry flag
1a6c c9        ret     

1a6d 2d        dec     l
1a6e 2d        dec     l
1a6f 2d        dec     l
1a70 cba6      res     4,(hl)
1a72 3e0a      ld      a,0ah
1a74 85        add     a,l
1a75 6f        ld      l,a
1a76 cde019    call    19e0h
1a79 c3a906    jp      06a9h
1a7c 2d        dec     l
1a7d 2d        dec     l
1a7e 2d        dec     l
1a7f cbe6      set     4,(hl)
1a81 cb9e      res     3,(hl)
1a83 3e06      ld      a,06h
1a85 85        add     a,l
1a86 6f        ld      l,a
1a87 eb        ex      de,hl
1a88 dde5      push    ix
1a8a e1        pop     hl
1a8b 3e07      ld      a,07h
1a8d 85        add     a,l
1a8e 6f        ld      l,a
1a8f 011500    ld      bc,0015h
1a92 edb0      ldir    
1a94 c9        ret     

1a95 15        dec     d
1a96 25        dec     h
1a97 c9        ret     

1a98 1a        ld      a,(de)
1a99 a3        and     e
1a9a 1a        ld      a,(de)
1a9b a1        and     c
1a9c 1a        ld      a,(de)
1a9d 00        nop     
1a9e 00        nop     
1a9f 0f        rrca    
1aa0 25        dec     h
1aa1 b7        or      a
1aa2 c9        ret     

1aa3 cd131b    call    1b13h
1aa6 dd7d      ld      a,ixl
1aa8 d3e3      out     (0e3h),a			port E3 = param
1aaa 3af83d    ld      a,(3df8h)
1aad dd67      ld      ixh,a
1aaf af        xor     a
1ab0 d3e3      out     (0e3h),a			port E3 = 00
1ab2 cdf41a    call    1af4h
1ab5 d8        ret     c

1ab6 fd5e08    ld      e,(iy+08h)
1ab9 dd7d      ld      a,ixl
1abb d3e3      out     (0e3h),a			port E3 = param
1abd 7b        ld      a,e
1abe d5        push    de
1abf cf        rst     08h			;jp      0985h ; read_sd_card_sector
1ac0 9e        sbc     a,(hl)
1ac1 d1        pop     de
1ac2 f5        push    af
1ac3 7b        ld      a,e
1ac4 cf        rst     08h			;jp      0985h ; read_sd_card_sector
1ac5 9c        sbc     a,h
1ac6 f1        pop     af
1ac7 181d      jr      1ae6h
1ac9 cd131b    call    1b13h
1acc dd7d      ld      a,ixl
1ace d3e3      out     (0e3h),a			port E3 = ??
1ad0 3af83d    ld      a,(3df8h)
1ad3 dd67      ld      ixh,a
1ad5 af        xor     a
1ad6 d3e3      out     (0e3h),a			port E3 = 00
1ad8 cdf41a    call    1af4h
1adb d8        ret     c

1adc fd5e08    ld      e,(iy+08h)
1adf dd7d      ld      a,ixl
1ae1 d3e3      out     (0e3h),a			port E3 = ??
1ae3 7b        ld      a,e
1ae4 cf        rst     08h			;jp      0985h ; read_sd_card_sector
1ae5 9d        sbc     a,l
1ae6 fd6f      ld      iyl,a
1ae8 dd7c      ld      a,ixh
1aea 32f83d    ld      (3df8h),a
1aed 3e00      ld      a,00h
1aef d3e3      out     (0e3h),a			port E3 = 00
1af1 fd7d      ld      a,iyl
1af3 c9        ret     

1af4 fd7e08    ld      a,(iy+08h)
1af7 e5        push    hl
1af8 2e00      ld      l,00h
1afa cf        rst     08h			;jp      0985h ; read_sd_card_sector
1afb 9f        sbc     a,a
1afc e1        pop     hl
1afd d8        ret     c

1afe e5        push    hl
1aff 218000    ld      hl,0080h
1b02 fd7e01    ld      a,(iy+01h)
1b05 e607      and     07h
1b07 3d        dec     a
1b08 2804      jr      z,1b0eh
1b0a 29        add     hl,hl
1b0b 3d        dec     a
1b0c 20fc      jr      nz,1b0ah
1b0e 44        ld      b,h
1b0f 4d        ld      c,l
1b10 e1        pop     hl
1b11 b7        or      a
1b12 c9        ret     

1b13 cd291b    call    1b29h
1b16 fd7e01    ld      a,(iy+01h)
1b19 e607      and     07h
1b1b 3d        dec     a
1b1c c8        ret     z

1b1d cb23      sla     e
1b1f cb12      rl      d
1b21 cb11      rl      c
1b23 cb10      rl      b
1b25 3d        dec     a
1b26 20f5      jr      nz,1b1dh
1b28 c9        ret     

1b29 3e07      ld      a,07h
1b2b cb23      sla     e
1b2d cb12      rl      d
1b2f cb11      rl      c
1b31 cb10      rl      b
1b33 3d        dec     a
1b34 20f5      jr      nz,1b2bh
1b36 c9        ret     

1b37 a4        and     h
1b38 03        inc     bc
1b39 c0        ret     nz

1b3a a2        and     d
1b3b 30ab      jr      nc,1ae8h
1b3d 1f        rra     
1b3e e1        pop     hl
1b3f c0        ret     nz

1b40 a1        and     c
1b41 78        ld      a,b
1b42 a9        xor     c
1b43 03        inc     bc
1b44 e0        ret     po

1b45 7f        ld      a,a
1b46 e0        ret     po

1b47 78        ld      a,b
1b48 a1        and     c
1b49 7e        ld      a,(hl)
1b4a a9        xor     c
1b4b 1f        rra     
1b4c f8        ret     m

1b4d e0        ret     po

1b4e c0        ret     nz

1b4f 1ea1      ld      e,0a1h
1b51 ef        rst     28h
1b52 c0        ret     nz

1b53 a3        and     e
1b54 3f        ccf     
1b55 c0        ret     nz

1b56 a3        and     e
1b57 78        ld      a,b
1b58 fd80      add     a,b
1b5a 01ffc1    ld      bc,0c1ffh
1b5d cdf0a1    call    0a1f0h
1b60 07        rlca    
1b61 80        add     a,b
1b62 f1        pop     af
1b63 e0        ret     po

1b64 a3        and     e
1b65 e0        ret     po

1b66 3d        dec     a
1b67 c0        ret     nz

1b68 3f        ccf     
1b69 fef1      cp      0f1h
1b6b 8c        adc     a,h
1b6c 7e        ld      a,(hl)
1b6d a1        and     c
1b6e 1f        rra     
1b6f e1        pop     hl
1b70 c0        ret     nz

1b71 c3f0a1    jp      0a1f0h
1b74 01c01f    ld      bc,1fc0h
1b77 ff        rst     38h
1b78 fe1e      cp      1eh
1b7a 3b        dec     sp
1b7b 060f      ld      b,0fh
1b7d c0        ret     nz

1b7e 3871      jr      c,1bf1h
1b80 c0        ret     nz

1b81 1f        rra     
1b82 fca103    call    m,03a1h
1b85 80        add     a,b
1b86 1f        rra     
1b87 3f        ccf     
1b88 80        add     a,b
1b89 1c        inc     e
1b8a 0e06      ld      c,06h
1b8c 01f030    ld      bc,30f0h
1b8f 39        add     hl,sp
1b90 ff        rst     38h
1b91 f8        ret     m

1b92 1ea1      ld      e,0a1h
1b94 f3        di      
1b95 80        add     a,b
1b96 0f        rrca    
1b97 a2        and     d
1b98 3c        inc     a
1b99 0f        rrca    
1b9a 87        add     a,a
1b9b a1        and     c
1b9c 78        ld      a,b
1b9d 70        ld      (hl),b
1b9e 1c        inc     e
1b9f 7f        ld      a,a
1ba0 80        add     a,b
1ba1 0e07      ld      c,07h
1ba3 ff        rst     38h
1ba4 80        add     a,b
1ba5 0f        rrca    
1ba6 78        ld      a,b
1ba7 a1        and     c
1ba8 381b      jr      c,1bc5h
1baa c3a11e    jp      1ea1h
1bad 70        ld      (hl),b
1bae 0c        inc     c
1baf a2        and     d
1bb0 0e1c      ld      c,1ch
1bb2 1f        rra     
1bb3 c0        ret     nz

1bb4 3efc      ld      a,0fch
1bb6 08        ex      af,af'
1bb7 70        ld      (hl),b
1bb8 30e3      jr      nc,1b9dh
1bba a1        and     c
1bbb 07        rlca    
1bbc f0        ret     p

1bbd 0e18      ld      c,18h
1bbf a1        and     c
1bc0 1c        inc     e
1bc1 300f      jr      nc,1bd2h
1bc3 ff        rst     38h
1bc4 f8        ret     m

1bc5 fc10e0    call    m,0e010h
1bc8 e0        ret     po

1bc9 71        ld      (hl),c
1bca 80        add     a,b
1bcb 01f806    ld      bc,06f8h
1bce 3c        inc     a
1bcf a1        and     c
1bd0 1c        inc     e
1bd1 60        ld      h,b
1bd2 0eff      ld      c,0ffh
1bd4 c0        ret     nz

1bd5 f8        ret     m

1bd6 11c3c0    ld      de,0c0c3h
1bd9 19        add     hl,de
1bda 80        add     a,b
1bdb a1        and     c
1bdc 78        ld      a,b
1bdd 067c      ld      b,7ch
1bdf a1        and     c
1be0 38e0      jr      c,1bc2h
1be2 0ea1      ld      c,0a1h
1be4 01f033    ld      bc,33f0h
1be7 0f        rrca    
1be8 a1        and     c
1be9 0c        inc     c
1bea c0        ret     nz

1beb a1        and     c
1bec 3c        inc     a
1bed 0678      ld      b,78h
1bef a1        and     c
1bf0 70        ld      (hl),b
1bf1 e0        ret     po

1bf2 2601      ld      h,01h
1bf4 01e03e    ld      bc,3ee0h
1bf7 7c        ld      a,h
1bf8 a1        and     c
1bf9 06c0      ld      b,0c0h
1bfb a1        and     c
1bfc 3c        inc     a
1bfd 06f0      ld      b,0f0h
1bff a1        and     c
1c00 e0        ret     po

1c01 f0        ret     p

1c02 c7        rst     00h
1c03 0601      ld      b,01h
1c05 c0        ret     nz

1c06 1f        rra     
1c07 e0        ret     po

1c08 a1        and     c
1c09 02        ld      (bc),a
1c0a 40        ld      b,b
1c0b a1        and     c
1c0c 7f        ld      a,a
1c0d 0f        rrca    
1c0e f0        ret     p

1c0f 01c0ff    ld      bc,0ffc0h
1c12 83        add     a,e
1c13 fc03c0    call    m,0c003h
1c16 1c        inc     e
1c17 a2        and     d
1c18 03        inc     bc
1c19 21ffff    ld      hl,0ffffh
1c1c ff        rst     38h
1c1d e0        ret     po

1c1e 03        inc     bc
1c1f 80        add     a,b
1c20 7e        ld      a,(hl)
1c21 a1        and     c
1c22 f0        ret     p

1c23 03        inc     bc
1c24 80        add     a,b
1c25 30a2      jr      nc,1bc9h
1c27 0123ff    ld      bc,0ff23h
1c2a f9        ld      sp,hl
1c2b fde0      ret     po

1c2d 07        rlca    
1c2e a4        and     h
1c2f 03        inc     bc
1c30 80        add     a,b
1c31 f0        ret     p

1c32 a3        and     e
1c33 93        sub     e
1c34 ff        rst     38h
1c35 e0        ret     po

1c36 79        ld      a,c
1c37 e0        ret     po

1c38 0ea4      ld      c,0a4h
1c3a 03        inc     bc
1c3b c7        rst     00h
1c3c c0        ret     nz

1c3d a3        and     e
1c3e 01fea1    ld      bc,0a1feh
1c41 01c03c    ld      bc,3cc0h
1c44 a4        and     h
1c45 01ffa7    ld      bc,0a7ffh
1c48 01c0f8    ld      bc,0f8c0h
1c4b a5        and     l
1c4c 7c        ld      a,h
1c4d a7        and     a
1c4e 01e7e0    ld      bc,0e0e7h
1c51 ae        xor     (hl)
1c52 ff        rst     38h
1c53 80        add     a,b
1c54 ae        xor     (hl)
1c55 3c        inc     a
1c56 a2        and     d
1c57 a0        and     b
1c58 45        ld      b,l
1c59 53        ld      d,e
1c5a 58        ld      e,b
1c5b 44        ld      b,h
1c5c 4f        ld      c,a
1c5d 53        ld      d,e
1c5e 00        nop     
1c5f 6d        ld      l,l
1c60 1c        inc     e
1c61 51        ld      d,c
1c62 1eea      ld      e,0eah
1c64 1d        dec     e
1c65 6b        ld      l,e
1c66 1c        inc     e
1c67 00        nop     
1c68 00        nop     
1c69 6b        ld      l,e
1c6a 1c        inc     e
1c6b b7        or      a
1c6c c9        ret     

1c6d 6f        ld      l,a
1c6e e6e0      and     0e0h
1c70 fe80      cp      80h
1c72 37        scf     
1c73 c0        ret     nz

1c74 7d        ld      a,l
1c75 cd8b1c    call    1c8bh
1c78 d8        ret     c

1c79 cd041f    call    1f04h
1c7c fd7e00    ld      a,(iy+00h)
1c7f c9        ret     

1c80 e608      and     08h		; a & x08
1c82 3ef6      ld      a,0f6h		; a = xF6
1c84 2801      jr      z,1c87h		; jmp if (a & x08) == 0
1c86 3d        dec     a
1c87 32fe3d    ld      (3dfeh),a
1c8a c9        ret     

1c8b ed53f23d  ld      (3df2h),de
1c8f 32fa3d    ld      (3dfah),a
1c92 cd801c    call    1c80h		; check for (a & 0x08), [3dfeh] = a;
1c95 cd401d    call    1d40h
1c98 d8        ret     c

1c99 cd001d    call    1d00h
1c9c d8        ret     c

1c9d 21003e    ld      hl,3e00h
1ca0 3e49      ld      a,49h
1ca2 cd2f1d    call    1d2fh
1ca5 d8        ret     c

1ca6 21203e    ld      hl,3e20h
1ca9 3e4a      ld      a,4ah
1cab cd2f1d    call    1d2fh
1cae d8        ret     c

1caf 3afa3d    ld      a,(3dfah)
1cb2 cd8a1e    call    1e8ah
1cb5 3e7a      ld      a,7ah
1cb7 110000    ld      de,0000h
1cba cd811d    call    1d81h
1cbd d8        ret     c

1cbe 78        ld      a,b
1cbf e640      and     40h
1cc1 f603      or      03h
1cc3 fd7701    ld      (iy+01h),a
1cc6 e640      and     40h
1cc8 ccf71c    call    z,1cf7h			; SD_Read_Block
1ccb 21053e    ld      hl,3e05h
1cce cda31e    call    1ea3h
1cd1 fde5      push    iy
1cd3 e1        pop     hl
1cd4 23        inc     hl
1cd5 23        inc     hl
1cd6 23        inc     hl
1cd7 23        inc     hl
1cd8 f7        rst     30h			; jr      0091h
1cd9 00        nop     
1cda 21213e    ld      hl,3e21h
1cdd 11203e    ld      de,3e20h
1ce0 d5        push    de
1ce1 eda0      ldi     
1ce3 eda0      ldi     
1ce5 3e20      ld      a,20h
1ce7 12        ld      (de),a
1ce8 e1        pop     hl
1ce9 ed5bf23d  ld      de,(3df2h)
1ced 010800    ld      bc,0008h
1cf0 f7        rst     30h			; jr      0091h
1cf1 06fd      ld      b,0fdh
1cf3 7e        ld      a,(hl)
1cf4 00        nop     
1cf5 b7        or      a
1cf6 c9        ret     

SD_Read_Block:
1cf7 3e50      ld      a,50h		; CMD_SET_BLOCKLEN
1cf9 110002    ld      de,0200h
1cfc 43        ld      b,e
1cfd 4b        ld      c,e
1cfe 186c      jr      1d6ch		; read_spi_block
1d00 3e48      ld      a,48h
1d02 11aa01    ld      de,01aah
1d05 cd811d    call    1d81h
1d08 21651d    ld      hl,1d65h
1d0b 3803      jr      c,1d10h
1d0d 21201d    ld      hl,1d20h		; SD_init
1d10 017800    ld      bc,0078h
1d13 c5        push    bc
1d14 cd2e1d    call    1d2eh
1d17 c1        pop     bc
1d18 d0        ret     nc

1d19 10f8      djnz    1d13h
1d1b 0d        dec     c
1d1c 20f5      jr      nz,1d13h
1d1e 37        scf     
1d1f c9        ret     

SD_INIT:
1d20 3e77      ld      a,77h		; init command
1d22 cd671d    call    1d67h		; Write_Command_SD(CMD);
1d25 3e69      ld      a,69h		; init command
1d27 010040    ld      bc,4000h
1d2a 51        ld      d,c
1d2b 59        ld      e,c
1d2c 183e      jr      1d6ch		; read_spi_block
1d2e e9        jp      (hl)
1d2f cd671d    call    1d67h		; Write_Command_SD(CMD);
1d32 d8        ret     c

1d33 cdc41d    call    1dc4h
1d36 d8        ret     c

1d37 0612      ld      b,12h		; b - read len, 18 bytes
1d39 0eeb      ld      c,0ebh		; port
1d3b edb2      inir    			; hl - buffer
1d3d b7        or      a
1d3e 181e      jr      1d5eh		;port E7 = FF; SD control, set_SD_CS
1d40 cd5e1d    call    1d5eh		;port E7 = FF; SD control, set_SD_CS
1d43 060a      ld      b,0ah		; loop counter
1d45 3eff      ld      a,0ffh
1d47 d3eb      out     (0ebh),a		; send 10 xFF to SPIdata
1d49 10fa      djnz    1d45h		; loop
1d4b cde01d    call    1de0h		; read_SPI_data
1d4e 0608      ld      b,08h
1d50 3e40      ld      a,40h
1d52 110000    ld      de,0000h
1d55 c5        push    bc
1d56 cd741d    call    1d74h
1d59 c1        pop     bc
1d5a d0        ret     nc

1d5b 10f3      djnz    1d50h
1d5d 37        scf     

set_SD_CS:
1d5e f5        push    af
1d5f 3eff      ld      a,0ffh
1d61 d3e7      out     (0e7h),a			port E7 = FF; SD cs to 1
1d63 f1        pop     af
1d64 c9        ret     

1d65 3e41      ld      a,41h		; unk CMD
1d67 010000    ld      bc,0000h
1d6a 50        ld      d,b
1d6b 59        ld      e,c
1d6c cd9a1d    call    1d9ah		; read_spi_block
1d6f b7        or      a
1d70 c8        ret     z

1d71 37        scf     
1d72 18ea      jr      1d5eh		;port E7 = FF; SD control, set_SD_CS

1d74 010000    ld      bc,0000h
1d77 cd9a1d    call    1d9ah		; read_spi_block
1d7a 47        ld      b,a
1d7b e6fe      and     0feh
1d7d 78        ld      a,b
1d7e 20f1      jr      nz,1d71h
1d80 c9        ret     

; a -
; de - 
1d81 cd741d    call    1d74h		; send command ??
1d84 d8        ret     c
1d85 f5        push    af
1d86 cdd21d    call    1dd2h			;read_sd_data
1d89 67        ld      h,a
1d8a cdd21d    call    1dd2h			;read_sd_data
1d8d 6f        ld      l,a
1d8e cdd21d    call    1dd2h			;read_sd_data
1d91 57        ld      d,a
1d92 cdd21d    call    1dd2h			;read_sd_data
1d95 5f        ld      e,a
1d96 44        ld      b,h
1d97 4d        ld      c,l
1d98 f1        pop     af
1d99 c9        ret     

read_spi_block:
1d9a cde01d    call    1de0h			; read_SPI_data
1d9d d3eb      out     (0ebh),a			port EB = ??;SD SPIdata
1d9f f5        push    af
1da0 78        ld      a,b
1da1 00        nop     
1da2 d3eb      out     (0ebh),a			port EB = ??;SD SPIdata
1da4 79        ld      a,c
1da5 00        nop     
1da6 d3eb      out     (0ebh),a			port EB = ??;SD SPIdata
1da8 7a        ld      a,d
1da9 00        nop     
1daa d3eb      out     (0ebh),a			;SD SPIdata
1dac 7b        ld      a,e
1dad 00        nop     
1dae d3eb      out     (0ebh),a			;SD SPIdata
1db0 f1        pop     af
1db1 fe40      cp      40h
1db3 0695      ld      b,95h
1db5 2808      jr      z,1dbfh
1db7 fe48      cp      48h
1db9 0687      ld      b,87h
1dbb 2802      jr      z,1dbfh
1dbd 06ff      ld      b,0ffh
1dbf 78        ld      a,b
1dc0 d3eb      out     (0ebh),a			;SD SPIdata
1dc2 180e      jr      1dd2h			;read_sd_data
1dc4 060a      ld      b,0ah
1dc6 c5        push    bc
1dc7 cdd21d    call    1dd2h			;read_sd_data
1dca c1        pop     bc
1dcb fefe      cp      0feh
1dcd c8        ret     z

1dce 10f6      djnz    1dc6h
1dd0 37        scf     
1dd1 c9        ret     

read_sd_data:
1dd2 013200    ld      bc,0032h			; len 50 bytes
1dd5 dbeb      in      a,(0ebh)			; a = port EB ;SD SPIdata
1dd7 feff      cp      0ffh			; if xFF read - exit
1dd9 c0        ret     nz
1dda 10f9      djnz    1dd5h			; loop for b == 0
1ddc 0d        dec     c
1ddd 20f6      jr      nz,1dd5h			; loop for c == 0
1ddf c9        ret     

read_SPI_data:
1de0 f5        push    af
1de1 dbeb      in      a,(0ebh)			; a = port EB ; SD SPIdata
1de3 3afe3d    ld      a,(3dfeh)
1de6 d3e7      out     (0e7h),a			; port E7 = ?? ; SD control
1de8 f1        pop     af
1de9 c9        ret     

; write ro SD SPI
1dea fd7e01    ld      a,(iy+01h)
1ded e640      and     40h
1def cc971e    call    z,1e97h
1df2 fd7e00    ld      a,(iy+00h)
1df5 dd67      ld      ixh,a
1df7 dd7d      ld      a,ixl
1df9 d3e3      out     (0e3h),a			port E3 = ??
1dfb dd7c      ld      a,ixh
1dfd cd801c    call    1c80h		; check for (a & 0x08), [3dfeh] = a;
1e00 cd431e    call    1e43h			;port_24DF
1e03 3e58      ld      a,58h		; Command CMD24 to SD/SD-Card (Write 1 Block/512 Bytes)
1e05 cd6c1d    call    1d6ch		; read_spi_block
1e08 3e06      ld      a,06h
1e0a 3824      jr      c,1e30h
1e0c 3efe      ld      a,0feh
1e0e d3eb      out     (0ebh),a			port EB = FE;SD SPIdata
1e10 01eb00    ld      bc,00ebh		; b - counter, decrement; c - port
1e13 edb3      otir    			; hl - mem adr to port EB, 1 byte
1e15 edb3      otir    			; hl - mem adr to port EB, 255 byte    
1e17 3eff      ld      a,0ffh
1e19 d3eb      out     (0ebh),a			port EB = FF;SD SPIdata
1e1b 00        nop     
1e1c d3eb      out     (0ebh),a			port EB = FF;SD SPIdata
1e1e cdd21d    call    1dd2h			;read_sd_data
1e21 e61f      and     1fh
1e23 fe05      cp      05h
1e25 3e06      ld      a,06h
1e27 37        scf     
1e28 2006      jr      nz,1e30h
1e2a cdd21d    call    1dd2h			;read_sd_data
1e2d b7        or      a
1e2e 28fa      jr      z,1e2ah
1e30 cd5e1d    call    1d5eh		;port E7 = FF; SD control, set_SD_CS
1e33 dd6f      ld      ixl,a
1e35 dd7c      ld      a,ixh
1e37 01df24    ld      bc,24dfh
1e3a ed79      out     (c),a			port 24DF = ??
1e3c 3e00      ld      a,00h
1e3e d3e3      out     (0e3h),a			port E3 = 00
1e40 dd7d      ld      a,ixl
1e42 c9        ret     

port_24DF:
; turbo off, maybe
1e43 c5        push    bc
1e44 01df24    ld      bc,24dfh
1e47 ed78      in      a,(c)			; a = port 24DF
1e49 dd67      ld      ixh,a			; ixh = a
1e4b f604      or      04h			; a |= 04
1e4d ed79      out     (c),a			; port 24DF = 24DF | 04
1e4f c1        pop     bc
1e50 c9        ret     

SD_READ:
; read from SD SPI
1e51 fd7e01    ld      a,(iy+01h)
1e54 e640      and     40h
1e56 cc971e    call    z,1e97h
1e59 fd7e00    ld      a,(iy+00h)
1e5c dd67      ld      ixh,a
1e5e dd7d      ld      a,ixl
1e60 d3e3      out     (0e3h),a			port E3 = ??
1e62 dd7c      ld      a,ixh
1e64 cd801c    call    1c80h		; check for (a & 0x08), [3dfeh] = a;
1e67 cd431e    call    1e43h			;port_24DF
1e6a 3e51      ld      a,51h		; SD_READ()
1e6c cd6c1d    call    1d6ch		; read_spi_block
1e6f 3004      jr      nc,1e75h
1e71 3e06      ld      a,06h
1e73 18bb      jr      1e30h
1e75 cdc41d    call    1dc4h
1e78 38f7      jr      c,1e71h
1e7a 01eb00    ld      bc,00ebh
1e7d edb2      inir    				; [hl] = port EB ;SD SPIdata 1 byte
1e7f edb2      inir    				; [hl] = port EB ;SD SPIdata 255 byte
1e81 00        nop     
1e82 dbeb      in      a,(0ebh)			; a = port EB;SD SPIdata
1e84 00        nop     
1e85 dbeb      in      a,(0ebh)			; a = port EB;SD SPIdata
1e87 b7        or      a
1e88 18a6      jr      1e30h
1e8a cd2e03    call    032eh
1e8d 215f1c    ld      hl,1c5fh
1e90 fd7502    ld      (iy+02h),l
1e93 fd7403    ld      (iy+03h),h
1e96 c9        ret     

1e97 41        ld      b,c
1e98 4a        ld      c,d
1e99 53        ld      d,e
1e9a 1e00      ld      e,00h
1e9c cb22      sla     d
1e9e cb11      rl      c
1ea0 cb10      rl      b
1ea2 c9        ret     

1ea3 fd7e01    ld      a,(iy+01h)
1ea6 e640      and     40h
1ea8 2812      jr      z,1ebch
1eaa 23        inc     hl
1eab 23        inc     hl
1eac 7e        ld      a,(hl)
1ead e63f      and     3fh
1eaf 4f        ld      c,a
1eb0 23        inc     hl
1eb1 56        ld      d,(hl)
1eb2 23        inc     hl
1eb3 5e        ld      e,(hl)
1eb4 cd1c08    call    081ch		; inc e
1eb7 cd971e    call    1e97h
1eba 18e0      jr      1e9ch
1ebc 7e        ld      a,(hl)
1ebd e60f      and     0fh
1ebf f5        push    af
1ec0 23        inc     hl
1ec1 7e        ld      a,(hl)
1ec2 e603      and     03h
1ec4 57        ld      d,a
1ec5 23        inc     hl
1ec6 5e        ld      e,(hl)
1ec7 23        inc     hl
1ec8 7e        ld      a,(hl)
1ec9 e6c0      and     0c0h
1ecb 87        add     a,a
1ecc cb13      rl      e
1ece cb12      rl      d
1ed0 87        add     a,a
1ed1 cb13      rl      e
1ed3 cb12      rl      d
1ed5 13        inc     de
1ed6 23        inc     hl
1ed7 7e        ld      a,(hl)
1ed8 e603      and     03h
1eda 47        ld      b,a
1edb 23        inc     hl
1edc 7e        ld      a,(hl)
1edd e680      and     80h
1edf 87        add     a,a
1ee0 cb10      rl      b
1ee2 04        inc     b
1ee3 04        inc     b
1ee4 f1        pop     af
1ee5 80        add     a,b
1ee6 010000    ld      bc,0000h
1ee9 cdf81e    call    1ef8h
1eec 5a        ld      e,d
1eed 51        ld      d,c
1eee 48        ld      c,b
1eef 0600      ld      b,00h
1ef1 cb39      srl     c
1ef3 cb1a      rr      d
1ef5 cb1b      rr      e
1ef7 c9        ret     

1ef8 cb23      sla     e
1efa cb12      rl      d
1efc cb11      rl      c
1efe cb10      rl      b
1f00 3d        dec     a
1f01 20f5      jr      nz,1ef8h
1f03 c9        ret     

1f04 010000    ld      bc,0000h
1f07 50        ld      d,b
1f08 59        ld      e,c
1f09 21003e    ld      hl,3e00h
1f0c cf        rst     08h			;jp      0985h ; read_sd_card_sector
1f0d 81        add     a,c
1f0e d8        ret     c

1f0f 2afe3f    ld      hl,(3ffeh)
1f12 7c        ld      a,h
1f13 a5        and     l
1f14 37        scf     
1f15 c0        ret     nz

1f16 fde5      push    iy
1f18 e1        pop     hl
1f19 110800    ld      de,0008h
1f1c 19        add     hl,de
1f1d eb        ex      de,hl
1f1e 0604      ld      b,04h
1f20 21be3f    ld      hl,3fbeh
1f23 7e        ld      a,(hl)
1f24 e67f      and     7fh
1f26 23        inc     hl
1f27 23        inc     hl
1f28 23        inc     hl
1f29 23        inc     hl
1f2a 2006      jr      nz,1f32h
1f2c b6        or      (hl)
1f2d 2803      jr      z,1f32h
1f2f fd3400    inc     (iy+00h)
1f32 78        ld      a,b
1f33 010400    ld      bc,0004h
1f36 09        add     hl,bc
1f37 0e08      ld      c,08h
1f39 edb0      ldir    
1f3b 47        ld      b,a
1f3c 10e5      djnz    1f23h
1f3e c9        ret     

1f3f 00        nop     
1f40 00        nop     
1f41 00        nop     
1f42 00        nop     
1f43 00        nop     
1f44 00        nop     
1f45 00        nop     
1f46 00        nop     
1f47 00        nop     
1f48 00        nop     
1f49 00        nop     
1f4a 00        nop     
1f4b 00        nop     
1f4c 00        nop     
1f4d 00        nop     
1f4e 00        nop     
1f4f 00        nop     
1f50 00        nop     
1f51 00        nop     
1f52 00        nop     
1f53 00        nop     
1f54 00        nop     
1f55 00        nop     
1f56 00        nop     
1f57 00        nop     
1f58 00        nop     
1f59 00        nop     
1f5a 00        nop     
1f5b 00        nop     
1f5c 00        nop     
1f5d 00        nop     
1f5e 00        nop     
1f5f 00        nop     
1f60 00        nop     
1f61 00        nop     
1f62 00        nop     
1f63 00        nop     
1f64 00        nop     
1f65 00        nop     
1f66 00        nop     
1f67 00        nop     
1f68 00        nop     
1f69 00        nop     
1f6a 00        nop     
1f6b 00        nop     
1f6c 00        nop     
1f6d 00        nop     
1f6e 00        nop     
1f6f 00        nop     
1f70 00        nop     
1f71 00        nop     
1f72 00        nop     
1f73 00        nop     
1f74 00        nop     
1f75 00        nop     
1f76 00        nop     
1f77 00        nop     
1f78 00        nop     
1f79 00        nop     
1f7a 00        nop     
1f7b 00        nop     
1f7c 00        nop     
1f7d 00        nop     
1f7e 00        nop     
1f7f 00        nop     
1f80 00        nop     
1f81 00        nop     
1f82 00        nop     
1f83 00        nop     
1f84 00        nop     
1f85 00        nop     
1f86 00        nop     
1f87 00        nop     
1f88 00        nop     
1f89 00        nop     
1f8a 00        nop     
1f8b 00        nop     
1f8c 00        nop     
1f8d 00        nop     
1f8e 00        nop     
1f8f 00        nop     
1f90 00        nop     
1f91 00        nop     
1f92 00        nop     
1f93 00        nop     
1f94 00        nop     
1f95 00        nop     
1f96 00        nop     
1f97 00        nop     
1f98 00        nop     
1f99 00        nop     
1f9a 00        nop     
1f9b 00        nop     
1f9c 00        nop     
1f9d 00        nop     
1f9e 00        nop     
1f9f 00        nop     
1fa0 00        nop     
1fa1 00        nop     
1fa2 00        nop     
1fa3 00        nop     
1fa4 00        nop     
1fa5 00        nop     
1fa6 00        nop     
1fa7 00        nop     
1fa8 00        nop     
1fa9 00        nop     
1faa 00        nop     
1fab 00        nop     
1fac 00        nop     
1fad 00        nop     
1fae 00        nop     
1faf 00        nop     
1fb0 00        nop     
1fb1 00        nop     
1fb2 00        nop     
1fb3 00        nop     
1fb4 00        nop     
1fb5 00        nop     
1fb6 00        nop     
1fb7 00        nop     
1fb8 00        nop     
1fb9 00        nop     
1fba 00        nop     
1fbb 00        nop     
1fbc 00        nop     
1fbd 00        nop     
1fbe 00        nop     
1fbf 00        nop     
1fc0 00        nop     
1fc1 00        nop     
1fc2 00        nop     
1fc3 00        nop     
1fc4 00        nop     
1fc5 00        nop     
1fc6 00        nop     
1fc7 00        nop     
1fc8 00        nop     
1fc9 00        nop     
1fca 00        nop     
1fcb 00        nop     
1fcc 00        nop     
1fcd 00        nop     
1fce 00        nop     
1fcf 00        nop     
1fd0 00        nop     
1fd1 00        nop     
1fd2 00        nop     
1fd3 00        nop     
1fd4 00        nop     
1fd5 00        nop     
1fd6 00        nop     
1fd7 00        nop     
1fd8 00        nop     
1fd9 00        nop     
1fda 00        nop     
1fdb 00        nop     
1fdc 00        nop     
1fdd 00        nop     
1fde 00        nop     
1fdf 00        nop     
1fe0 00        nop     
1fe1 00        nop     
1fe2 00        nop     
1fe3 00        nop     
1fe4 00        nop     
1fe5 00        nop     
1fe6 00        nop     
1fe7 00        nop     
1fe8 00        nop     
1fe9 00        nop     
1fea 00        nop     
1feb 00        nop     
1fec 00        nop     
1fed 00        nop     
1fee 00        nop     
1fef 00        nop     
1ff0 00        nop     
1ff1 00        nop     
1ff2 00        nop     
1ff3 00        nop     
1ff4 e3        ex      (sp),hl
1ff5 1803      jr      1ffah
1ff7 fb        ei      
1ff8 c9        ret     

1ff9 fb        ei      
1ffa c9        ret     

1ffb e9        jp      (hl)	; jump to hl
1ffc ff        rst     38h
1ffd ff        rst     38h
1ffe ff        rst     38h
1fff ff        rst     38h
