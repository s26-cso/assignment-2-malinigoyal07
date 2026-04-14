.section .rodata
filename: .string "input.txt"
mode:     .string "r"
yes:      .string "Yes\n"
no:       .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)                   # for file pointer 
    sd s1, 40(sp)                    # left
    sd s2, 32(sp)                    # right


    la a0, filename                 # a0 has pointer to file
    la a1, mode
    call fopen                      # fopen("input.txt", "r") -> returns in a0
    mv s0, a0
    beq s0, x0, print_no            # if file NULL → error


    mv a0, s0
    li a1, 0
    li a2, 2                        # 2 = SEEK_END
    call fseek                      # fseek(file, 0, SEEK_END);

    mv a0, s0
    call ftell                      # returns pos of cursor ie size
    mv s2, a0                       # right = size

    beq s2, x0, print_yes           # empty -> palindrome

    addi s2, s2, -1                 # right = size-1
    li s1, 0                        # left = 0


loop:
    bge s1, s2, print_yes           # if (left >= right)

    mv a0, s0                       # reading left char
    mv a1, s1
    li a2, 0                        # 0 = SEEK_SET
    call fseek

    addi a0, sp, 0                  # buffer = &stack_memory
    li a1, 1
    li a2, 1
    mv a3, s0
    call fread                      # fread(buffer, 1, 1, file);


    mv a0, s0                       # reading right char
    mv a1, s2
    li a2, 0
    call fseek

    addi a0, sp, 8        
    li a1, 1
    li a2, 1
    mv a3, s0
    call fread

    lbu t0, 0(sp)
    lbu t1, 8(sp)
    bne t0, t1, print_no            # str[left] != str[right]

    addi s1, s1, 1                  # left++
    addi s2, s2, -1                 # right--
    j loop


print_yes:
    la a0, yes
    call printf
    j done


print_no:
    la a0, no
    call printf

done:
    mv a0, s0
    call fclose
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    addi sp, sp, 64
    li a0, 0
    ret
