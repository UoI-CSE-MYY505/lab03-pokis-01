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
# Ripes has a LED matrix in the I/O tab. To enable it:
# - Go to the I/O tab and double click on LED Matrix.
# - Change the Height and Width (at top-right part of I/O window),
#     to the size of the image888 (6, 19 in this example)
# - This will enable the LED matrix
# - Uncomment the following and you should see the image on the LED matrix!
#    la   a0, image888
#    li   a1, LED_MATRIX_0_BASE
#    li   a2, LED_MATRIX_0_WIDTH
#    li   a3, LED_MATRIX_0_HEIGHT
#    jal  ra, showImage
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
    add  t0, zero, zero # row counter
showRowLoop:
    bge  t0, a3, outShowRowLoop
    add  t1, zero, zero # column counter
showColumnLoop:
    bge  t1, a2, outShowColumnLoop
    lbu  t2, 0(a0) # get red
    lbu  t3, 1(a0) # get green
    lbu  t4, 2(a0) # get blue
    slli t2, t2, 16  # place red at the 3rd byte of "led" word
    slli t3, t3, 8   #   green at the 2nd
    or   t4, t4, t3  # combine green, blue
    or   t4, t4, t2  # Add red to the above
    sw   t4, 0(a1)   # let there be light at this pixel
    addi a0, a0, 3   # move on to the next image pixel
    addi a1, a1, 4   # move on to the next LED
    addi t1, t1, 1
    j    showColumnLoop
outShowColumnLoop:
    addi t0, t0, 1
    j    showRowLoop
outShowRowLoop:
    jalr zero, ra, 0

# ----------------------------------------

rgb888_to_rgb565:
# ----------------------------------------
# My bad try \/ 
#addi t0, zero, 1 # t0 => c
#add  t1, zero, zero # t1 => j
#addi t4, zero, 2 # t4 => 2
#addi t5, zero, 3 # t5 => 3

#for1:
#bge  t1, a2, out
#addi t1, zero, 1
#add  t3, zero, zero # t3 => i
#for2:
#bge  t3, a1, for1
#addi t3, zero, 1
#beq  t0, t4, if1
#beq  t0, t5, if2
#if1:

#if2:
#addi t0, zero, -3
#addi t0, zero, 1

#out:
#-------------------------------------------
    add  t0, zero, zero # row counter
rowl:
    bge  t0, a2, outRowl
    add  t1, zero, zero # column counter
columnl:
    bge  t1, a1, outColumnl
    lhu  t2, 0(a0)
    srli t3, t2, 8  # extract red (3 lsbs still from green)
    andi t3, t3, 0xf8 # clear 3 lsbs
    sb   t3, 0(a3) # store in out image
    srli t3, t2, 3  # extract green (2 lsbs still from blue)
    andi t3, t3, 0xfc # clear 2 lsbs
    sb   t3, 1(a3) # store in out image
    slli t3, t2, 3
    andi t3, t3, 0xf8 # clear 3 lsbs
    sb   t3, 3(a3) # store in out image
    addi a0, a0, 2   # move input pointer to next pixel
    addi a3, a3, 3   # move ouput pointer to next pixel
    addi t1, t1, 1
    j    columnl
outColumnl:
    addi t0, t0, 1
    j    rowl
outRowl:
    jalr zero, ra, 0


