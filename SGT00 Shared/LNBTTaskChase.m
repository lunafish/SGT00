//
//  LNBTTaskChase.m
//  SGT00
//
//  Created by lunafish on 2019/11/21.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBTTaskChase.h"
#import "LNCtrl.h"
#import "LNPuppet.h"
#import "LNUtil.h"
#import "LNBlackboard.h"

@interface LNBTTaskChase()
{
    float _delta;
    float _delay;
    LNPuppet* _puppet; // target
}

@end

@implementation LNBTTaskChase

- (id)init {
    self = [super init];
    
    _delay = 1.f;
    
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
        return BTTaskFailed;
    
    return BTTaskProcess;
}

- (BTTaskType)process:(LNCtrl*)ctrl delta:(float)delta {
    [self log];
    
    float f = [LNUtil SCNVecLen:_puppet.worldPosition v2:ctrl.puppetNode.worldPosition];
    
    if(f < 5.f && [ctrl checkFriend])
        return BTTaskSuccess;
    
    _delta += delta;
    if(_delta < _delay) {
        simd_float3 dir = ctrl.puppetNode.simdWorldFront;
        [ctrl.puppetNode move:dir];
        
        return BTTaskProcess;
    }

    return BTTaskSuccess;
}

- (void)log {
    //NSLog(@"TaskChase");
}

@end
