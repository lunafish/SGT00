//
//  LNBTTaskSequence.m
//  SGT00
//
//  Created by lunafish on 2019/11/21.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNBTTaskSequence.h"

@interface LNBTTaskSequence()
{
    id<LNBTDelegate> _task;
    BTTaskType _taskState;
    int _count;
}

@end

@implementation LNBTTaskSequence

- (id)init {
    self = [super init];
    
    _Sequence = [[NSMutableArray alloc] init];
    _task = nil;
    _count = 0;
    
    return self;
}

- (bool)add:(id)node {
    [_Sequence addObject:node];
    return YES;
}

- (bool)remove:(id)node {
    [_Sequence removeObject:node];
    return YES;
}

- (BTTaskType)run:(LNCtrl*)ctrl {
    if(_Sequence.count == 0) {
        return BTTaskFailed;
    }
 
    _count = 0;
    _task = _Sequence[_count];
    
    if(_task == nil) {
        return BTTaskFailed;
    }
    
    _taskState = [_task run:ctrl];
    
    return BTTaskProcess;
}

- (BTTaskType)process:(LNCtrl*)ctrl delta:(float)delta {
    if(_taskState == BTTaskProcess) {
        _taskState = [_task process:ctrl delta:delta];
        return BTTaskProcess;
    }
    else if(_taskState == BTTaskFailed)
    {
        return BTTaskFailed;
    }
    else {
        _count++;
        if(_count < _Sequence.count)
        {
            _task = _Sequence[_count];
            _taskState = [_task run:ctrl];
            return BTTaskProcess;
        }
    }
    
    return BTTaskSuccess;
}

- (void)log {
    //NSLog(@"TaskSequence");
}

@end
