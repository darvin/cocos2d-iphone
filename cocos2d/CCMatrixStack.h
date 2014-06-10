//
//  CCMatrixStack.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 6/10/14.
//
//

#ifndef __CC_MATRIX_STACK_H
#define __CC_MATRIX_STACK_H

#import <CoreFoundation/CoreFoundation.h>

#import "CCMathTypes.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    /*
     CCMatrixStack is a CFType that allows for the creation of a 4x4 matrix stack similar to OpenGL's matrix
     stack. Any number of matrix stacks can be created and operated on with functions similar to those found
     in fixed function versions of OpenGL.
     */
    
    typedef struct _CCMatrixStack *CCMatrixStackRef;
    
    /*
     CFType CCMatrixStack creation routine. Pass NULL or kCFAllocatorDefault to use the current default
     allocator. A newly created stack is initialized with the identity matrix.
     */
    CCMatrixStackRef CCMatrixStackCreate(CFAllocatorRef alloc);
    
    /*
     Returns the type identifier for the CCMatrixStack opaque type.
     */
    CFTypeID CCMatrixStackGetTypeID(void);
    
    /*
     Pushes all of the matrices down one level and copies the topmost matrix.
     */
    void CCMatrixStackPush(CCMatrixStackRef stack);
    /*
     Pops the topmost matrix off of the stack, moving the rest of the matrices up one level.
     */
    void CCMatrixStackPop(CCMatrixStackRef stack);
    
    /*
     Returns the number of matrices currently on the stack.
     */
    int CCMatrixStackSize(CCMatrixStackRef stack);
    
    /*
     Replaces the topmost matrix with the matrix provided.
     */
    void CCMatrixStackLoadMatrix4(CCMatrixStackRef stack, CCMatrix4 matrix);
    
    /*
     Returns the 4x4 matrix currently residing on top of the stack.
     */
    CCMatrix4 CCMatrixStackGetMatrix4(CCMatrixStackRef stack);
    /*
     Returns the upper left 3x3 portion of the matrix currently residing on top of the stack.
     */
    CCMatrix3 CCMatrixStackGetMatrix3(CCMatrixStackRef stack);
    /*
     Returns the upper left 2x2 portion of the matrix currently residing on top of the stack.
     */
    CCMatrix2 CCMatrixStackGetMatrix2(CCMatrixStackRef stack);
    
    /*
     Calculate and return the inverse matrix from the matrix currently residing on top of stack.
     */
    CCMatrix4 CCMatrixStackGetMatrix4Inverse(CCMatrixStackRef stack);
    /*
     Calculate and return the inverse transpose matrix from the matrix currently residing on top of stack.
     */
    CCMatrix4 CCMatrixStackGetMatrix4InverseTranspose(CCMatrixStackRef stack);
    
    /*
     Calculate and return the upper left 3x3 inverse matrix from the matrix currently residing on top of stack.
     */
    CCMatrix3 CCMatrixStackGetMatrix3Inverse(CCMatrixStackRef stack);
    /*
     Calculate and return the upper left 3x3 inverse transpose matrix from the matrix currently residing on top of stack.
     */
    CCMatrix3 CCMatrixStackGetMatrix3InverseTranspose(CCMatrixStackRef stack);
    
    /*
     Multiply the topmost matrix with the matrix provided.
     */
    void CCMatrixStackMultiplyMatrix4(CCMatrixStackRef stack, CCMatrix4 matrix);
    
    /*
     Multiply the topmost matrix of the stackLeft with the topmost matrix of stackRight and store in stackLeft.
     */
    void CCMatrixStackMultiplyMatrixStack(CCMatrixStackRef stackLeft, CCMatrixStackRef stackRight);
    
    /*
     Translate the topmost matrix.
     */
    void CCMatrixStackTranslate(CCMatrixStackRef stack, float tx, float ty, float tz);
    void CCMatrixStackTranslateWithVector3(CCMatrixStackRef stack, CCVector3 translationVector);
    void CCMatrixStackTranslateWithVector4(CCMatrixStackRef stack, CCVector4 translationVector);
    
    /*
     Scale the topmost matrix.
     */
    void CCMatrixStackScale(CCMatrixStackRef stack, float sx, float sy, float sz);
    void CCMatrixStackScaleWithVector3(CCMatrixStackRef stack, CCVector3 scaleVector);
    void CCMatrixStackScaleWithVector4(CCMatrixStackRef stack, CCVector4 scaleVector);
    
    /*
     Rotate the topmost matrix about the specified axis.
     */
    void CCMatrixStackRotate(CCMatrixStackRef stack, float radians, float x, float y, float z);
    void CCMatrixStackRotateWithVector3(CCMatrixStackRef stack, float radians, CCVector3 axisVector);
    void CCMatrixStackRotateWithVector4(CCMatrixStackRef stack, float radians, CCVector4 axisVector);
    
    /*
     Rotate the topmost matrix about the x, y, or z axis.
     */
    void CCMatrixStackRotateX(CCMatrixStackRef stack, float radians);
    void CCMatrixStackRotateY(CCMatrixStackRef stack, float radians);
    void CCMatrixStackRotateZ(CCMatrixStackRef stack, float radians);
    
#ifdef __cplusplus
}
#endif

#endif /* __CC_MATRIX_STACK_H */
