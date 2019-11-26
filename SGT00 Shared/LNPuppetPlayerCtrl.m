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
    
    _fireDelay = 5.0f;
    _fireDelta = 0.f;
    
    // test
    self.puppetNode.simdPosition = simd_make_float3(0.0f, 0.0f, 5.0f);
    // get foot postion
    [self.puppetNode warp:self.puppetNode.simdPosition];
    //
    
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
    [self move:time delta:delta];
    [self fire:time delta:delta];
}

- (void)fire:(NSTimeInterval)time delta:(float)delta {
    _fireDelta += delta;
    if(_fireDelta > _fireDelay) {
        _fireDelta = 0.f;
        [LNPuppetMng.instance MakeBullet:self.puppetNode time:time];
        [self.puppetNode playAnim:PUPPETATTACK];
    }
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

@end
