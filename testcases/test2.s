movz r3, #30
movz r4, #1
movz r5, #1
fib:
    cmp r4, r4
    csel r5, r5, r4, eq
    adds r5, r5, r4
    sub r3, r3, #1
    cmp r3, #0
    bg fib
hlt