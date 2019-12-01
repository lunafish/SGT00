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
#import "LNUtil.h"
// BT
#import "LNBTCtrl.h"
#import "LNBTTaskChase.h"
#import "LNBTTaskSequence.h"
#import "LNBTTaskFind.h"
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

- (void)update:(NSTimeInterval)time delta:(float)delta
{
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
    // 3. node set
    [_btctrl.root add:[[LNBTTaskFind alloc] init]];
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
    [self.puppetNode knockback];
}

@end
