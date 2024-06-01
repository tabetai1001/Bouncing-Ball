.data 
buffer: .space 0x100000
xv: .word 0 # vantoc x bat dau
yv: .word 0#van toc y bat dau
xp: .word 256 #vi tri x
yp: .word 256 #vi tri y
tail : .word 0 #vi tri tail tren bitmap
circleUp :.word 0x0000ff00 #green pixel khi di chuyen len
circleDown :.word 0x0100ff00 #green pixel khi di chuyen xuong
circleLeft :.word 0x0200ff00 #green pixel khi di chuyen sang trai
circleRight :.word 0x0300ff00 #green pixel khi di chuyen sang phai
xconvert: .word 512 #gia tri cua x dua xp vao bitmap
yconvert: .word 4 #gia tri cua y dua yp vao bitmap
.text
main:
#border
la $t0,buffer #dia chi buffer
li $t1,512 #512*512 
li $t2,0xFF4500 #red color
bordertop:
   sw $t2,0($t0) # mau do
   addi $t0,$t0,4 #di den pixel tiep theo
   addi $t1,$t1,-1 #giam pixelcount
   bnez $t1,bordertop #lap den khi pixelcount=0
### set up bat dau ve border bot
   la $t0,buffer #screen address
   addi,$t0,$t0,1046528 #pixel goc duoi ben trai
   addi $t1,$zero,512 #do dai row duoi cung
borderbot: #cac border con lai tuong tu
   sw $t2,0($t0) 
   addi $t0,$t0,4
   addi $t1,$t1,-1
   bnez $t1,borderbot
####set up bat dau ve border left
   la $t0,buffer
   addi $t1,$zero,511 #1+511 =512
borderleft:
   sw $t2,0($t0)
   addi $t0,$t0,2048
   addi,$t1,$t1,-1
   bnez $t1,borderleft
###set up bat dau ve border right
   la $t0,buffer
   addi,$t0,$t0,2044
   addi $t1,$zero,511
borderright:
   sw $t2,0($t0)
   addi $t0,$t0,2048
   addi ,$t1,$t1,-1
   bnez ,$t1,borderright
#Input tu Keyboard
   li $s0,400

thaotacgame:

   lw $s1,0xffff0004
   addi $v0,$zero,32
   addi $a0,$zero,66
   syscall
   beq $s1,100,moveright #ma ascii cua cac chu cai lan luot la "d"
   beq $s1,97,moveleft #"a"
   beq $s1,119,moveup # "w"
   beq $s1,115,movedown #"s"

   beq $t3,0,moveup #bat dau bang viec di len
moveup:
   lw $s3,circleUp #huong len
   add $a0,$s3,$zero
   jal updatecircle
   jal updateCirclePosition
   j exitmoving
movedown:
   lw $s3,circleDown #huong xuong
   add $a0,$s3,$zero
   jal updatecircle
   jal updateCirclePosition
   j exitmoving
moveleft:
   lw $s3,circleLeft #huong sang trai
   add $a0,$s3,$zero
   jal updatecircle
   jal updateCirclePosition
   j exitmoving
moveright:
   lw $s3,circleRight #huong sang phai
   add $a0,$s3,$zero
   jal updatecircle
   jal updateCirclePosition
   j exitmoving
exitmoving:
   li $k1, 0xFFFF0000
   lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
   beq $t1, $zero, thaotacgame
   j tangvantoc
tangvantoc: #tang van toc neu co nut dc an li`
   beq $s1,119,input1 # "w"
   beq $s1,115,input2 #"s"
   beq $s1,97,input3 #"a"
   beq $s1,100,input4
speedupup:
   bgt $s0,40,Up  #neu van toc =40 thi khong giam nua 
   j moveup
Up:
   subi $s0,$s0,40#speedup bang cach giam thoi gian sleep di 40ms
   j moveup
speedupdown:
   bgt $s0,40,Down #neu van toc =40 thi khong giam nua 
   j movedown
Down:
   subi $s0,$s0,40#speedup bang cach giam thoi gian sleep di 40ms
   j movedown
speedupleft:
   bgt $s0,40,Left #neu van toc =40 thi khong giam nua 
   j moveleft
Left:
   subi $s0,$s0,40#speedup bang cach giam thoi gian sleep di 40ms
   j moveleft
speedupright:
   bgt $s0,40,Right #neu van toc =40 thi khong giam nua 
   j moveright
Right:
   subi $s0,$s0,40#speedup bang cach giam thoi gian sleep di 40ms
   j moveright
input1:
   lw $s1,0xffff0004
   addi $v0,$zero,32
   addi $a0,$zero,1
   syscall
   beq $s1,119,speedupup # "w"
   li $s0,400 #neu khong trung voi nut trc do reset lai van toc  400ms
   beq $s1,100,moveright #ma ascii cua cac chu cai lan luot la "d"
   beq $s1,97,moveleft #"a"

   beq $s1,115,movedown #"s"
input2:
   lw $s1,0xffff0004
   addi $v0,$zero,32
   addi $a0,$zero,1
   syscall
   beq $s1,115,speedupdown #"s"
   li $s0,400#neu khong trung voi nut trc do reset lai van toc  400ms
   beq $s1,100,moveright #ma ascii cua cac chu cai lan luot la "d"
   beq $s1,97,moveleft #"a"
   beq $s1,119,moveup # "w"

input3:

   lw $s1,0xffff0004
   addi $v0,$zero,32
   addi $a0,$zero,1
   syscall
   beq $s1,97,speedupleft #"a"
   li $s0,400#neu khong trung voi nut trc do reset lai van toc  400ms
   beq $s1,100,moveright #ma ascii cua cac chu cai lan luot la "d"
   beq $s1,119,moveup # "w"
   beq $s1,115,movedown #"s"
input4:

   lw $s1,0xffff0004
   addi $v0,$zero,32
   addi $a0,$zero,1
   syscall
   beq $s1,100,speedupright #ma ascii cua cac chu cai lan luot la "d"
   li $s0,400#neu khong trung voi nut trc do reset lai van toc  400ms
   beq $s1,97,moveleft #"a"
   beq $s1,119,moveup # "w"
   beq $s1,115,movedown #"s"
updatecircle:
   addiu $sp,$sp,-24 #allocate 24 bytes for stack
   sw $fp,0($sp) #store caller's frame pointer
   sw $ra,4($sp) #store caller's return address
   addiu $fp,$sp,20 #updatecircle frame pointer
   lw $t0,xp # tam x of circle
   lw $t1,yp #tamm y of circle
   lw $t2,xconvert #512
   mult $t1,$t2 # yp *512
   mflo $t3 #yp *512
   add $t3,$t3,$t0 #yp *512+ xp
   lw $t2,yconvert #4
   mult $t3,$t2 # (yp *512+xp)*4
   mflo $t0 #t0=(yp *512+xp)*4
   la $a1,tail
   sw $t0,0($a1)
   la $t1,buffer #screen address
   add $t0,$t1,$t0 #t0=(yp *512+xp)*4 +screen address
   li $t5,31
   li $t6,0x00FFFF00 #yellow
   beq $a0,0x0000FF00,getnextUp #xem huong di de doi chieu neu la canh tren
   beq $a0,0x0100FF00,getnextDown #xem huong di de doi chieu neu la canh duoi
   beq $a0,0x0200FF00,getnextLeft #xem huong di de doi chieu neu la canh trai
   beq $a0,0x0300FF00,getnextRight#xem huong di de doi chieu neu la canh phai
getnextUp:
   addi $t7,$t0,-32768 # pixel phia tren cach 16 don vi pixel 32768/4/512=16
   lw $t8,0($t7)
   beq $t8,0xFF4500,swapVelocityUp #neu mau do thi la border => dao chieu
   j loop
# tuong tu voi 3 huong con lai
getnextDown: 
   addi $t7,$t0,30720
   lw $t8,0($t7)
   beq $t8,0xFF4500,swapVelocityDown
   j loop
getnextLeft:
   addi $t7,$t0,-64
   lw $t8,0($t7)
   beq $t8,0xFF4500,swapVelocityLeft
   j loop
getnextRight:
   addi $t7,$t0,64
   lw $t8,0($t7)
   beq $t8,0xFF4500,swapVelocityRight
   j loop
#star print circle
loop: #hinh tron ban kinh 15 ,in mau cho cac pixel xung quanh cach tam 15 don vi pixel
#ra soat bat dau tu cac diem cach no 15 don vi pixel theo don phuong 1 chieu
   lw $t0,xp
   lw $t1,yp
   addi $t2,$t0,-15
   addi $t3,$t1,-15
   addi $t4,$t1,15
   li $t5,31 #15+15+1

circle: #xet xem toa do cua diem do co nam trong 
   sub $t7,$t2,$t0 #toa do x
   mul $t7,$t7,$t7 #x binh phuong
   sub $t8,$t3,$t1 #toa do y
   mul $t8,$t8,$t8 #y binh phuong
   add $t9,$t7,$t8 #x binh + y binh
   addi $t9,$t9,-225 # 
   bltzal $t9,circle15 # so sanh x binh + y binh voi 225 (15^2) , neu nho hon thi sang buoc tiep theo
   addi $t2,$t2,1 #tang x
   addi $t5,$t5,-1
   beqz $t5,reset
   bnez $t5,circle
reset: #tang y len 1 va dua x ve gia tri ban dau
   li $t5,31
   addi $t2,$t2,-31
   addi $t3,$t3,1
   beq $t3,$t4,sleep
   j circle
circle15: #sau khi xet nam trong vong tron ban kinh 15 thi con phai xet nam ngoai duong tron ban kinh 14
   addi $t9,$t9,29 #15^2-14^2 =29
   bgezal $t9,print # in mau neu thoa man
   addi $t2,$t2,1
   addi $t5,$t5,-1
   j circle
print:
   lw $t7,xconvert #512
   mult $t3,$t7 #512*yp
   mflo $s3
   add $s3,$s3,$t2 #512*yp+xp
   lw $s4,yconvert #4
   mul $s5, $s3,$s4 #(512*yp+xp)*4
   la $s6,buffer #screen address
   add $s5,$s5,$s6 #(512*yp+xp)*4 +screen address
   sw $t6,0($s5) 
   addi $t2,$t2,1
   addi $t5,$t5,-1
   j circle
sleep:
   move $a1,$a0
   addi $v0,$zero,32
   add $a0,$zero,$s0 
   syscall
#end print circle
   move $a0,$a1
#Set velocity
   lw $t2,circleUp 
   beq $a0,$t2,setVelocityUp #if direction and color = circleup => setvelocityup
   lw $t2,circleDown
   beq $a0,$t2,setVelocityDown#if direction and color = circledown => setvelocitydown
   lw $t2,circleLeft
   beq $a0,$t2,setVelocityLeft#if direction and color = circleleft => setvelocityleft
   lw $t2,circleRight
   beq $a0,$t2,setVelocityRight#if direction and color = circleright => setvelocityright
setVelocityUp:
   addi $t5,$zero,0
   addi $t6,$zero,-20 #set velo y 
   sw $t5,xv #update
   sw $t6,yv #update
   j removeCircle 
setVelocityDown:
   addi $t5,$zero,0
   addi $t6,$zero,20 #set velo y 
   sw $t5,xv#update
   sw $t6,yv#update
   j removeCircle
setVelocityLeft:
   addi $t5,$zero,-20 #set velo x
   addi $t6,$zero,0
   sw $t5,xv #update
   sw $t6,yv#update
   j removeCircle
setVelocityRight:
   addi $t5,$zero,20 #set velo x
   addi $t6,$zero,0
   sw $t5,xv #update
   sw $t6,yv #update
   j removeCircle
#doi huong
swapVelocityUp:
   li $t3,0xffff0004 #keyboard
   li $t4,115 #s
   sw $t4,0($t3)
   j movedown
swapVelocityDown:
   li $t3,0xffff0004
   li $t4,119 #w
   sw $t4,0($t3)
   j moveup 
swapVelocityLeft:
   li $t3,0xffff0004
   li $t4,100 #d
   sw $t4,0($t3)
   j moveright
swapVelocityRight:
   li $t3,0xffff0004
   li $t4,97 #a
   sw $t4,0($t3)
   j moveleft
removeCircle: #xoa di de them moi , thay bang mau "den" 
#tuong tu nhu ve hinh tron nhung thay mau vang thanh mau den
   li $t5,31
   li $t6,0x00000000 #black
   lw $t0,xp
   lw $t1,yp
   addi $t2,$t0,-15
   addi $t3,$t1,-15
   addi $t4,$t1,15
circle_r:
   sub $t7,$t2,$t0
   mul $t7,$t7,$t7
   sub $t8,$t3,$t1
   mul $t8,$t8,$t8
   add $t9,$t7,$t8
   addi $t9,$t9,-225
   bltzal $t9,circle15_r
   addi $t2,$t2,1
   addi $t5,$t5,-1
   beqz $t5,reset_r
   bnez $t5,circle_r
reset_r:
   li $t5,31
   addi $t2,$t2,-31
   addi $t3,$t3,1
   beq $t3,$t4,sleep_r
   j circle_r
circle15_r:
   addi $t9,$t9,29
   bgezal $t9,print_r
   addi $t2,$t2,1
   addi $t5,$t5,-1
   j circle_r
print_r:
   lw $t7,xconvert
   mult $t3,$t7
   mflo $s3
   add $s3,$s3,$t2
   lw $s4,yconvert
   mult $s3,$s4
   mflo $s5
   la $s6,buffer
   add $s5,$s5,$s6
   sw $t6,0($s5)
   addi $t2,$t2,1
   addi $t5,$t5,-1
   j circle_r
sleep_r:
   move $a1,$a0
   addi $v0,$zero,32
   addi $a0,$zero,1
   syscall
   move $a0,$a1

exitUpdatecircle:
   lw $ra,4($sp)
   lw $fp,0($sp)
   addiu $sp,$sp,24
   jr $ra
updateCirclePosition:
   addiu $sp,$sp,-24
   sw $fp,0($sp)
   sw $ra,4($sp)
   addiu $fp,$sp,20
   lw $t3,xv
   lw $t4,yv
   lw $t5,xp
   lw $t6,yp
   add $t5,$t5,$t3 #vi tri tiep theo la bang vi tri hien tai + voi xv,yv
   add $t6,$t6,$t4
   sw $t5,xp #cap nhat lai vi tri cua duong tron tiep theo voi xp
   sw $t6,yp #yp tiep theo
   lw $ra,4($sp)
   lw $fp,0($sp)
   addiu $sp,$sp,24
   jr $ra
