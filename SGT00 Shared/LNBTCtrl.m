//
//  LNBTCtrl.m
//  SGT00
//
//  Created by lunafish on 2019/11/21.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBTCtrl.h"

@implementation LNBTCtrl

- (id)init {
    self = [super init];
    
    _taskType = BTTaskNone;
    
    return self;
}

- (BTTaskType)run:(nonnull LNCtrl *)ctrl {
    if(_root == nil)
        return BTTaskFailed;
    
    _taskType = [_root run:ctrl];
    return _taskType;
}

- (BTTaskType)process:(nonnull LNCtrl *)ctrl delta:(float)delta {
    _taskType = [_root process:ctrl delta:delta];
    return _taskType;
}

@end
