//
//  CCMatrixStack.m
//  cocos2d-ios
//
//  Created by Oleg Osin on 6/10/14.
//
//

#import "CCMatrixStack.h"

#import "CCMatrix4.h"
#import <string.h>

struct _CCMatrixStackEntry {
    CCMatrix4 mat;
    struct _CCMatrixStackEntry *prev;
};

struct _CCMatrixStack {
    struct _CCMatrixStackEntry *top;
    int depth;
    CFAllocatorRef alloc;
};

/*
 CFType CCMatrixStack creation routine. Pass NULL or kCFAllocatorDefault to use the current default
 allocator. A newly created stack is initialized with the identity matrix.
 */
CCMatrixStackRef CCMatrixStackCreate(CFAllocatorRef alloc) {
    CCMatrixStackRef stack = CFAllocatorAllocate(alloc, sizeof(struct _CCMatrixStack), 0);
    stack->depth = 1;
    
    struct _CCMatrixStackEntry *entry = CFAllocatorAllocate(alloc, sizeof(struct _CCMatrixStackEntry), 0);
    memcpy(&(entry->mat), &CCMatrix4Identity, sizeof(CCMatrix4));
    entry->prev = NULL;
    stack->top = entry;
    
    return stack;
}

/*
 Returns the type identifier for the CCMatrixStack opaque type.
 */
CFTypeID CCMatrixStackGetTypeID(void) {
    return 0;
}

/*
 Pushes all of the matrices down one level and copies the topmost matrix.
 */
void CCMatrixStackPush(CCMatrixStackRef stack) {
    struct _CCMatrixStackEntry *newEntry = CFAllocatorAllocate(stack->alloc, sizeof(struct _CCMatrixStackEntry), 0);
    newEntry->prev = stack->top;
    memcpy(&(newEntry->mat), &(stack->top->mat), sizeof(CCMatrix4));
    
    stack->top = newEntry;
    stack->depth++;
}

/*
 Pops the topmost matrix off of the stack, moving the rest of the matrices up one level.
 */
void CCMatrixStackPop(CCMatrixStackRef stack) {
    struct _CCMatrixStackEntry *top = stack->top;
    stack->top = top->prev;
    stack->depth--;
    CFAllocatorDeallocate(stack->alloc, top);
}

/*
 Returns the number of matrices currently on the stack.
 */
int CCMatrixStackSize(CCMatrixStackRef stack) {
    return stack->depth;
}

/*
 Replaces the topmost matrix with the matrix provided.
 */
void CCMatrixStackLoadMatrix4(CCMatrixStackRef stack, CCMatrix4 matrix) {
    memcpy(&(stack->top->mat), &matrix, sizeof(CCMatrix4));
}

/*
 Returns the 4x4 matrix currently residing on top of the stack.
 */
CCMatrix4 CCMatrixStackGetMatrix4(CCMatrixStackRef stack) {
    return stack->top->mat;
}

/*
 Returns the upper left 3x3 portion of the matrix currently residing on top of the stack.
 */
//CCMatrix3 CCMatrixStackGetMatrix3(CCMatrixStackRef stack);
/*
 Returns the upper left 2x2 portion of the matrix currently residing on top of the stack.
 */
//CCMatrix2 CCMatrixStackGetMatrix2(CCMatrixStackRef stack);

/*
 Calculate and return the inverse matrix from the matrix currently residing on top of stack.
 */
//CCMatrix4 CCMatrixStackGetMatrix4Inverse(CCMatrixStackRef stack);
/*
 Calculate and return the inverse transpose matrix from the matrix currently residing on top of stack.
 */
//CCMatrix4 CCMatrixStackGetMatrix4InverseTranspose(CCMatrixStackRef stack);

/*
 Calculate and return the upper left 3x3 inverse matrix from the matrix currently residing on top of stack.
 */
//CCMatrix3 CCMatrixStackGetMatrix3Inverse(CCMatrixStackRef stack);
/*
 Calculate and return the upper left 3x3 inverse transpose matrix from the matrix currently residing on top of stack.
 */
//CCMatrix3 CCMatrixStackGetMatrix3InverseTranspose(CCMatrixStackRef stack);

/*
 Multiply the topmost matrix with the matrix provided.
 */
//void CCMatrixStackMultiplyMatrix4(CCMatrixStackRef stack, CCMatrix4 matrix);

/*
 Multiply the topmost matrix of the stackLeft with the topmost matrix of stackRight and store in stackLeft.
 */
//void CCMatrixStackMultiplyMatrixStack(CCMatrixStackRef stackLeft, CCMatrixStackRef stackRight);

/*
 Translate the topmost matrix.
 */
void CCMatrixStackTranslate(CCMatrixStackRef stack, float tx, float ty, float tz) {
    stack->top->mat = CCMatrix4Translate(stack->top->mat, tx, ty, tz);
}

//void CCMatrixStackTranslateWithVector3(CCMatrixStackRef stack, CCVector3 translationVector);
//void CCMatrixStackTranslateWithVector4(CCMatrixStackRef stack, CCVector4 translationVector);

/*
 Scale the topmost matrix.
 */
//void CCMatrixStackScale(CCMatrixStackRef stack, float sx, float sy, float sz);
//void CCMatrixStackScaleWithVector3(CCMatrixStackRef stack, CCVector3 scaleVector);
//void CCMatrixStackScaleWithVector4(CCMatrixStackRef stack, CCVector4 scaleVector);

/*
 Rotate the topmost matrix about the specified axis.
 */
void CCMatrixStackRotate(CCMatrixStackRef stack, float radians, float x, float y, float z) {
    stack->top->mat = CCMatrix4Rotate(stack->top->mat, radians, x, y, z);
}

//void CCMatrixStackRotateWithVector3(CCMatrixStackRef stack, float radians, CCVector3 axisVector);
//void CCMatrixStackRotateWithVector4(CCMatrixStackRef stack, float radians, CCVector4 axisVector);

/*
 Rotate the topmost matrix about the x, y, or z axis.
 */
//void CCMatrixStackRotateX(CCMatrixStackRef stack, float radians);
//void CCMatrixStackRotateY(CCMatrixStackRef stack, float radians);
//void CCMatrixStackRotateZ(CCMatrixStackRef stack, float radians);
