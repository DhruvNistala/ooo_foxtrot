movz r3, #34
movz r4, #10
write:
    add r4, r4, #10
    sub r3, r3, #1
    cmp r3, #0
    bg write
hlt
