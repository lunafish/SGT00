//
//  LNUtil.h
//  SGT00
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SceneKit/SceneKit.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNUtil : NSObject

+ (float)tileSize;
+ (float)moveLength;
+ (NSInteger)mapSize;
+ (void)scaleCGPoint:(CGPoint*)start end:(CGPoint*)end lengh:(float)length;
// transform
+ (void)rotateYAxis:(simd_float3)look direction:(simd_float3*)direction;
+ (float)angleYAxis:(simd_float3)direction;
+ (float)angleYAxis2Vec:(simd_float3)v1 v2:(simd_float3)v2;
+ (simd_float3)dir2Vec:(simd_float3)v1 v2:(simd_float3)v2;
// vector
+ (float)SCNVecLen:(SCNVector3)v1 v2:(SCNVector3)v2;

@end

NS_ASSUME_NONNULL_END
