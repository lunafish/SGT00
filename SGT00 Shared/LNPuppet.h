//
//  LNPuppet.h
//  SGT00
//
//  Created by lunafish on 17/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNPuppet : LNNode

@property (strong, nonatomic) id<LNNodeDelegate> delegate;
@property (strong, nonatomic) id<LNNodeInputDelegate> inputDelegate;
@property (assign, nonatomic) bool checkGround;
@property (assign, nonatomic) float speed;

// init for reuse
- (void)reset;

// add mesh, animation resouce
- (bool)add:(SCNNode*)rcs animrcs:(SCNNode*)animrcs;

// translate
- (bool)move:(simd_float3)postion;
- (bool)warp:(simd_float3)postion;
- (bool)stand;
- (void)look:(simd_float3)postion;
- (void)lookdir:(simd_float3)dir;

// interacton
- (bool)knockback;
- (void)crashed:(LNPuppet*)puppet;
- (void)damaged:(LNPuppet*)puppet;
- (void)fire:(LNPuppet*)owner time:(NSTimeInterval)time;
- (bool)isCrash;
- (void)reserve;

// animation
- (bool)playAnim:(NSString*)key;
- (void)startRootAnim;
- (void)endRootAnim;
- (void)endAttackAnim;

@end

NS_ASSUME_NONNULL_END
