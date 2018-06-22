; Disassembly of the file "C:\work\xilinx_proj\esxmmc\BETADISK.SYS"
; 
; CPU Type: Z80
; 
; Created with dZ80 2.0
; 
; on Thursday, 21 of June 2018 at 10:19 AM
; 
;	loaded at 0x2000



2000 21c926    ld      hl,26c9h		; from
2003 11003d    ld      de,3d00h		; to
2006 018900    ld      bc,0089h		; counter
2009 edb0      ldir    
200b 211897    ld      hl,9718h
200e 22973d    ld      (3d97h),hl
2011 0600      ld      b,00h
2013 cd1e20    call    201eh
2016 0601      ld      b,01h
2018 cd1e20    call    201eh
201b c3a827    jp      27a8h		; load config file

201e 3ec9      ld      a,0c9h
0020 32303d    ld      (3d30h),a
0023 3af83d    ld      a,(3df8h)
0026 f5        push    af
0027 78        ld      a,b
0028 32f83d    ld      (3df8h),a
002b 21003d    ld      hl,3d00h
002e 54        ld      d,h
002f 5d        ld      e,l
0030 45        ld      b,l
0031 0e89      ld      c,89h
0033 f7        rst     30h		; jr      0091h
0034 06f1      ld      b,0f1h
0036 32f83d    ld      (3df8h),a
0039 af        xor     a
003a 32303d    ld      (3d30h),a
003d c9        ret     

trdos_load:
; bc - lenght
203e 3a5323    ld      a,(2353h)
0041 ba        cp      d
0042 2005      jr      nz,2049h
0044 3a5223    ld      a,(2352h)
0047 bb        cp      e
0048 c8        ret     z
2049 ed535223  ld      (2352h),de
204d c5        push    bc
204e d5        push    de
204f 215423    ld      hl,2354h		"/SYS/TRDOS54T.KO", 13kb lenght
2052 cde802    call    02e8h		; load file
2055 d1        pop     de
2056 c1        pop     bc
2057 d8        ret     c
2058 c5        push    bc
2059 010000    ld      bc,0000h		; byte counter
005c 69        ld      l,c
005d f5        push    af
005e cf        rst     08h		;jp      0985h		; read_sd_card_sector
005f 9f        sbc     a,a
0060 f1        pop     af
0061 c1        pop     bc
0062 217328    ld      hl,2873h		; buffer
0065 f5        push    af
0066 cf        rst     08h		;jp      0985h		; read_sd_card_sector
0067 9d        sbc     a,l
0068 f1        pop     af
0069 cf        rst     08h		;jp      0985h		; read_sd_card_sector
006a 9b        sbc     a,e
006b c9        ret     

load_trdos_p1:
206c 217a28    ld      hl,287ah
206f 11200f    ld      de,0f20h
2072 01a90c    ld      bc,0ca9h		;  - lenght, 3241 bytes
2075 c34323    jp      2343h		; load_trdos

load_trdos_p2:
2078 21eb2e    ld      hl,2eebh
207b 11200f    ld      de,0f20h
207e 01a90c    ld      bc,0ca9h		;  - lenght, 3241 bytes
2081 c34323    jp      2343h		; load_trdos

0084 e5        push    hl
0085 d5        push    de
0086 c5        push    bc
0087 216326    ld      hl, 2663h	; proc addr ???
008a 22ee3d    ld      (3deeh),hl	;  x32E3 proc addr ??
008d 110000    ld      de, 0000h
0090 01200f    ld      bc, 0f20h	; file len?
0093 cd3e20    call    203eh		; trdos_load
0096 c1        pop     bc
0097 d1        pop     de
0098 e1        pop     hl
0099 c9        ret     

load_trdos??:
209a e5        push    hl
009b d5        push    de
009c c5        push    bc
009d f5        push    af
009e 110000    ld      de,0000h
00a1 01200f    ld      bc,0f20h
00a4 cd3e20    call    203eh		; trdos_load
00a7 3ec9      ld      a,0c9h
00a9 32303d    ld      (3d30h),a
00ac f1        pop     af
00ad c1        pop     bc
00ae d1        pop     de
00af 212f3d    ld      hl,3d2fh
00b2 e3        ex      (sp),hl
00b3 e5        push    hl
00b4 21423d    ld      hl,3d42h
00b7 e3        ex      (sp),hl
00b8 c37328    jp      2873h

00bb f5        push    af
00bc 3ab65c    ld      a,(5cb6h)
00bf fef4      cp      0f4h
00c1 2823      jr      z,00e6h
00c3 af        xor     a
00c4 21185d    ld      hl,5d18h
00c7 b6        or      (hl)
00c8 36ff      ld      (hl),0ffh
00ca 281a      jr      z,00e6h
00cc 3a0c5d    ld      a,(5d0ch)
00cf b7        or      a
00d0 21c35c    ld      hl,5cc3h
00d3 11335d    ld      de,5d33h
00d6 2003      jr      nz,00dbh
00d8 11345e    ld      de,5e34h
00db 062d      ld      b,2dh
00dd 4e        ld      c,(hl)
00de 1a        ld      a,(de)
00df 77        ld      (hl),a
00e0 79        ld      a,c
00e1 12        ld      (de),a
00e2 23        inc     hl
00e3 13        inc     de
00e4 10f7      djnz    00ddh
00e6 f1        pop     af
00e7 c9        ret     

20e8 7d        ld      a,l
20e9 216326    ld      hl,2663h
20ec 22ee3d    ld      (3deeh),hl	; change proc addr to 2663h
20ef e1        pop     hl
20f0 e3        ex      (sp),hl		; jmp to??
20f1 c9        ret     

00f2 3a303d    ld      a,(3d30h)
00f5 32af22    ld      (22afh),a
00f8 3ec9      ld      a,0c9h
00fa 32303d    ld      (3d30h),a
00fd f5        push    af
00fe c5        push    bc
00ff d5        push    de
0100 dde5      push    ix
0102 fde5      push    iy
0104 d9        exx     
0105 e5        push    hl
0106 c5        push    bc
0107 d5        push    de
0108 ed733621  ld      (2136h),sp
010c ed7bb322  ld      sp,(22b3h)
0110 223021    ld      (2130h),hl
0113 217a3d    ld      hl,3d7ah
0116 e5        push    hl
0117 dd2aba22  ld      ix,(22bah)
011b fd2ab822  ld      iy,(22b8h)
011f 3ab722    ld      a,(22b7h)
0122 67        ld      h,a
0123 2eff      ld      l,0ffh
0125 7e        ld      a,(hl)
0126 23        inc     hl
0127 66        ld      h,(hl)
0128 6f        ld      l,a
0129 0600      ld      b,00h
012b 3abc22    ld      a,(22bch)
012e e5        push    hl
012f 210000    ld      hl,0000h
0132 c3fa1f    jp      1ffah		; ret

0135 310000    ld      sp,0000h
0138 d1        pop     de
0139 c1        pop     bc
013a e1        pop     hl
013b d9        exx     
013c fde1      pop     iy
013e dde1      pop     ix
0140 d1        pop     de
0141 c1        pop     bc
0142 f1        pop     af
0143 3aaf22    ld      a,(22afh)
0146 32303d    ld      (3d30h),a
0149 c34f3d    jp      3d4fh
014c ed73be22  ld      (22beh),sp
0150 31803c    ld      sp,3c80h
0153 f5        push    af
0154 ed5f      ld      a,r
0156 321f36    ld      (361fh),a
0159 e5        push    hl
015a d5        push    de
015b 2abe22    ld      hl,(22beh)
015e 5e        ld      e,(hl)
015f 23        inc     hl
0160 56        ld      d,(hl)
0161 7a        ld      a,d
0162 fe40      cp      40h
0164 3029      jr      nc,018fh
0166 fe3d      cp      3dh
0168 200f      jr      nz,0179h
016a 7b        ld      a,e
016b fe31      cp      31h
016d 3813      jr      c,0182h
016f fe4f      cp      4fh
0171 3026      jr      nc,0199h
0173 fe42      cp      42h
0175 3810      jr      c,0187h
0177 1809      jr      0182h
0179 fe1f      cp      1fh
017b 201c      jr      nz,0199h
017d 7b        ld      a,e
017e fefa      cp      0fah
0180 2017      jr      nz,0199h
0182 3e00      ld      a,00h
0184 32303d    ld      (3d30h),a
0187 d1        pop     de
0188 e1        pop     hl
0189 f1        pop     af
018a ed7bbe22  ld      sp,(22beh)
018e c9        ret     

018f d1        pop     de
0190 e1        pop     hl
0191 f1        pop     af
0192 ed7bbe22  ld      sp,(22beh)
0196 c3423d    jp      3d42h
0199 d1        pop     de
019a e1        pop     hl
019b f1        pop     af
019c ed7bbe22  ld      sp,(22beh)
01a0 ed73b322  ld      (22b3h),sp
01a4 31ea3d    ld      sp,3deah
01a7 f5        push    af
01a8 ed57      ld      a,i
01aa fe40      cp      40h
01ac 380e      jr      c,01bch
01ae 32b722    ld      (22b7h),a

; ReadDelay param
21b1 00

01b2 ed47      ld      i,a
01b4 dd22ba22  ld      (22bah),ix
01b8 fd22b822  ld      (22b8h),iy
01bc cd8420    call    2084h
01bf f1        pop     af
01c0 f5        push    af
01c1 e5        push    hl
01c2 d5        push    de
01c3 2ab322    ld      hl,(22b3h)
01c6 54        ld      d,h
01c7 5d        ld      e,l
01c8 7e        ld      a,(hl)
01c9 23        inc     hl
01ca 66        ld      h,(hl)
01cb 6f        ld      l,a
01cc 7c        ld      a,h
01cd fe40      cp      40h
01cf 301a      jr      nc,01ebh
01d1 13        inc     de
01d2 13        inc     de
01d3 ed53b322  ld      (22b3h),de
01d7 cd0122    call    2201h
01da 22f43d    ld      (3df4h),hl
01dd d1        pop     de
01de e1        pop     hl
01df f1        pop     af
01e0 cde521    call    21e5h
01e3 18db      jr      01c0h
01e5 e5        push    hl
01e6 2af43d    ld      hl,(3df4h)
01e9 e3        ex      (sp),hl
01ea c9        ret     

01eb 3ab722    ld      a,(22b7h)
01ee a7        and     a
01ef 2806      jr      z,01f7h
01f1 ed47      ld      i,a
01f3 af        xor     a
01f4 32b722    ld      (22b7h),a
01f7 d1        pop     de
01f8 e1        pop     hl
01f9 f1        pop     af
01fa ed7bb322  ld      sp,(22b3h)
01fe c3423d    jp      3d42h
0201 11cc34    ld      de,34cch
0204 1a        ld      a,(de)
0205 13        inc     de
0206 bd        cp      l
0207 2002      jr      nz,020bh
0209 1a        ld      a,(de)
020a bc        cp      h
020b 13        inc     de
020c 2006      jr      nz,0214h
020e 1a        ld      a,(de)
020f 6f        ld      l,a
0210 13        inc     de
0211 1a        ld      a,(de)
0212 67        ld      h,a
0213 c9        ret     

0214 a7        and     a
0215 2804      jr      z,021bh
0217 13        inc     de
0218 13        inc     de
0219 18e9      jr      0204h
021b f3        di      
021c 3e02      ld      a,02h
021e d3fe      out     (0feh),a		port FE = 0; border 2
0220 3e10      ld      a,10h
0222 01fd7f    ld      bc,7ffdh		port 7ffd = 10; младший - D4 порта #7FFD
0225 ed79      out     (c),a
0227 e5        push    hl
0228 21005c    ld      hl,5c00h		; from
022b 11015c    ld      de,5c01h		; to
022e 0600      ld      b,00h		; bc - counter
0230 75        ld      (hl),l
0231 edb0      ldir        		; move from [hl] to [de], increment addr
0233 21f409    ld      hl,09f4h		; set basic variables
0236 224f5c    ld      (5c4fh),hl
0239 214f5c    ld      hl,5c4fh
023c 22515c    ld      (5c51h),hl
023f 3e07      ld      a,07h
0241 328f5c    ld      (5c8fh),a
0244 210040    ld      hl,4000h
0247 22845c    ld      (5c84h),hl
024a 212118    ld      hl,1821h
024d 22885c    ld      (5c88h),hl
0250 21003c    ld      hl,3c00h
0253 22365c    ld      (5c36h),hl
0256 e1        pop     hl
0257 31005c    ld      sp,5c00h
025a cd5f08    call    085fh		; print some
025d 21005b    ld      hl,5b00h
0260 3676      ld      (hl),76h
0262 c3fb1f    jp      1ffbh		; jmp to 0076

0265 ef        rst     28h		; jmp to addr (3deeh)
0266 8e        adc     a,(hl)
0267 e6c0      and     0c0h
0269 28fa      jr      z,0265h
026b f8        ret     m

026c 79        ld      a,c
026d fe7f      cp      7fh
026f 202a      jr      nz,029bh
0271 3a8723    ld      a,(2387h)
0274 fea0      cp      0a0h
0276 2023      jr      nz,029bh
0278 c5        push    bc
0279 d5        push    de
027a ed732823  ld      (2328h),sp
027e 3a2923    ld      a,(2329h)
0281 fe40      cp      40h
0283 3803      jr      c,0288h
0285 31d83d    ld      sp,3dd8h
0288 3e00      ld      a,00h
028a cd2e23    call    232eh
028d 3a8a23    ld      a,(238ah)
0290 ed5b8823  ld      de,(2388h)
0294 010000    ld      bc,0000h
0297 cf        rst     08h		; jp      0985h		; read_sd_card_sector
0298 82        add     a,d
0299 187a      jr      0315h
029b ef        rst     28h		; jmp to addr (3deeh)
029c f418c6    call    p,0c618h
029f 0604      ld      b,04h
02a1 ef        rst     28h		; jmp to addr (3deeh)
02a2 8e        adc     a,(hl)
02a3 e6c0      and     0c0h
02a5 20c5      jr      nz,026ch
02a7 13        inc     de
02a8 7b        ld      a,e
02a9 b2        or      d
02aa 20f5      jr      nz,02a1h
02ac 10f3      djnz    02a1h
02ae c9        ret     

02af 00        nop     
22b0 c37837    jp      3778h

22b3 00        nop     
02b4 00        nop     
02b5 00        nop     
02b6 00        nop     
02b7 00        nop     
02b8 00        nop     
02b9 00        nop     
02ba 00        nop     
02bb 00        nop     
02bc 00        nop     
02bd 00        nop     
02be 00        nop     
02bf 00        nop     
02c0 0604      ld      b,04h
02c2 ef        rst     28h		; jmp to addr (3deeh)
02c3 8e        adc     a,(hl)
02c4 e6c0      and     0c0h
02c6 200f      jr      nz,02d7h
02c8 13        inc     de
02c9 7b        ld      a,e
02ca b2        or      d
02cb 20f5      jr      nz,02c2h
02cd 10f3      djnz    02c2h
02cf c9        ret     

02d0 ef        rst     28h		; jmp to addr (3deeh)
02d1 8e        adc     a,(hl)
02d2 e6c0      and     0c0h
02d4 28fa      jr      z,02d0h
02d6 f8        ret     m

02d7 79        ld      a,c
02d8 fe7f      cp      7fh
02da 2063      jr      nz,033fh
02dc 3a8723    ld      a,(2387h)
02df fe80      cp      80h
02e1 205c      jr      nz,033fh
02e3 c5        push    bc
02e4 d5        push    de
02e5 ed732823  ld      (2328h),sp
02e9 3a2923    ld      a,(2329h)
02ec fe40      cp      40h
02ee 3803      jr      c,02f3h
02f0 31d83d    ld      sp,3dd8h
02f3 7c        ld      a,h
02f4 fe40      cp      40h
02f6 3827      jr      c,031fh
02f8 3e00      ld      a,00h
02fa cd2e23    call    232eh
02fd 3a8a23    ld      a,(238ah)
0300 ed5b8823  ld      de,(2388h)
0304 010000    ld      bc,0000h
0307 d5        push    de
0308 cf        rst     08h		; jp      0985h		; read_sd_card_sector
0309 81        add     a,c
030a d1        pop     de
030b 3012      jr      nc,031fh
030d af        xor     a
230e 47        ld      b,a
030f 77        ld      (hl),a
0310 23        inc     hl
0311 10fc      djnz    030fh
0313 180a      jr      031fh
0315 3008      jr      nc,031fh
0317 3a8223    ld      a,(2382h)
031a f610      or      10h
031c 328223    ld      (2382h),a
031f 7a        ld      a,d
0320 b3        or      e
0321 cc7726    call    z,2677h
0324 cd7a24    call    247ah
0327 310000    ld      sp,0000h
032a d1        pop     de
032b c1        pop     bc
032c 18a2      jr      02d0h
032e a7        and     a
032f c8        ret     z

0330 0610      ld      b,10h
0332 10fe      djnz    0332h
0334 3d        dec     a
0335 20f9      jr      nz,0330h
0337 c9        ret     

0338 ef        rst     28h		; jmp to addr (3deeh)
0339 8e        adc     a,(hl)
033a e6c0      and     0c0h
033c 28fa      jr      z,0338h
033e f8        ret     m

033f ef        rst     28h		; jmp to addr (3deeh)
0340 e8        ret     pe

0341 18f5      jr      0338h

load_trdos:
2343 e5        push    hl
2344 ed734f23  ld      (234fh),sp
2348 31ea3d    ld      sp,3deah
234b cd3e20    call    203eh		; trdos_load
234e 310000    ld      sp,0000h
2351 c9        ret     

; TRDOS flags
2352 ff ff

2354 2f [..] 4f 00			/SYS/TRDOS54T.KO

0365 010902    ld      bc,0209h
0368 0a        ld      a,(bc)
0369 03        inc     bc
036a 0b        dec     bc
036b 04        inc     b
036c 0c        inc     c
036d 05        dec     b
036e 0d        dec     c
036f 060e      ld      b,0eh
0371 07        rlca    
0372 0f        rrca    
0373 08        ex      af,af'
0374 1000      djnz    0376h
0376 00        nop     
0377 00        nop     
0378 00        nop     
0379 00        nop     
037a 00        nop     
037b 00        nop     
037c 00        nop     
037d 010000    ld      bc,0000h
0380 00        nop     
0381 00        nop     
0382 00        nop     
0383 00        nop     
0384 00        nop     
0385 00        nop     
0386 00        nop     
0387 00        nop     
0388 00        nop     
0389 00        nop     
038a 00        nop     
038b 00        nop     
038c 00        nop     
038d 013a79    ld      bc,793ah
0390 23        inc     hl
0391 c9        ret     

0392 328523    ld      (2385h),a
0395 c9        ret     

0396 3a8323    ld      a,(2383h)
0399 c9        ret     

039a 3a8423    ld      a,(2384h)
039d c9        ret     

039e 328323    ld      (2383h),a
03a1 c9        ret     

03a2 328423    ld      (2384h),a
03a5 c9        ret     

03a6 e5        push    hl
03a7 f5        push    af
03a8 3a8223    ld      a,(2382h)
03ab e67f      and     7fh
03ad 328223    ld      (2382h),a
03b0 cd5a26    call    265ah
03b3 cf        rst     08h		; jp      0985h		; read_sd_card_sector
03b4 83        add     a,e
03b5 3a8223    ld      a,(2382h)
03b8 3002      jr      nc,03bch
03ba 3e80      ld      a,80h
03bc 6f        ld      l,a
03bd e681      and     81h
03bf 328223    ld      (2382h),a
03c2 3a7923    ld      a,(2379h)
03c5 e6ff      and     0ffh
03c7 327923    ld      (2379h),a
03ca f1        pop     af
03cb 7d        ld      a,l
03cc e1        pop     hl
03cd c9        ret     

03ce f5        push    af
03cf c5        push    bc
03d0 e5        push    hl
03d1 21e223    ld      hl,23e2h
03d4 e3        ex      (sp),hl
03d5 47        ld      b,a
03d6 1824      jr      03fch
03d8 f5        push    af
03d9 c5        push    bc
03da e5        push    hl
03db 21e223    ld      hl,23e2h
03de e3        ex      (sp),hl
03df 42        ld      b,d
03e0 181a      jr      03fch
03e2 c1        pop     bc
03e3 f1        pop     af
03e4 c9        ret     

03e5 c33124    jp      2431h
03e8 c33b24    jp      243bh
03eb c36124    jp      2461h
03ee c38924    jp      2489h
03f1 c3a924    jp      24a9h
03f4 f5        push    af
03f5 c5        push    bc
03f6 e5        push    hl
03f7 212e24    ld      hl,242eh
03fa e3        ex      (sp),hl
03fb 46        ld      b,(hl)
03fc e5        push    hl
03fd 79        ld      a,c
03fe fe1f      cp      1fh
0400 21a924    ld      hl,24a9h
0403 2826      jr      z,042bh
0405 fe7f      cp      7fh
0407 219223    ld      hl,2392h
040a 281f      jr      z,042bh
040c fe5f      cp      5fh
040e 21a223    ld      hl,23a2h
0411 2818      jr      z,042bh
0413 fe3f      cp      3fh
0415 219e23    ld      hl,239eh
0418 2811      jr      z,042bh
041a feff      cp      0ffh
041c 218924    ld      hl,2489h
041f 280a      jr      z,042bh
0421 78        ld      a,b
0422 c1        pop     bc
0423 e1        pop     hl
0424 60        ld      h,b
0425 69        ld      l,c
0426 c1        pop     bc
0427 ed79      out     (c),a
0429 f1        pop     af
042a c9        ret     

042b e3        ex      (sp),hl
042c 78        ld      a,b
042d c9        ret     

042e c1        pop     bc
042f 182c      jr      045dh
0431 f5        push    af
0432 e5        push    hl
0433 213824    ld      hl,2438h
0436 1808      jr      0440h
0438 67        ld      h,a
0439 f1        pop     af
043a c9        ret     

043b f5        push    af
043c e5        push    hl
043d 215c24    ld      hl,245ch
0440 e3        ex      (sp),hl
0441 79        ld      a,c
0442 fe7f      cp      7fh
0444 281b      jr      z,0461h
0446 fe5f      cp      5fh
0448 ca9a23    jp      z,239ah
044b fe3f      cp      3fh
044d ca9623    jp      z,2396h
0450 fe1f      cp      1fh
0452 caa623    jp      z,23a6h
0455 feff      cp      0ffh
0457 ca8e23    jp      z,238eh
045a ed78      in      a,(c)		; port read
045c 77        ld      (hl),a
045d 23        inc     hl
045e 05        dec     b
045f f1        pop     af
0460 c9        ret     

0461 e5        push    hl
0462 f5        push    af
0463 3e03      ld      a,03h
0465 327c23    ld      (237ch),a
0468 263c      ld      h,3ch
046a 3a7b23    ld      a,(237bh)
046d 6f        ld      l,a
046e 3c        inc     a
046f 327b23    ld      (237bh),a
0472 6e        ld      l,(hl)
0473 cc7a24    call    z,247ah
0476 f1        pop     af
0477 7d        ld      a,l
0478 e1        pop     hl
0479 c9        ret     

047a af        xor     a
047b 327c23    ld      (237ch),a
047e 3a8223    ld      a,(2382h)
0481 e6fc      and     0fch
0483 328223    ld      (2382h),a
0486 c38e25    jp      258eh
0489 f5        push    af
048a e5        push    hl
048b 6f        ld      l,a
048c 3a8623    ld      a,(2386h)
048f ad        xor     l
0490 a5        and     l
0491 e604      and     04h
0493 c43a26    call    nz,263ah
0496 7d        ld      a,l
0497 328623    ld      (2386h),a
049a e603      and     03h
049c 327623    ld      (2376h),a
049f 7d        ld      a,l
04a0 2f        cpl     
04a1 e610      and     10h
04a3 327723    ld      (2377h),a
04a6 e1        pop     hl
04a7 f1        pop     af
04a8 c9        ret     

04a9 f5        push    af
04aa e5        push    hl
04ab e6f0      and     0f0h
04ad 6f        ld      l,a
04ae fed0      cp      0d0h
04b0 2832      jr      z,04e4h
04b2 3a8223    ld      a,(2382h)
04b5 e601      and     01h
04b7 2803      jr      z,04bch
04b9 e1        pop     hl
04ba f1        pop     af
04bb c9        ret     

04bc af        xor     a
04bd 328223    ld      (2382h),a
04c0 7d        ld      a,l
04c1 328723    ld      (2387h),a
04c4 fe10      cp      10h
04c6 da7325    jp      c,2573h
04c9 fe20      cp      20h
04cb da5a25    jp      c,255ah
04ce fe80      cp      80h
04d0 da2825    jp      c,2528h
04d3 fea0      cp      0a0h
04d5 381b      jr      c,04f2h
04d7 fec0      cp      0c0h
04d9 3817      jr      c,04f2h
04db ca9425    jp      z,2594h
04de e1        pop     hl
04df cd8e25    call    258eh
04e2 f1        pop     af
04e3 c9        ret     

04e4 af        xor     a
04e5 327c23    ld      (237ch),a
04e8 3a8223    ld      a,(2382h)
04eb e6fe      and     0feh
04ed 328223    ld      (2382h),a
04f0 18ec      jr      04deh
04f2 d5        push    de
04f3 210000    ld      hl,0000h
04f6 227a23    ld      (237ah),hl
04f9 2a8323    ld      hl,(2383h)
04fc 25        dec     h
04fd 3a7723    ld      a,(2377h)
0500 84        add     a,h
0501 5f        ld      e,a
0502 1600      ld      d,00h
0504 2600      ld      h,00h
0506 29        add     hl,hl
0507 29        add     hl,hl
0508 29        add     hl,hl
0509 29        add     hl,hl
050a 29        add     hl,hl
050b 19        add     hl,de
050c 228823    ld      (2388h),hl
050f cd5a26    call    265ah
0512 328a23    ld      (238ah),a
0515 d1        pop     de
0516 e1        pop     hl
0517 3e03      ld      a,03h
0519 328223    ld      (2382h),a
051c 3e03      ld      a,03h
051e 327c23    ld      (237ch),a
0521 3e40      ld      a,40h
0523 327923    ld      (2379h),a
0526 f1        pop     af
0527 c9        ret     

0528 c5        push    bc
0529 47        ld      b,a
052a 217823    ld      hl,2378h
052d e640      and     40h
052f 2804      jr      z,0535h
0531 78        ld      a,b
0532 e620      and     20h
0534 77        ld      (hl),a
0535 78        ld      a,b
0536 e6df      and     0dfh
0538 b6        or      (hl)
0539 47        ld      b,a
053a cdd325    call    25d3h
053d e620      and     20h
053f 7e        ld      a,(hl)
0540 2805      jr      z,0547h
0542 a7        and     a
0543 2804      jr      z,0549h
0545 3d        dec     a
0546 3d        dec     a
0547 3c        inc     a
0548 77        ld      (hl),a
0549 cb60      bit     4,b
054b 2803      jr      z,0550h
054d 328323    ld      (2383h),a
0550 af        xor     a
0551 cdc625    call    25c6h
0554 328223    ld      (2382h),a
0557 c1        pop     bc
0558 1884      jr      04deh
055a cdd325    call    25d3h
055d 3a8523    ld      a,(2385h)
0560 77        ld      (hl),a
0561 328323    ld      (2383h),a
0564 3e01      ld      a,01h
0566 327d23    ld      (237dh),a
0569 af        xor     a
056a cdc625    call    25c6h
056d 328223    ld      (2382h),a
0570 c3de24    jp      24deh
0573 c5        push    bc
0574 47        ld      b,a
0575 af        xor     a
0576 cdd325    call    25d3h
0579 77        ld      (hl),a
057a 328323    ld      (2383h),a
057d 78        ld      a,b
057e e608      and     08h
0580 87        add     a,a
0581 87        add     a,a
0582 47        ld      b,a
0583 af        xor     a
0584 f604      or      04h
0586 b0        or      b
0587 328223    ld      (2382h),a
058a c1        pop     bc
058b c3de24    jp      24deh
058e 3e80      ld      a,80h
0590 327923    ld      (2379h),a
0593 c9        ret     

0594 cdd325    call    25d3h
0597 7e        ld      a,(hl)
0598 f5        push    af
0599 3efa      ld      a,0fah
059b 327b23    ld      (237bh),a
059e 263c      ld      h,3ch
05a0 6f        ld      l,a
05a1 f1        pop     af
05a2 77        ld      (hl),a
05a3 2c        inc     l
05a4 3a7723    ld      a,(2377h)
05a7 d610      sub     10h
05a9 e601      and     01h
05ab 77        ld      (hl),a
05ac 2c        inc     l
05ad 3a8d23    ld      a,(238dh)
05b0 f600      or      00h
05b2 77        ld      (hl),a
05b3 2c        inc     l
05b4 3601      ld      (hl),01h
05b6 2c        inc     l
05b7 af        xor     a
05b8 77        ld      (hl),a
05b9 2c        inc     l
05ba 77        ld      (hl),a
05bb 3a8c23    ld      a,(238ch)
05be c600      add     a,00h
05c0 328c23    ld      (238ch),a
05c3 c31625    jp      2516h
05c6 67        ld      h,a
05c7 e5        push    hl
05c8 cdd325    call    25d3h
05cb 7e        ld      a,(hl)
05cc e1        pop     hl
05cd b7        or      a
05ce 7c        ld      a,h
05cf c0        ret     nz

05d0 f604      or      04h
05d2 c9        ret     

05d3 f5        push    af
05d4 3a7623    ld      a,(2376h)
05d7 217e23    ld      hl,237eh
05da 85        add     a,l
05db 6f        ld      l,a
05dc f1        pop     af
05dd c9        ret     

05de f5        push    af
05df cde425    call    25e4h
05e2 f1        pop     af
05e3 c9        ret     

05e4 3a7c23    ld      a,(237ch)
05e7 a7        and     a
05e8 281a      jr      z,0604h
05ea 3d        dec     a
05eb 327c23    ld      (237ch),a
05ee 2014      jr      nz,0604h
05f0 3a8723    ld      a,(2387h)
05f3 e680      and     80h
05f5 280d      jr      z,0604h
05f7 3a8223    ld      a,(2382h)
05fa e6fc      and     0fch
05fc f604      or      04h
05fe 328223    ld      (2382h),a
0601 cd8e25    call    258eh
0604 3a8223    ld      a,(2382h)
0607 e6fd      and     0fdh
0609 328223    ld      (2382h),a
060c 3a8c23    ld      a,(238ch)
060f 3d        dec     a
0610 328c23    ld      (238ch),a
0613 c0        ret     nz

0614 3a8d23    ld      a,(238dh)
0617 e603      and     03h
0619 c608      add     a,08h
061b 328c23    ld      (238ch),a
061e 3a8d23    ld      a,(238dh)
0621 3c        inc     a
0622 fe11      cp      11h
0624 2002      jr      nz,0628h
0626 e60f      and     0fh
0628 328d23    ld      (238dh),a
062b 3a8723    ld      a,(2387h)
062e e680      and     80h
0630 c0        ret     nz

0631 3a8223    ld      a,(2382h)
0634 f602      or      02h
0636 328223    ld      (2382h),a
0639 c9        ret     

063a c5        push    bc
063b e5        push    hl
063c d5        push    de
063d 217623    ld      hl,2376h
0640 117723    ld      de,2377h
0643 011700    ld      bc,0017h
0646 70        ld      (hl),b
0647 edb0      ldir    
0649 3e0c      ld      a,0ch
064b 328623    ld      (2386h),a
064e 3e01      ld      a,01h
0650 328c23    ld      (238ch),a
0653 328d23    ld      (238dh),a
0656 d1        pop     de
0657 e1        pop     hl
0658 c1        pop     bc
0659 c9        ret     

065a 3a7623    ld      a,(2376h)
065d 87        add     a,a
065e 87        add     a,a
065f 87        add     a,a
0660 f660      or      60h
0662 c9        ret     

2663 e3        ex      (sp),hl
2664 328b23    ld      (238bh),a
0667 7e        ld      a,(hl)
0668 23        inc     hl
0669 e3        ex      (sp),hl
066a e5        push    hl
066b f5        push    af
066c 2623      ld      h,23h
066e 6f        ld      l,a
066f f1        pop     af
0670 3a8b23    ld      a,(238bh)
0673 e3        ex      (sp),hl
0674 c3de25    jp      25deh

0677 e5        push    hl
0678 25        dec     h
0679 0e10      ld      c,10h
067b cd9826    call    2698h
067e a7        and     a
067f 11400d    ld      de,0d40h
0682 200a      jr      nz,068eh
0684 111000    ld      de,0010h
0687 19        add     hl,de
0688 0d        dec     c
0689 20f0      jr      nz,067bh
068b 110000    ld      de,0000h
068e 7b        ld      a,e
068f 32b125    ld      (25b1h),a
0692 7a        ld      a,d
0693 32bf25    ld      (25bfh),a
0696 e1        pop     hl
0697 c9        ret     

0698 11b626    ld      de,26b6h
069b e5        push    hl
069c d5        push    de
069d 0609      ld      b,09h
069f 1a        ld      a,(de)
06a0 a7        and     a
06a1 2807      jr      z,06aah
06a3 be        cp      (hl)
06a4 2007      jr      nz,06adh
06a6 23        inc     hl
06a7 13        inc     de
06a8 10f5      djnz    069fh
06aa d1        pop     de
06ab e1        pop     hl
06ac c9        ret     

06ad e1        pop     hl
06ae 110900    ld      de,0009h
06b1 19        add     hl,de
06b2 eb        ex      de,hl
06b3 e1        pop     hl
06b4 18e5      jr      069bh
06b6 4b        ld      c,e
06b7 61        ld      h,c
06b8 67        ld      h,a
06b9 212020    ld      hl,2020h
06bc 2020      jr      nz,06deh
06be 42        ld      b,d
06bf 2d        dec     l
06c0 3d        dec     a
06c1 37        scf     
06c2 2a5550    ld      hl,(5055h)
06c5 3d        dec     a
06c6 2d        dec     l
06c7 42        ld      b,d
06c8 00        nop     

;==============================================================================
; proc moved to 3d00h
26c9 e5        push    hl
26ca 1819      jr      26e5h
26cc e5        push    hl
26cd 217820    ld      hl,2078h		; load_trdos_p2
26d0 181b      jr      26edh
26d2 e5        push    hl
26d3 219a20    ld      hl,209ah		; load_trdos??
26d6 1815      jr      26edh
26d8 00        nop     
26d9 c3bb20    jp      20bbh

26dc 00        nop     
26dd 18f3      jr      26d2h
26df 1865      jr      2746h
26e1 00        nop     
26e2 00        nop     
26e3 18e7      jr      26cch
26e5 216c20    ld      hl,206ch		; load_trdos_p1
26e8 1803      jr      26edh
26ea c3a32b    jp      2ba3h

26ed e5        push    hl
26ee 6f        ld      l,a
26ef 3e03      ld      a,03h
26f1 d3e3      out     (0e3h),a		port E3 = 03; conmem off, page 3
26f3 c3e820    jp      20e8h

; variables
26f6 00
26f7 00
26f8 00
26f9/3d30 00	init to 0c9h

26fa ed433d3d  ld      (3d3dh),bc
26fe 47        ld      b,a
26ff 3ec9      ld      a,0c9h
2701 32303d    ld      (3d30h),a
2704 78        ld      a,b
2705 010000    ld      bc,0000h
2708 c34c21    jp      214ch

270b 324b3d    ld      (3d4bh),a
270e 3e00      ld      a,00h
2710 32303d    ld      (3d30h),a
2713 3e00      ld      a,00h
2715 c3fa1f    jp      1ffah		; ret

2718 3abd22    ld      a,(22bdh)
271b d3e3      out     (0e3h),a		port E3 = ??
271d 3e00      ld      a,00h
271f 210000    ld      hl,0000h
2722 c9        ret     

2723 22573d    ld      (3d57h),hl
2726 32553d    ld      (3d55h),a
2729 6f        ld      l,a
272a 3af93d    ld      a,(3df9h)
272d 67        ld      h,a
272e 3e03      ld      a,03h
2730 d3e3      out     (0e3h),a		port E3 = 03; conmem off, page 3
2732 22bc22    ld      (22bch),hl
2735 7c        ld      a,h
2736 d3e3      out     (0e3h),a		port E3 = ??
2738 7d        ld      a,l
2739 2a573d    ld      hl,(3d57h)
273c 3e03      ld      a,03h
273e d3e3      out     (0e3h),a		port E3 = 03; conmem off, page 3

2740 c3f220    jp      20f2h

2743 c33521    jp      2135h

2746 e5        push    hl
2747 215928    ld      hl,2859h
274a 18a1      jr      26edh

274c c30c35    jp      350ch

274f c31435    jp      3514h
;==============================================================================
0752 2f 53 [..] 47 00			/SYS/CONFIG/TRDOS.CFG

2768 52 [..] 79 00			ReadDelay

0772 f9
0773 22

2774 57 72 [..] 79 00			WriteDelay

077f 89
0780 22

2781 4c 6f [..] 65 00			LoadMode

078a b1
078b 21

278c 41 75 [..] 32 00			AutoIM2

0794 a5
0795 27

2796 53 [..] 53 00			SafeCallBAS

07a2 a7        and     a
07a3 27        daa     
07a4 00        nop     
07a5 00        nop     
07a6 00        nop     
07a7 00        nop     

read_cfg_file:
27a8 215227    ld      hl,2752h			"/SYS/CONFIG/TRDOS.CFG"
07ab cde802    call    02e8h		; open file
07ae d8        ret     c		; error opening file, exit
07af 217328    ld      hl,2873h		; read buffer
07b2 010004    ld      bc,0400h		; 1kb
07b5 5f        ld      e,a
07b6 d5        push    de
07b7 cf        rst     08h		; jp      0985h ; read_sd_card_sector
07b8 9d        sbc     a,l
07b9 d1        pop     de
07ba d8        ret     c		; error reading, exit
07bb 3600      ld      (hl),00h
07bd 7b        ld      a,e
07be cf        rst     08h		; jp      0985h		; read_sd_card_sector
07bf 9b        sbc     a,e
07c0 217328    ld      hl,2873h		; read buffer
07c3 116827    ld      de,2768h		"ReadDelay"
07c6 cdd827    call    27d8h		; parse_param
07c9 3ab121    ld      a,(21b1h)	; ReadDelay param
07cc a7        and     a
07cd c8        ret     z		; zero - no delay
07ce 3d        dec     a
07cf 3eaf      ld      a,0afh
07d1 2801      jr      z,07d4h
07d3 af        xor     a
07d4 32b121    ld      (21b1h),a	; ReadDelay param
07d7 c9        ret     

parse_param:
; hl - buffer
; de - string for search
27d8 7e        ld      a,(hl)
27d9 b7        or      a
27da c8        ret     z		; return if zero
27db fe21      cp      21h		'!'
27dd 3003      jr      nc,27e2h
27df 23        inc     hl
27e0 18f6      jr      27d8h
27e2 fe23      cp      23h		'#'
27e4 283e      jr      z,2824h
27e6 010000    ld      bc,0000h
27e9 7e        ld      a,(hl)
27ea b7        or      a
27eb 2833      jr      z,2820h
27ed d5        push    de
27ee 1a        ld      a,(de)
27ef b7        or      a
27f0 282d      jr      z,281fh
27f2 e5        push    hl
27f3 1a        ld      a,(de)
27f4 b7        or      a
27f5 2807      jr      z,27feh
27f7 be        cp      (hl)
27f8 201b      jr      nz,2815h
27fa 23        inc     hl
27fb 13        inc     de
27fc 18f5      jr      27f3h
27fe 7e        ld      a,(hl)
27ff fe3d      cp      3dh		'='
2801 2809      jr      z,280ch
2803 fe21      cp      21h		'!'
2805 300e      jr      nc,2815h
2807 cd5028    call    2850h
280a 18f2      jr      27feh
280c 23        inc     hl
280d cd5028    call    2850h
2810 c1        pop     bc
2811 42        ld      b,d
2812 4b        ld      c,e
2813 180a      jr      281fh
2815 e1        pop     hl
2816 1a        ld      a,(de)
2817 13        inc     de
2818 b7        or      a
2819 20fb      jr      nz,2816h
281b 13        inc     de
281c 13        inc     de
281d 18cf      jr      27eeh
281f d1        pop     de
2820 79        ld      a,c
2821 b0        or      b
2822 2008      jr      nz,282ch
2824 7e        ld      a,(hl)
2825 fe20      cp      20h		' '
2827 38af      jr      c,27d8h
2829 23        inc     hl
282a 18f8      jr      2824h
282c 03        inc     bc
282d b7        or      a
282e d5        push    de
282f 1e00      ld      e,00h
2831 7e        ld      a,(hl)
2832 fe21      cp      21h		'!'
2834 380f      jr      c,2845h
2836 7b        ld      a,e
2837 87        add     a,a
2838 5f        ld      e,a
2839 87        add     a,a
283a 87        add     a,a
283b 83        add     a,e
283c 5f        ld      e,a
283d 7e        ld      a,(hl)
283e 23        inc     hl
283f d630      sub     30h		; from ASCII digit to 0x00-0x09
2841 83        add     a,e
2842 5f        ld      e,a
2843 18ec      jr      2831h
2845 e5        push    hl
2846 0a        ld      a,(bc)
2847 6f        ld      l,a
2848 03        inc     bc
2849 0a        ld      a,(bc)
284a 67        ld      h,a
284b 73        ld      (hl),e
284c e1        pop     hl
284d d1        pop     de
284e 1888      jr      27d8h
2850 7e        ld      a,(hl)
2851 b7        or      a
2852 c8        ret     z
2853 fe21      cp      21h
2855 d0        ret     nc
2856 23        inc     hl
2857 18f7      jr      2850h
2859 11200f    ld      de,0f20h
285c 01a90c    ld      bc,0ca9h
285f ed736a28  ld      (286ah),sp
2863 31ea3d    ld      sp,3deah
2866 cd3e20    call    203eh		; trdos_load
2869 310000    ld      sp,0000h
286c 217d3d    ld      hl,3d7dh
286f e5        push    hl
2870 c38632    jp      3286h
