# Conversion of RGB888 image to RGB565
# lab03 of MYY505 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

# This directive declares subroutines. Do not remove it!
.globl rgb888_to_rgb565, showImage

.data

image888:  # A rainbow-like image Red->Green->Blue->Red
    .byte 255, 0,     0
    .byte 255,  85,   0
    .byte 255, 170,   0
    .byte 255, 255,   0
    .byte 170, 255,   0
    .byte  85, 255,   0
    .byte   0, 255,   0
    .byte   0, 255,  85
    .byte   0, 255, 170
    .byte   0, 255, 255
    .byte   0, 170, 255
    .byte   0,  85, 255
    .byte   0,   0, 255
    .byte  85,   0, 255
    .byte 170,   0, 255
    .byte 255,   0, 255
    .byte 255,   0, 170
    .byte 255,   0,  85
    .byte 255,   0,   0
# repeat the above 5 times
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0

image565:
    .zero 512  # leave a 0.5Kibyte free space

.text
# -------- This is just for fun.
# Ripes has a LED matrix in I/O tab. To enable it:
# - Go to the I/O tab and double click on LED Matrix.
# - Change the Height and Width (at top-right part of I/O window),
#     to the size of the image888 (6, 19 in this example)
# - This will enable the LED matrix
# - Uncomment the following and you should see the image on the LED matrix!
#    la   a0, image888
#    li   a1, LED_MATRIX_0_BASE
#    li   a2, LED_MATRIX_0_WIDTH
#    li   a3, LED_MATRIX_0_HEIGHT
#    jal  zero, showImage
# ----- This is where the fun part ends!

    la   a0, image888
    la   a3, image565
    li   a1, 19 # width
    li   a2,  6 # height
    jal  ra, rgb888_to_rgb565

    addi a7, zero, 10
    ecall

# ----------------------------------------
# Subroutine showImage
# a0 - image to display on Ripes' LED matrix
# a1 - Base address of LED matrix
# a2 - Width of the image and the LED matrix
# a3 - Height of the image and the LED matrix
# Caution: Assumes the image and LED matrix have the
# same dimensions!
showImage:
    mul  a4, a2,   a3 # size of the image in pixels (width * height)
loopShowImage:
    beq  a4, zero, returnShowImage
    lbu  t0, 0(a0) # get red
    lbu  t1, 1(a0) # get green
    lbu  t2, 2(a0) # get blue
    slli t0, t0,   16  # place red at the 3rd byte of "led" word
    slli t1, t1,   8   #   green at the 2nd
    or   t2, t2,   t1  # combine green, blue
    or   t2, t2,   t0  # Add red to the above
    sw   t2, 0(a1)     # let there be light at this pixel
    addi a0, a0,   3   # move on to the next image pixel
    addi a1, a1,   4   # move on to the next LED
    addi a4, a4,   -1  # decrement pixel counter
    j    loopShowImage
returnShowImage:
    jalr zero, ra, 0
# ----------------------------------------

rgb888_to_rgb565:
# ----------------------------------------
addi sp, sp, -68
sw  a0, 0(sp)
sw  a3, 4(sp)
sw  a1, 8(sp)
sw  a2, 12(sp)
sw  s0, 16(sp)
sw  s1, 20(sp)
sw  s2, 24(sp)
sw  s3, 28(sp)
sw  s4, 32(sp)
sw  s5, 36(sp)
sw  s6, 40(sp)
sw  s7, 44(sp)
sw  s8, 48(sp)
sw  s9, 52(sp)
sw  s10, 56(sp)
sw  s11, 60(sp)
sw  ra, 64(sp)

add s2, zero, zero #arxikopoio ton metriti twn grammwn i
add s3, zero, zero #arxikopoio ton metriti twn stilwn j
addi s4, zero, 248 #se auton ton kataxwriti apothikeuoume ton arithmo me ton opoion tha ektelesoume thn logiki praksi AND gia to red kai blue byte me skopo na kratisoume ta 5 prwta bit kai na midenisoume ta tria teleutaia
addi s5, zero, 224 #se auton ton kataxwriti apothikeuoume ton arithmo me ton opoio tha ektelesoume thn logiki praksi AND gia ta 3 prwta bit pou xreiazomaste apo to green byte me skopo na antikatastisoun ta 0 tou RED
addi s6, zero, 28 # se auton ton kataxwriti apothikeuoume ton arithmo me ton opoio tha ektelesoume thn logiki praksi AND gia na paroume ta tria epomena bit tou green (000g gg00) me skopo na antikatastisoun ta 0 tou blue

loop:
  #R#
  lb s0, 0(a0) #o kataxwritis a0 exei thn dieuthinsi tou prwtou pixel eikonas, fortonoume ston s0 to red byte
  and s1, s0, s4 #edw ginetai i logiki praksi pou anefera parapanw me skopo o kataxwritis s1 na exei ws apotelesma rrrr r000
  #G#
  lb s0, 1(a0) #vazontas to 1(a0) metaferomaste sto epomeno byte dilida sto green, to apothikeuoume ston kataxwriti s7
  and s8, s0, s5 #kanoume thn logiki praksi pou anaferame parapanw me skopo na kratisoume ta tria prwta bits tou green byte kai s8 na isoute me ggg0 0000
  srli s8, s8, 5 #me authn thn entoli metatopizoume ta tria prwta bits 5 theseis deksia gia na dieukolinthoume argotera sthn enwsh red-GREEN
  and s9, s0, s6 #kanoume thn logiki praksi pou anaferame parapanw gia na kratisoume ta epomena tria bits tou green apo auta pou kratisame parapanw kai na midenisoume ta upoloipa
  slli s9, s9, 3 #metatopizoume to apotelesma 3 theseis aristera gia na mas voithisei argotera sthn enwsh green-BLUE

  #B#
  lb s0, 2(a0) #me to 2(a0) metaferomaste sto epomeno byte pou einai to BLUE
  and s7, s0, s4 #kratame ta 5 prwta bits tou blue kai midenizoume ta upoloipa
  srli s7, s7, 3 #metatopizoume auta ta bits 3 theseis deksia gia na einai eukoli i enwsi green-blue epeita

enwsi:
#kanontas or twn kainourgion byte pou dimiourgisame dimiourgoume tis enwseis pou theloume metaksi tvn bits#
  or s10, s1, s8 #edw ginetai h enwsi red-green me teliko apotelesma s10->rrrr rggg
  or s11, s9, s7 #edw ginetai h enwsi green-blue me teliko apotelesma s11-> gggb bbbb
  sb s10, 0(a3) #to 1o byte tou rgb565
  sb s11, 1(a3) #to 2o byte tou RGB565
pixel:
  addi s3, s3, 1 #j++
  bne s3, a1, step #an den einai to j iso me ton arithmo twn sunolikwn stilwn tote metaferomese sto step kai pigainoume sthn epomeni stili
row:
  add s3, zero, zero #sto row mpainoume efoson ston proigoumeno vima to j einai iso me ton arithmo stilwn, midenizoume to j gia na pame sthn epomeni grammia kai na sunexisoume
  addi s2, s2, 1 #i++ pigainoume sthn epomeni grammi
  beq s2, a2, exit #an to i einai iso me ton sunoliko arithmo grammwn tote termatizoume to programma
step:
  addi a0, a0, 3 #to epomeno pixel tou rgb888 vrisketai 3 theseis apo ekei pou deixnei to a0
  addi a3, a3, 2 #to epomeno pixel tou rgb565 tha vrisketai 2 theseis apo ekei pou deixnei arkia o a3
  j loop
exit:
  lw  ra, 64(sp)
  lw  s11, 60(sp)
  lw  s10, 56(sp)
  lw  s9, 52(sp)
  lw  s7, 44(sp)
  lw  s6, 40(sp)
  lw  s5, 36(sp)
  lw  s4, 32(sp)
  lw  s3, 28(sp)
  lw  s2, 24(sp)
  lw  s1, 20(sp)
  lw  s0, 16(sp)
  lw  a2, 12(sp)
  lw  a1, 8(sp)
  lw  a3, 4(sp)
  lw  a0, 0(sp)
  addi sp, sp, 68


jalr zero, ra, 0
