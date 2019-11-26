//
//  LNCtrl.m
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNCtrl.h"

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

@end
