//
//  CCQuaternion.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 6/10/14.
//
//

#ifndef __CC_QUATERNION_H
#define __CC_QUATERNION_H

#include <stddef.h>
#include <math.h>

#import "CCMathTypes.h"

#import "CCVector3.h"
#import "CCVector4.h"

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark -
#pragma mark Prototypes
#pragma mark -
    
    static const CCQuaternion CCQuaternionIdentity = { 0, 0, 0, 1 };
	
    /*
     x, y, and z represent the imaginary values.
     */
    static __inline__ CCQuaternion CCQuaternionMake(float x, float y, float z, float w);
    
    /*
     vector represents the imaginary values.
     */
    static __inline__ CCQuaternion CCQuaternionMakeWithVector3(CCVector3 vector, float scalar);
    
    /*
     values[0], values[1], and values[2] represent the imaginary values.
     */
    static __inline__ CCQuaternion CCQuaternionMakeWithArray(float values[4]);
    
    /*
     Assumes the axis is already normalized.
     */
    static __inline__ CCQuaternion CCQuaternionMakeWithAngleAndAxis(float radians, float x, float y, float z);
    /*
     Assumes the axis is already normalized.
     */
    static __inline__ CCQuaternion CCQuaternionMakeWithAngleAndVector3Axis(float radians, CCVector3 axisVector);
    
    CCQuaternion CCQuaternionMakeWithMatrix3(CCMatrix3 matrix);
    static __inline__ CCQuaternion CCQuaternionMakeWithMatrix4(CCMatrix4 matrix) {
        return CCQuaternionIdentity;
    }
    
    /*
     Calculate and return the angle component of the angle and axis form.
     */
    float CCQuaternionAngle(CCQuaternion quaternion);
    
    /*
     Calculate and return the axis component of the angle and axis form.
     */
    CCVector3 CCQuaternionAxis(CCQuaternion quaternion);
    
    static __inline__ CCQuaternion CCQuaternionAdd(CCQuaternion quaternionLeft, CCQuaternion quaternionRight);
    static __inline__ CCQuaternion CCQuaternionSubtract(CCQuaternion quaternionLeft, CCQuaternion quaternionRight);
    static __inline__ CCQuaternion CCQuaternionMultiply(CCQuaternion quaternionLeft, CCQuaternion quaternionRight);
	
    extern __inline__ CCQuaternion CCQuaternionSlerp(CCQuaternion quaternionStart, CCQuaternion quaternionEnd, float t);
    
    static __inline__ float CCQuaternionLength(CCQuaternion quaternion);
    
    static __inline__ CCQuaternion CCQuaternionConjugate(CCQuaternion quaternion);
    static __inline__ CCQuaternion CCQuaternionInvert(CCQuaternion quaternion);
    static __inline__ CCQuaternion CCQuaternionNormalize(CCQuaternion quaternion);
    
    static __inline__ CCVector3 CCQuaternionRotateVector3(CCQuaternion quaternion, CCVector3 vector);
    void CCQuaternionRotateVector3Array(CCQuaternion quaternion, CCVector3 *vectors, size_t vectorCount);
    
    /*
     The fourth component of the vector is ignored when calculating the rotation.
     */
    static __inline__ CCVector4 CCQuaternionRotateVector4(CCQuaternion quaternion, CCVector4 vector);
    static __inline__ void CCQuaternionRotateVector4Array(CCQuaternion quaternion, CCVector4 *vectors, size_t vectorCount) {
    }
    
#pragma mark -
#pragma mark Implementations
#pragma mark -
    
    static __inline__ CCQuaternion CCQuaternionMake(float x, float y, float z, float w)
    {
        CCQuaternion q = { x, y, z, w };
        return q;
    }
    
    static __inline__ CCQuaternion CCQuaternionMakeWithVector3(CCVector3 vector, float scalar)
    {
        CCQuaternion q = { vector.v[0], vector.v[1], vector.v[2], scalar };
        return q;
    }
    
    static __inline__ CCQuaternion CCQuaternionMakeWithArray(float values[4])
    {
        CCQuaternion q = { values[0], values[1], values[2], values[3] };
        return q;
    }
    
    static __inline__ CCQuaternion CCQuaternionMakeWithAngleAndAxis(float radians, float x, float y, float z)
    {
        float halfAngle = radians * 0.5f;
        float scale = sinf(halfAngle);
        CCQuaternion q = { scale * x, scale * y, scale * z, cosf(halfAngle) };
        return q;
    }
    
    static __inline__ CCQuaternion CCQuaternionMakeWithAngleAndVector3Axis(float radians, CCVector3 axisVector)
    {
        return CCQuaternionMakeWithAngleAndAxis(radians, axisVector.v[0], axisVector.v[1], axisVector.v[2]);
    }
    
    static __inline__ CCQuaternion CCQuaternionAdd(CCQuaternion quaternionLeft, CCQuaternion quaternionRight)
    {
#if defined(__ARM_NEON__)
        float32x4_t v = vaddq_f32(*(float32x4_t *)&quaternionLeft,
                                  *(float32x4_t *)&quaternionRight);
        return *(CCQuaternion *)&v;
#else
        CCQuaternion q = { quaternionLeft.q[0] + quaternionRight.q[0],
            quaternionLeft.q[1] + quaternionRight.q[1],
            quaternionLeft.q[2] + quaternionRight.q[2],
            quaternionLeft.q[3] + quaternionRight.q[3] };
        return q;
#endif
    }
    
    static __inline__ CCQuaternion CCQuaternionSubtract(CCQuaternion quaternionLeft, CCQuaternion quaternionRight)
    {
#if defined(__ARM_NEON__)
        float32x4_t v = vsubq_f32(*(float32x4_t *)&quaternionLeft,
                                  *(float32x4_t *)&quaternionRight);
        return *(CCQuaternion *)&v;
#else
        CCQuaternion q = { quaternionLeft.q[0] - quaternionRight.q[0],
            quaternionLeft.q[1] - quaternionRight.q[1],
            quaternionLeft.q[2] - quaternionRight.q[2],
            quaternionLeft.q[3] - quaternionRight.q[3] };
        return q;
#endif
    }
    
    static __inline__ CCQuaternion CCQuaternionMultiply(CCQuaternion quaternionLeft, CCQuaternion quaternionRight)
    {
        CCQuaternion q = { quaternionLeft.q[3] * quaternionRight.q[0] +
            quaternionLeft.q[0] * quaternionRight.q[3] +
            quaternionLeft.q[1] * quaternionRight.q[2] -
            quaternionLeft.q[2] * quaternionRight.q[1],
            
            quaternionLeft.q[3] * quaternionRight.q[1] +
            quaternionLeft.q[1] * quaternionRight.q[3] +
            quaternionLeft.q[2] * quaternionRight.q[0] -
            quaternionLeft.q[0] * quaternionRight.q[2],
            
            quaternionLeft.q[3] * quaternionRight.q[2] +
            quaternionLeft.q[2] * quaternionRight.q[3] +
            quaternionLeft.q[0] * quaternionRight.q[1] -
            quaternionLeft.q[1] * quaternionRight.q[0],
            
            quaternionLeft.q[3] * quaternionRight.q[3] -
            quaternionLeft.q[0] * quaternionRight.q[0] -
            quaternionLeft.q[1] * quaternionRight.q[1] -
            quaternionLeft.q[2] * quaternionRight.q[2] };
        return q;
    }
    
    static __inline__ float CCQuaternionLength(CCQuaternion quaternion)
    {
#if defined(__ARM_NEON__)
        float32x4_t v = vmulq_f32(*(float32x4_t *)&quaternion,
                                  *(float32x4_t *)&quaternion);
        float32x2_t v2 = vpadd_f32(vget_low_f32(v), vget_high_f32(v));
        v2 = vpadd_f32(v2, v2);
        return sqrt(vget_lane_f32(v2, 0));
#else
        return sqrt(quaternion.q[0] * quaternion.q[0] +
                    quaternion.q[1] * quaternion.q[1] +
                    quaternion.q[2] * quaternion.q[2] +
                    quaternion.q[3] * quaternion.q[3]);
#endif
    }
    
    static __inline__ CCQuaternion CCQuaternionConjugate(CCQuaternion quaternion)
    {
#if defined(__ARM_NEON__)
        float32x4_t *q = (float32x4_t *)&quaternion;
        
        uint32_t signBit = 0x80000000;
        uint32_t zeroBit = 0x0;
        uint32x4_t mask = vdupq_n_u32(signBit);
        mask = vsetq_lane_u32(zeroBit, mask, 3);
        *q = vreinterpretq_f32_u32(veorq_u32(vreinterpretq_u32_f32(*q), mask));
        
        return *(CCQuaternion *)q;
#else
        CCQuaternion q = { -quaternion.q[0], -quaternion.q[1], -quaternion.q[2], quaternion.q[3] };
        return q;
#endif
    }
    
    static __inline__ CCQuaternion CCQuaternionInvert(CCQuaternion quaternion)
    {
#if defined(__ARM_NEON__)
        float32x4_t *q = (float32x4_t *)&quaternion;
        float32x4_t v = vmulq_f32(*q, *q);
        float32x2_t v2 = vpadd_f32(vget_low_f32(v), vget_high_f32(v));
        v2 = vpadd_f32(v2, v2);
        float32_t scale = 1.0f / vget_lane_f32(v2, 0);
        v = vmulq_f32(*q, vdupq_n_f32(scale));
        
        uint32_t signBit = 0x80000000;
        uint32_t zeroBit = 0x0;
        uint32x4_t mask = vdupq_n_u32(signBit);
        mask = vsetq_lane_u32(zeroBit, mask, 3);
        v = vreinterpretq_f32_u32(veorq_u32(vreinterpretq_u32_f32(v), mask));
        
        return *(CCQuaternion *)&v;
#else
        float scale = 1.0f / (quaternion.q[0] * quaternion.q[0] +
                              quaternion.q[1] * quaternion.q[1] +
                              quaternion.q[2] * quaternion.q[2] +
                              quaternion.q[3] * quaternion.q[3]);
        CCQuaternion q = { -quaternion.q[0] * scale, -quaternion.q[1] * scale, -quaternion.q[2] * scale, quaternion.q[3] * scale };
        return q;
#endif
    }
    
    static __inline__ CCQuaternion CCQuaternionNormalize(CCQuaternion quaternion)
    {
        float scale = 1.0f / CCQuaternionLength(quaternion);
#if defined(__ARM_NEON__)
        float32x4_t v = vmulq_f32(*(float32x4_t *)&quaternion,
                                  vdupq_n_f32((float32_t)scale));
        return *(CCQuaternion *)&v;
#else
        CCQuaternion q = { quaternion.q[0] * scale, quaternion.q[1] * scale, quaternion.q[2] * scale, quaternion.q[3] * scale };
        return q;
#endif
    }
    
    static __inline__ CCVector3 CCQuaternionRotateVector3(CCQuaternion quaternion, CCVector3 vector)
    {
        CCQuaternion rotatedQuaternion = CCQuaternionMake(vector.v[0], vector.v[1], vector.v[2], 0.0f);
        rotatedQuaternion = CCQuaternionMultiply(CCQuaternionMultiply(quaternion, rotatedQuaternion), CCQuaternionInvert(quaternion));
        
        return CCVector3Make(rotatedQuaternion.q[0], rotatedQuaternion.q[1], rotatedQuaternion.q[2]);
    }
    
    static __inline__ CCVector4 CCQuaternionRotateVector4(CCQuaternion quaternion, CCVector4 vector)
    {
        CCQuaternion rotatedQuaternion = CCQuaternionMake(vector.v[0], vector.v[1], vector.v[2], 0.0f);
        rotatedQuaternion = CCQuaternionMultiply(CCQuaternionMultiply(quaternion, rotatedQuaternion), CCQuaternionInvert(quaternion));
        
        return CCVector4Make(rotatedQuaternion.q[0], rotatedQuaternion.q[1], rotatedQuaternion.q[2], vector.v[3]);
    }
    
#ifdef __cplusplus
}
#endif

#endif /* __CC_QUATERNION_H */
