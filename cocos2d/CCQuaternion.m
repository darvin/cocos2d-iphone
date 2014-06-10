#import "CCQuaternion.h"

static inline float CCQuaternionDot(CCQuaternion q1, CCQuaternion q2) {
    return (q1.w * q2.w +
            q1.x * q2.x +
            q1.y * q2.y +
            q1.z * q2.z);
}

static inline CCQuaternion CCQuaternionScale(CCQuaternion q1, float s)
{
    CCQuaternion q;
    q.x = q1.x * s;
    q.y = q1.y * s;
    q.z = q1.z * s;
    q.w = q1.w * s;
    return q;
}

__inline__ CCQuaternion CCQuaternionSlerp(CCQuaternion q1, CCQuaternion q2, float t) {
    CCQuaternion q;
    
    if (q1.x == q2.x &&
        q1.y == q2.y &&
        q1.z == q2.z &&
        q1.w == q2.w) {
        
        q.x = q.x;
        q.y = q.y;
        q.z = q.z;
        q.w = q.w;
        
        return q;
    }
    
    float ct = CCQuaternionDot(q1, q2);
    float theta = acosf(ct);
    float st = sqrtf(1.0 - (ct * ct));
    float stt = sinf(t * theta) / st;
    float somt = sinf((1.0 - t) * theta) / st;
    
    CCQuaternion temp, temp2;
    
    temp = CCQuaternionScale(q1, somt);
    temp2 = CCQuaternionScale(q2, stt);
    q = CCQuaternionAdd(temp, temp2);
    
    return q;
}