//
//  LNPuppetAICtrl.m
//  SGT00
//
//  Created by lunafish on 24/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNPuppetAICtrl.h"
#import "LNPuppet.h"
#import "LNCubeMng.h"
#import "LNPuppetMng.h"
#import "LNUIMng.h"
#import "LNUtil.h"
#import "GameController.h"
// BT
#import "LNBTCtrl.h"
#import "LNBTTaskChase.h"
#import "LNBTTaskSequence.h"
#import "LNBTTaskFind.h"
#import "LNBTTaskAttack.h"
#import "LNBlackboard.h"
//

@interface LNPuppetAICtrl()
{
    LNBTCtrl* _btctrl;
    LNBlackboard* _blackboard;
    bool _btloof;
}

@end

@implementation LNPuppetAICtrl

- (id)init:(LNNode*)viewNode
{
    self = [super init:viewNode];
    
    self.puppetNode = (LNPuppet*)viewNode;
    self.puppetNode.delegate = self;
    self.puppetNode.speed = 1.0f;
    
    // bt
    [self initBT];
    
    // test
    self.puppetNode.simdPosition = simd_make_float3(-15.0f + (rand() % 5) * 5, 0.0f, -5.0f);
    // get foot postion
    [self.puppetNode warp:self.puppetNode.simdPosition];
    //
    
    return self;
}

- (void)initCtrl {
    if(self.nodeType == NodeTypeEnemy) {
        _bulletType = BulletMelee;
        _bulletDamage = 0;
        _hp = 100;
    }
    else if(self.nodeType == NodeTypeBot) {
        _bulletType = BulletRange;
        _bulletDamage = 0;
    }
}

- (void)update:(NSTimeInterval)time delta:(float)delta
{
    [super update:time delta:delta];
    
    if([self.puppetNode isCrash] == YES) {
        return;
    }
    
    if(_btctrl.taskType == BTTaskNone) {
        [_btctrl run:self];
    } else if(_btctrl.taskType == BTTaskProcess) {
        [_btctrl process:self delta:delta];
    }
    else {
        if(_btloof == true) {
            _btctrl.taskType = BTTaskNone;
        }
    }
}

- (LNBlackboard*)blackBoard {
    return _blackboard;
}

- (void)initBT {
    _btloof = true;
    // 1. make bt ctrl
    _btctrl = [[LNBTCtrl alloc] init];
    // 2. sequence node set root
    _btctrl.root = [[LNBTTaskSequence alloc] init];
    // 3. node set : find -> attack -> chase
    [_btctrl.root add:[[LNBTTaskFind alloc] init]];
    [_btctrl.root add:[[LNBTTaskAttack alloc] init]];
    [_btctrl.root add:[[LNBTTaskChase alloc] init]];
    // 4. make blackboard
    _blackboard = [[LNBlackboard alloc] init];

}

- (void)crashed:(LNPuppet*)puppet
{
    [self.puppetNode knockback];
}


- (void)damaged:(LNPuppet*)puppet
{
    // look damage dir
    [self.puppetNode look:puppet.simdWorldPosition];
    [self.puppetNode knockback];
    
    // calc damage
    _hp -= 10;
    if(_hp < 0)
    {
        [self.puppetNode reserve];
        _hp = 0;
    }
    
    SCNVector3 v = [GameController.instance.sceneRenderer projectPoint:self.puppetNode.worldPosition];
    [LNUIMng.instance speech:[NSString stringWithFormat:@"%@ : %f", self.puppetNode.name, _hp] pos:v];
}

- (void)attack:(LNPuppet *)puppet {
    targetPuppet = puppet;
    [self.puppetNode look:targetPuppet.simdWorldPosition];
    [self.puppetNode playAnim:PUPPETATTACK];
}

- (void)endAttack {
    [LNPuppetMng.instance MakeBullet:self.puppetNode time:_currentTime];
}

@end
