//
//  LNPuppetPlayerCtrl.m
//  SGT00
//
//  Created by lunafish on 24/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNPuppetPlayerCtrl.h"
#import "LNPuppet.h"
#import "LNUtil.h"
#import "LNPuppetMng.h"

@interface LNPuppetPlayerCtrl()
{
    SCNNode* _camera; // current camera
    CGPoint _movement; // movement point (in screen)
    bool _move; // move flag
    
    float _fireDelta;
    float _fireDelay;
}

@end

@implementation LNPuppetPlayerCtrl

- (id)init:(LNNode*)viewNode
{
    self = [super init:viewNode];
    
    _move = false;
    
    self.puppetNode = (LNPuppet*)viewNode; // convert pointer
    self.puppetNode.delegate = self; // update delegate
    self.puppetNode.inputDelegate = self; // input delegate
    
    _fireDelay = 1.f;
    _fireDelta = 0.f;
    
    // test
    self.puppetNode.simdPosition = simd_make_float3(0.0f, 0.0f, 5.0f);
    // get foot postion
    [self.puppetNode warp:self.puppetNode.simdPosition];
    //
    
    _hp = 100;
    _mp = 100;
    _bulletType = BulletMelee;
    _bulletDamage = 0;
    
    return self;
}

- (NodeType)nodeType
{
    return NodeTypePlayer;
}

- (void)moveNodesAtPoint:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement
{
    _move = YES;
    _movement = movement;
}

- (void)releaseNodesAtPoint:(CGPoint)point
{
    _move = NO;
}

- (void)update:(NSTimeInterval)time delta:(float)delta
{
    [super update:time delta:delta];
    if(![self AutoAttack:time delta:delta])
        [self move:time delta:delta];
}

- (bool)AutoAttack:(NSTimeInterval)time delta:(float)delta {
    _fireDelta += delta;
    
    LNPuppet* puppet = [LNPuppetMng.instance GetNearPuppet:self.puppetNode isEnemy:YES];
    if(puppet != nil && puppet.controller.nodeType == NodeTypeEnemy) {
        float f = [LNUtil SCNVecLen:self.puppetNode.worldPosition v2:puppet.worldPosition];
        if(f < 5) {
            if(_fireDelta > _fireDelay) {
                _fireDelta = 0.f;
                // 1. look
                [self.puppetNode look:puppet.simdWorldPosition];
                // 2. animation
                [self.puppetNode playAnim:PUPPETATTACK];
                // 3. make bullet
                [LNPuppetMng.instance MakeBullet:self.puppetNode time:time];
            }
        }
    }
    
    return NO;
}

- (void)move:(NSTimeInterval)time delta:(float)delta {
    if(!_move) {
        return;
    }
    
    // find camera
    _camera = [self.puppetNode.sceneRenderer.scene.rootNode childNodeWithName:@"camera" recursively:YES];
    
    // 1. convert movement 2d to 3d
    simd_float3 v = simd_make_float3(_movement.x, 0.0f, -_movement.y);
    
    // 2. rotate movement to camera axis
    [LNUtil rotateYAxis:_camera.simdWorldFront direction:&v];
    
    // 3. move puppet
    if([self.puppetNode move:v])
    {
        // 4. look move direction
        [self.puppetNode lookdir:v];
    }
}

- (void)damaged:(LNPuppet *)puppet {
    _hp -= 1;
    if(_hp < 0) {
        _hp = 0;
    }
}

- (float)HP {
    return _hp;
}

- (float)MP {
    return _mp;
}

@end
