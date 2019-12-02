//
//  LNBTTaskFind.m
//  SGT00
//
//  Created by lunafish on 2019/11/24.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBTTaskFind.h"
#import "LNPuppet.h"
#import "LNPuppetMng.h"
#import "LNUtil.h"
#import "LNCtrl.h"
#import "LNBlackboard.h"

@interface LNBTTaskFind()
{
    float _delta;
    float _delay;
}

@end

@implementation LNBTTaskFind

- (id)init {
    self = [super init];
    
    // look time
    _delay = 0.25f;
    
    return self;
}

- (bool)add:(id)node {
    return NO;
}

- (bool)remove:(id)node {
    return NO;
}

- (BTTaskType)run:(LNCtrl*)ctrl {
    [self log];
    
    _delta = 0.f;
    
    return BTTaskProcess;
}

- (BTTaskType)process:(LNCtrl*)ctrl delta:(float)delta {
    [self log];
    
    // find near puppet
    LNPuppet* puppet = [LNPuppetMng.instance GetNearPuppet:ctrl.puppetNode isEnemy:YES];
    if([ctrl nodeType] == NodeTypeBot) {
        if(puppet == nil) {
            puppet = LNPuppetMng.instance.player;
        } else {
            float f = [LNUtil SCNVecLen:LNPuppetMng.instance.player.worldPosition v2:ctrl.puppetNode.worldPosition];
            if(f > 10.f) {
                puppet = LNPuppetMng.instance.player;
            }
        }
    }
    
    // set target puppet to blackboard
    LNBlackboard* blackboard = ctrl.blackBoard;
    if(blackboard != nil) {
        blackboard.tagetPuppet = puppet;
    }
    
    if(puppet != nil)
    {
        float f = [LNUtil SCNVecLen:puppet.worldPosition v2:ctrl.puppetNode.worldPosition]; // get length from target
        
        if(f < 12.0f || ctrl.nodeType == NodeTypeFriend) {
            [ctrl.puppetNode look:puppet.simdPosition]; // lookat target
            _delta += delta;
            if(_delta > _delay) {
                return BTTaskSuccess;
            }
            return BTTaskProcess;
        }
        else {
            return BTTaskFailed;
        }
    }

    return BTTaskFailed;
}

- (void)log {
    //NSLog(@"TaskFind");
}

@end
