.section .text

.globl make_node
.globl insert
.globl get
.globl getAtMost

# using sw and lw for int(4 bytes) and sd and ld for pointers(8 bytes)


# struct Node* make_node(int val)

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sw a0, 0(sp)                        # a0 = val

    li a0, 24                           # size of struct node, pointer to the memory returned in a0
    call malloc

    lw t0, 0(sp)                        # t0 = val 
    sw t0, 0(a0)                        # root->val = val 
    sd x0, 8(a0)                        # root->left = NULL 
    sd x0, 16(a0)                       # root->right = NULL 

    ld ra, 8(sp)
    addi sp, sp, 16
    ret


# struct Node* insert(struct Node* root, int val)
# return: a0 = pointer to root

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd a0, 16(sp)                       # a0 = root pointer
    sw a1, 8(sp)                        # a1 = val

    beq a0, x0, insert_new              # if root == NULL, create node

    lw t0, 0(a0)                        # t0 = root->val 

    blt a1, t0, insert_left

insert_right:
    ld a0, 16(a0)                       # a0 = root->right
    lw a1, 8(sp)                        # a1 = val
    call insert

    ld t2, 16(sp)                       # restore root
    sd a0, 16(t2)                       # root->right = insert()
    mv a0, t2                           # return root
    j insert_done

insert_left:
    ld a0, 8(a0)                        # a0 = root->left
    lw a1, 8(sp)                        # a1 = val
    call insert

    ld t2, 16(sp)                       # restore root
    sd a0, 8(t2)                        # root->left = insert()
    mv a0, t2                           # return root
    j insert_done

insert_new:
    lw a0, 8(sp)                        # a0 = val
    call make_node                      # a0 = make_node(val)

insert_done:
    ld ra, 24(sp)
    addi sp, sp, 32
    ret


# struct Node* get(struct Node* root, int val)
# return: a0 = pointer to node, or 0 if not found

get:
    beq a0, x0, get_not_found           # if(root == NULL) return NULL

    lw t0, 0(a0)                        # t0 = root->val 

    beq t0, a1, get_found
    blt a1, t0, get_left

    ld a0, 16(a0)                       # if(val > root->val) go right
    j get

get_left:
    ld a0, 8(a0)
    j get

get_found:
    ret                                 # a0 contains the root pointer

get_not_found:
    li a0, 0
    ret


# int getAtMost(int val, struct Node* root)
# return: a0 = greatest value in tree <= val, or -1 if none

getAtMost:
    li t0, -1                           # t0 = -1.

getAtMost_loop:
    beq a1, x0, getAtMost_done          # if root == NULL, return

    lw t1, 0(a1)                        # t1 = root->val 

    beq t1, a0, getAtMost_equal         # root->val == val, return val
    bgt t1, a0, getAtMost_left          # root->val > val, go left

    mv t0, t1                           # if root->val < val, t0 = root->val
    ld a1, 16(a1)                       # go right to check
    j getAtMost_loop

getAtMost_left:
    ld a1, 8(a1)                        # go left
    j getAtMost_loop

getAtMost_equal:
    mv a0, t1                           # return ans
    ret

getAtMost_done:
    mv a0, t0                           # return ans
    ret
    