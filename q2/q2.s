.section .data
fmt: .string "%d "
newline: .string "\n"

.section .text
.globl main 

main:
                                
    addi sp, sp, -56            #not using t0-t2 - might get wiped out by printf etc
    sd ra, 48(sp)
    sd s0, 40(sp)
    sd s1, 32(sp)
    sd s2, 24(sp)
    sd s3, 16(sp)       
    sd s4, 8(sp)
    sd s5, 0(sp)

    addi s3, a0, -1             # n = argc - 1, s3 = n
    beq s3, x0, exit

    mv s5, a1                   # s5 = argv (store pointer)

    slli a0, s3, 3              # malloc arr
    call malloc
    mv s0, a0                   # s0 -> arr[]

    slli a0, s3, 3              # malloc result arr. After call malloc, a0 gets overwritten (return pointer), so we recompute n * 8 each time
    call malloc
    mv s1, a0                   # s1 -> result[]

    slli a0, s3, 3              # malloc stack
    call malloc
    mv s2, a0                   # s2 -> stack[]

    addi s4, x0, 0              # s4 = i = 0


convert:
    bge s4, s3, init_result     #if i>=n

    addi t3, s4, 1              # t3 = i+1
    slli t3, t3, 3
    add t3, s5, t3              # t3 = &argv[i+1]
    ld a0, 0(t3)
    call atoi                   #result in a0

    slli t3, s4, 3
    add t3, s0, t3              # t3=&arr[i]
    sd a0, 0(t3)

    addi s4, s4, 1              # i++
    j convert


init_result:                    # initialize result arr to -1
    addi s4, x0, 0              # i = 0
    addi t4, x0, -1             # t4 = -1

init_result_loop:
    bge s4, s3, solve           # if i>=n jump to solve
    slli t3, s4, 3
    add t3, s1, t3              # t3 = &result[i]
    sd t4, 0(t3)                # result[i] = -1
    addi s4, s4, 1              # i++
    j init_result_loop


solve:
    addi t5, x0, -1             # t5 = top = -1
    addi s4, s3, -1             # i = n-1


outer:
    blt s4, x0, print           # if i<0 print ans

    slli t3, s4, 3
    add t3, s0, t3              # t3 = &arr[i]
    ld t4, 0(t3)                # t4 = arr[i]


while:
    blt t5, x0, while_done      # if top < 0

    slli t6, t5, 3
    add t6, s2, t6              # t6 = &stack[top]
    ld t3, 0(t6)                # t3 = stack[top]

    slli t6, t3, 3
    add t6, s0, t6              # t6 = &arr[stack[top]]
    ld t6, 0(t6)                # t6 = arr[stack[top]]

    bgt t6, t4, while_done      # if .. ans found

    addi t5, t5, -1             # else top-- and loop
    j while


while_done:
    blt t5, x0, skip            # if top < 0

    slli t6, t5, 3
    add t6, s2, t6
    ld t3, 0(t6)                # t3 = stack[top]

    slli t6, s4, 3
    add t6, s1, t6              # t6 = &result[i]
    sd t3, 0(t6)                # result[i] = t3 = stack[top]

skip:
    addi t5, t5, 1              # top++
    slli t6, t5, 3
    add t6, s2, t6              # t6 = &stack[top]
    sd s4, 0(t6)                # stack[top] = i

    addi s4, s4, -1             # i--
    j outer


print:
    addi s4, x0, 0              # i = 0

print_loop:
    bge s4, s3, end             # if i>=n

    slli t3, s4, 3
    add t3, s1, t3              # t3 = &result[i]
    ld a1, 0(t3)                # a1 = result[i]

    la a0, fmt
    call printf

    addi s4, s4, 1              # s4++
    j print_loop


end:
    la a0, newline
    call printf
    j exit


exit:
    ld ra, 48(sp)
    ld s0, 40(sp)
    ld s1, 32(sp)
    ld s2, 24(sp)
    ld s3, 16(sp)       
    ld s4, 8(sp)        
    ld s5, 0(sp)
    addi sp, sp, 56
    addi a0, x0, 0              # ret 0
    ret
    