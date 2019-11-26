//
//  LNUtil.m
//  SGT00
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNUtil.h"
#import <GLKit/GLKit.h>

@implementation LNUtil

static float _tileSize = 12.0f;
+ (float) tileSize { @synchronized(self) { return _tileSize; } }

static float _moveLength = 0.15f;
+ (float) moveLength { @synchronized(self) { return _moveLength; } }

static NSInteger _maxSize = 64;
+ (NSInteger) mapSize { @synchronized(self) {return _maxSize; } }

+ (void)scaleVector2:(GLKVector2*)start end:(GLKVector2*)end length:(float)length
{
    GLKVector2 v = GLKVector2Subtract(*end, *start);
    if(GLKVector2Length(v) > length)
    {
        v = GLKVector2Normalize(v);
        end->x = v.x * length + start->x;
        end->y = v.y * length + start->y;
    }
}

+ (void)scaleCGPoint:(CGPoint*)start end:(CGPoint*)end lengh:(float)length
{
    GLKVector2 s = GLKVector2Make(start->x, start->y);
    GLKVector2 e = GLKVector2Make(end->x, end->y);
    
    [self scaleVector2:&s end:&e length:length];
    end->x = e.x;
    end->y = e.y;
}

+ (void)rotateYAxis:(simd_float3)look direction:(simd_float3*)direction
{
    // get camear rotation
    look.y = 0.0f;
    float angle = [LNUtil angleYAxis:look]; // local rotate y
    
    GLKQuaternion q = GLKQuaternionMakeWithAngleAndAxis(angle, 0.0f, 1.0f, 0.0f); // rotate y axis
    
    GLKVector3 v = GLKVector3Make(direction->x, 0.0f, direction->z);
    v = GLKQuaternionRotateVector3(q, v);
    
    direction->x = v.x;
    direction->y = v.y;
    direction->z = v.z;
}

+ (float)angleYAxis:(simd_float3)direction
{
    float angle = atan2(-direction.x, -direction.z); // not use y
    return angle;
}

+ (float)angleYAxis2Vec:(simd_float3)v1 v2:(simd_float3)v2
{
    /*
     dot = x1*x2 + y1*y2      # dot product between [x1, y1] and [x2, y2]
     det = x1*y2 - y1*x2      # determinant
     angle = atan2(det, dot)
     */
    float dot = (v1.x * v2.x) + (v1.z * v2.z);
    float det = (v1.x * v2.y) - (v1.z * v2.x);
    
    float angle = atan2(det, dot);
    
    return angle;
}

+ (simd_float3)dir2Vec:(simd_float3)v1 v2:(simd_float3)v2
{
    GLKVector3 v = GLKVector3Normalize(GLKVector3Subtract(GLKVector3Make(v1.x, v1.y, v1.z), GLKVector3Make(v2.x, v2.y, v2.z)));
    return simd_make_float3(v.x, v.y, v.z);
}

// SCNVector math function
+ (float)SCNVecLen:(SCNVector3)v1 v2:(SCNVector3)v2
{
    return GLKVector3Length(GLKVector3Subtract(GLKVector3Make(v1.x, v1.y, v1.z), GLKVector3Make(v2.x, v2.y, v2.z)));
}



@end
