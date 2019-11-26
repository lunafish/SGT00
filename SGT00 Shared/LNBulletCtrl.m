//
//  LNBulletCtrl.m
//  SGT00
//
//  Created by lunafish on 2019/11/18.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBulletCtrl.h"
#import "LNPuppet.h"
#import "LNCubeMng.h"
#import "LNPuppetMng.h"

@interface LNBulletCtrl()
{
    float _lifeDelay;
}
@end

@implementation LNBulletCtrl

- (id)init:(LNNode*)viewNode
{
    self = [super init:viewNode];
    
    self.puppetNode = (LNPuppet*)viewNode;
    self.puppetNode.delegate = self;
    self.puppetNode.checkGround = false; // no ground check
    
    // default postion
    self.puppetNode.simdPosition = simd_make_float3(0.0f, 2.0f, 0.0f);
    
    [self initCtrl];
    
    return self;
}

- (void)initCtrl {
    [self.puppetNode reset];
    self.puppetNode.speed = 20.0f;
    _lifeDelay = 3.0f;
}

- (NodeType)nodeType
{
    return NodeTypeBullet;
}

- (void)update:(NSTimeInterval)time delta:(float)delta
{
    if(self.puppetNode.hidden == YES)
        return;
    
    _lifeDelay -= delta;
    if(_lifeDelay < 0.f) {
        [self.puppetNode reserve];
        return;
    }
    
    simd_float3 dir = self.puppetNode.simdWorldFront;
    [self.puppetNode move:dir];
}

- (void)crashed:(LNPuppet*)puppet
{
    [self.puppetNode reserve];
}

@end
