//
//  LNBTTaskAttack.m
//  SGT00
//
//  Created by lunafish on 2019/12/02.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBTTaskAttack.h"
#import "LNPuppet.h"
#import "LNPuppetMng.h"
#import "LNUtil.h"
#import "LNCtrl.h"
#import "LNBlackboard.h"
#import "LNUIMng.h"

@interface LNBTTaskAttack()
{
    float _delta;
    float _delay;
    LNPuppet* _puppet; // target
}

@end

@implementation LNBTTaskAttack

- (id)init {
    self = [super init];
    
    // look time
    _delay = 0.5f;
    
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
    
    _puppet = ctrl.blackBoard.tagetPuppet;
    if(_puppet == nil)
        return BTTaskSuccess;
    
    if(ctrl.nodeType == NodeTypeBot) {
        if(_puppet.controller.nodeType == NodeTypeEnemy) {
            [ctrl attack:_puppet];
            return BTTaskProcess;
        }
    }
    else if(ctrl.nodeType == NodeTypeEnemy) {
        if(_puppet.controller.nodeType == NodeTypePlayer) {
            float f = [LNUtil SCNVecLen:ctrl.puppetNode.worldPosition v2:_puppet.worldPosition];
            if(f < 5) {
                [ctrl attack:_puppet];
                return BTTaskProcess;
            }
        }
    }
        
    
    return BTTaskSuccess;
}

- (BTTaskType)process:(LNCtrl*)ctrl delta:(float)delta {
    [self log];
    
    _delta += delta;
    if(_delta > _delay) {
        return BTTaskSuccess;
    }

    return BTTaskProcess;
}

- (void)log {
    //NSLog(@"TaskAttack");
}


@end
