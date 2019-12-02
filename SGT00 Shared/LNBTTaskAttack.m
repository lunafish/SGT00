//
//  LNBTTaskAttack.m
//  SGT00
//
//  Created by lunafish on 2019/12/02.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBTTaskAttack.h"

@interface LNBTTaskAttack()
{
    float _delay;
    float _delta;
}

@end

@implementation LNBTTaskAttack

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

    return BTTaskSuccess;
}

- (void)log {
    //NSLog(@"TaskAttack");
}


@end
