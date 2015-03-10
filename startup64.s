.global _Reset
_Reset:
    ldr x30, =stack_top	// setup stack
    mov sp, x30
    bl c_entry
    b .
