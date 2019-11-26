//
//  LNDelegate.h
//  SGT00
//
//  Created by lunafish on 24/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#ifndef LNDelegate_h
#define LNDelegate_h

#include "LNEnum.h"

@class LNCtrl;
@class LNPuppet;
@protocol LNBTDelegate
@required
- (bool)add:(id)node; // add task node
- (bool)remove:(id)node; // remove task node
- (BTTaskType)run:(LNCtrl*)ctrl; // run task
- (BTTaskType)process:(LNCtrl*)ctrl delta:(float)delta; // process task (if task is processing)
@optional
- (void)log;
@end

@protocol LNNodeDelegate
@required
- (NodeType)nodeType;
- (TeamType)teamType;
@optional
- (void)update:(NSTimeInterval)time delta:(float)delta; // update tick
- (void)crashed:(LNPuppet*)puppet;
- (void)damaged:(LNPuppet*)puppet;
@end

@protocol LNNodeInputDelegate
@required
@optional
- (void)moveNodesAtPoint:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement; // move input
- (void)releaseNodesAtPoint:(CGPoint)point; // release input
@end

#endif /* LNDelegate_h */