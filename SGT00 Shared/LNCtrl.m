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

@interface LNCtrl()
{
    NodeType _nodeType;
    TeamType _teamType;    
}

@end


@implementation LNCtrl

- (id)init:(LNNode*)viewNode
{
    self = [super init];
    
    _viewNode = viewNode;
    _teamType = TeamNone;
    _nodeType = NodeTypeNone;
    _puppetNode = (LNPuppet*)viewNode;
    _bulletType = BulletRange;
    _bulletDamage = 0;
    
    return self;
}

- (void)update:(NSTimeInterval)time delta:(float)delta
{
    _currentTime = time;
}

- (NodeType)nodeType {
    return _nodeType;
}

- (TeamType)teamType {
    return _teamType;
}

- (void)setNodeType:(NodeType)type {
    _nodeType = type;
}

- (void)setTeamType:(TeamType)type {
    _teamType = type;
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

- (void)attack:(LNPuppet *)puppet {
    
}

- (void)endAttack {
    
}

- (void)fire:(LNPuppet*)owner {
    
}

// data delegate
- (float)HP {
    return 0;
}

- (float)MP {
    return 0;
}

- (LNBlackboard*)blackBoard {
    return nil;
}

- (BulletType)bulletType {
    return _bulletType;
}

- (float)bulletDamage {
    return _bulletDamage;
}

- (void)setBulletInfo:(id<LNDdataDelegate>)info {
    _bulletType = info.bulletType;
    _bulletDamage = info.bulletDamage;
}

@end
