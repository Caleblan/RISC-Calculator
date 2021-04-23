.syntax unified
.section .text

.global add
.global sub
.global multiply
.global divide
.global exponent
.global bitcount
.global summation
.global factorial

@Gets the bounds to check if we went over.
getBounds:
@Gets Max and Min Int values.
LDR r5, =#2147483647
MVN r6, r5
bx lr


@Takes two 32-bit values and adds them together.
add:

PUSH {sp,lr}

bl getBounds

@Checks if secound value is greater than 0
cmp r1, #0
@Stores address to we can return to normal execution after switch registers.
blgt addOverflow
cmp r1, #0
@Stores address to we can return to normal execution after switch registers.
bllt addUnderflow

@Performs addition.
ADD r0, r1
POP {sp, lr}
bx lr

@Checks for overflow with formual:
@value2 > 0 && value1 > INT_MAX - value2
addOverflow:
PUSH {sp, lr}

@ r0 > INT_MAX - r1
SUB r10, r5, r1
cmp r0, r10

@Overflow error if true.
blgt printOverflow
@Will cause function to return to C caller if taken.
POPGT {sp,lr}
POP {sp, lr}
bx lr

@Checks for underflow with formula:
@value2 < 0 && value1 < INT_MIN - value2
addUnderflow:
PUSH {sp, lr}

@ r0 < INT_MIN - r1
SUB r10, r6, r1
cmp r0, r10

@Underflow error if true.
bllt printUnderflow
@Will cause function to return to C caller if taken.
POPLT {sp,lr}

POP {sp, lr}
bx lr



@Takes two 32-bit values and subtracts the first value by the secound value.
sub:

PUSH {sp,lr}

bl getBounds

@Checks if secound value is greater than 0
cmp r1, #0
@Stores address to we can return to normal execution after switch registers.
bllt diffOverflow
cmp r1, #0
@Stores address to we can return to normal execution after switch registers.
blgt diffUnderflow

@Performs addition.
SUB r0, r1
POP {sp, lr}
bx lr

@Checks for overflow with formual:
@value2 < 0 && value1 > INT_MAX + value2
diffOverflow:
PUSH {sp, lr}

@ r0 > INT_MAX + r1
ADD r10, r5, r1
cmp r0, r10

@Overflow error if true.
blgt printOverflow
@Will cause function to return to C caller if taken.
POPGT {sp,lr}
POP {sp, lr}
bx lr


@Checks for underflow with formula:
@value2 > 0 && value1 < INT_MIN + value2
diffUnderflow:
PUSH {sp, lr}

@ r0 < INT_MIN + r1
ADD r10, r6, r1
cmp r0, r10

@Underflow error if true.
bllt printUnderflow
@Will cause function to return to C caller if taken.
POPLT {sp,lr}

POP {sp, lr}
bx lr



@Multiples two 32-bit values together.
multiply:

@Checks for multiplication by 0
@Only done so no error occurs when using divide function as a check.
cmp r0, #0
bxeq lr
cmp r1, #0
MOVEQ r0, #0
bxeq lr

PUSH {sp, lr}

bl getBounds

@Check if value is equal to MIN_INT 
cmp r0, r6
bleq edge1

@Check if value is equal to -1
cmp r0, #-1
bleq edge2

@Stores a 64 bit value.
SMULL r2, r3, r0, r1

@Shifts the high part of value.
ASR r4, r2, #31

cmp r4, r3
blne determineOverflow
MOVEQ r0, r2

POP {sp, lr}
bx lr

@ MIN_INT * -1 -> Overflow
edge1:
PUSH {sp, lr}
cmp r1, #-1
bleq printOverflow
POPEQ {sp, lr}
POP {sp, lr}
bx lr

@ MIN_INT * -1 -> Overflow
edge2:
PUSH {sp, lr}
cmp r1, r6
bleq printOverflow
POPEQ {sp, lr}
POP {sp, lr}
bx lr


@Used to determine if there was under flow or overflow.
determineOverflow:

PUSH {sp, lr}

@Used to keep track of sign
MOV r2, #-1
MOV r3, #1

@Checks if first value is less than 0 to try to keep track odd sign.
cmp r0, #0
@Keeps track if the resultant value will be negative.
MULLT r3, r2

@Checks if second value is less than 0 to try to keep track of sign.
cmp r1, #0
@Keeps track if the resultant value will be negative.
MULLT r3, r2

cmp r3, #0
blgt printOverflow
bllt printUnderflow
POP {sp, lr}
bx lr



@Takes two 32-bit values together and divides first value by secound value.
@Also floors the remainder. Dividing by 0 is handled by C program.
divide:
PUSH {sp,lr}

@Checks if divide by 0
cmp r1, #0
bleq divideError
POPEQ {sp , lr}
bxeq lr

@Gets Max and Min Int values.
bl getBounds

/**
* Checks for the single case in which division can overflow.
* This is where the first value is min int value and divisor
* is -1. Since (INT_MIN / -1) > INT_MAX, there will be overflow.
* */
cmp r0, r6
bleq divideEdge

@Used to store counter of how many times we can subtract.
MOV r2, #0

@Checks for MIN_INT / # since negative.
@Due to implementation, overflow may occur when changing sign
@So do 1 counter and decrease r0 by r1 so overflow won't occur.
cmp r0, r6
bleq special


@Used to check sign of number resultant should be.
MOV r3, #1

@Used by MULLT commands
MOV r4, #-1

@Checks if first value is less than 0 to try to keep track odd sign.
cmp r0, #0
@Keeps track if the resultant value will be negative.
MULLT r3, r4
@Changes sign to work with code. Sign will be applied again later.
MULLT r0, r4

@Checks if second value is less than 0 to try to keep track of sign.
cmp r1, #0
@Keeps track if the resultant value will be negative.
MULLT r3, r4
@Changes sign to work with code. Sign will be applied again later.
MULLT r1, r4

bl divideHelper

@Apply counter from divideHelper.
@bl switchReg
MOV r0, r2

@Apply sign that was calculated earlier.
MUL r0, r3

POP {sp, lr}
bx lr

@Due to implementation, this is placed here so that getting rid of negative
@sign for MIN_INT won't cause overflow when its not supposed to
special:
cmp r1, #0
SUBLT r0, r1
ADDGT r0, r1
@Increments counter.
ADDNE r2, #1

@Special case of MIN_INT / MIN_INT
cmp r1, r6
MOVEQ r0, #1
POPEQ {sp, lr}

bx lr

divideHelper:
@If remainder is less than divider, return since answer will stay 0.
cmp r0, r1
bxlt lr

SUB r0, r1
ADD r2, #1

b divideHelper

@If r0 is MIN_INT value and r1 is -1 special case.
divideEdge:
PUSH {sp, lr}

cmp r1, #-1
bleq printOverflow
POPEQ {sp, lr}

POP {sp, lr}
bx lr



exponent:
PUSH {sp,lr}

bl getBounds

@Return if base is 0, since 0 to power of anything is 0
@Note: 0^0 handled in C program.
cmp r0, #0
cmpeq r1, #0
bleq exponentError
POPEQ {sp, lr}
bxeq lr

@Compare exponent to 0
cmp r1, #0
MOVEQ r0, #1
@Return 0 since floating point numbers are not supported by caluclator.
MOVLT r0, #0
POPLE {sp, lr}
bxle lr

cmp r1, #1

@Stores value of value to be multiplied
MOV r7, r0

bl exponentHelper

POP {sp, lr}
bx lr

exponentHelper:

@Checks if overflow has already occured.
LDR r5, =isError
LDR r6, [r5]
cmp r6, #0
bxgt lr

@If exponent is decremented all the way, return.
cmp r1, #1 
bxeq lr

PUSH {r1, r7, lr}
MOV r1, r7
@Performs single multiplication at this stage.
bl multiply

POP {r1, r7, lr}
@Decrements "exponent counter"
SUB r1, #1

b exponentHelper




bitcount:
PUSH {sp, lr}

@Used as mask to extract one byte at a time.
MOV r3, #1
bl bitcountHelper

@Set return value to number of bits that are 1's containted in parameter.
MOV r0, r2

@Restores the state of caller.
POP {sp, lr}
bx lr

bitcountHelper:
@Once the value we are counting 1 bits has turned to zero, return.
cmp r0, #0
bxeq lr

@Applies mask to bit count value and stores it into r1
AND r1, r0, r3

@Since the mask only allows for 1 bit, add it to counter.
ADD r2, r1

@Shifts the binary parameter by 1 bit.
LSR r0, #1

b bitcountHelper



@Takes two 32-bit values and add all values to 
summation:
PUSH {sp, lr}

bl getBounds

@If first value is smaller than secound, switch the registers.
@This allows for either direction without changing code.
cmp r0, r1
bllt switchRegisters

@Stores first register so we can leave summationHelper
MOV r2, r0

@Saves the link register before calling summationHelper so we can get back.
bl saveState

cmp r1, #0
@Overflow error if true.
blgt addOverflow
cmp r1, #0
bllt addUnderflow

POP {sp, lr}
bx lr

@Swaps values between r0 and r1 so that we only need one helper method rather than two.
switchRegisters:
PUSH {sp, lr}
EOR r0, r0, r1
EOR r1, r0, r1
EOR r0, r0, r1
POP {sp, lr}
bx lr

@Saves the link register before calling summationHelper so we can get back.
saveState:
PUSH {sp, lr}
b summationHelper


@If secound value is negative, then
summationHelper:

@Once secound value is equal to original value of first regsiter, return.
cmp r2, r1
POPEQ {sp, lr}
bxeq lr

@Checks if secound value is greater than 0
cmp r1, #0
@Stores address to we can return to normal execution after switch registers.
blgt sumOverflow
cmp r1, #0
@Stores address to we can return to normal execution after switch registers.
bllt sumUnderflow

@Add the current value to total sum.
ADD r0, r1
@Increments secound value
ADD r1, #1

b summationHelper


@Checks for overflow with formual:
@value2 > 0 && value1 > INT_MAX - value2
sumOverflow:
@ r0 > INT_MAX - r1
SUB r10, r5, r1
cmp r0, r10

@Will cause function to return to C caller if taken.
POPGT {sp,lr}
bx lr

@Checks for underflow with formula:
@value2 < 0 && value1 < INT_MIN - value2
sumUnderflow:

@ r0 < INT_MIN - r1
SUB r10, r6, r1
cmp r0, r10
@Will cause function to return to C caller if taken.
POPLT {sp,lr}

bx lr


@Takes a single 32-bit value within the bounds of 0 <= n < 13.
factorial:
PUSH {sp, lr} 

@Done so multiplication works.
MOV r1, #1

@Return 1 since 0! = 1
cmp r0, #0 
MOVEQ r0, #1
POPEQ {sp, lr}
bxeq lr  

@Returns negative value to C caller so it can tell user that negative factorial is undefined.
cmp r0, #0
MOVLT r0, #-1
POPLT {sp, lr}
bxlt lr

@Prints overflow error to user if r0 > 12.
cmp r0, #12
blgt printOverflow
POPGT {sp, lr}
bxgt lr

bl factorialLoop
MOV r0, r1
POP {sp, lr} 
bx lr 

factorialLoop: 
@Checks if we are at base case of 1. If so, return to caller 
cmp r0, #1 
bxeq lr

@If greater than, subtract one by value and and call function again 
MUL r1, r0
SUB r0, #1
b factorialLoop 




