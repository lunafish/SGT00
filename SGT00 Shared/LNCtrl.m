//
//  LNCtrl.m
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNCtrl.h"
#import "LNPuppetMng.h"
#import "LNPuppet.h"

@implementation LNCtrl

- (id)init:(LNNode*)viewNode
{
    self = [super init];
    
    _viewNode = viewNode;
    _teamType = TeamNone;
    _puppetNode = (LNPuppet*)viewNode;
    
    return self;
}

- (NodeType)nodeType {
    return NodeTypeNone;
}

- (TeamType)teamType {
    return _teamType;
}

- (void)initCtrl {
    
}

- (void)crashed:(LNPuppet*)puppet
{
    
}

- (void)damaged:(LNPuppet*)puppet
{
    
}

- (bool)checkFriend {
    if(LNPuppetMng.instance.player.controller.teamType == _teamType)
        return YES;
    
    return NO;
}

// data delegate
- (float)HP {
    return 0;
}

- (float)MP {
    return 0;
}

@end
