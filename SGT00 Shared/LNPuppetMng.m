//
//  LNPuppetMng.m
//  SGT00
//
//  Created by lunafish on 10/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNPuppetMng.h"
#import "LNPuppet.h"
#import "LNPuppetPlayerCtrl.h"
#import "LNPuppetAICtrl.h"
#import "LNBulletCtrl.h"
#import "LNCubeMng.h"
#import "LNUtil.h"

@interface LNPuppetMng()
{
    LNPuppet* _player; // player puppet for fast search
    SCNNode* _rcsBullet; // Bullet resource
}

@property (strong, nonatomic) NSMutableArray<LNPuppet*>* lstPuppet; // puppet list;

@end

@implementation LNPuppetMng

static LNPuppetMng* _instance = nil;
+ (LNPuppetMng*)instance { @synchronized(self) { return _instance; } }

- (id)init
{
    self = [super init];
    
    _instance = self;
    
    // load tile scn
    SCNScene *scene = [SCNScene sceneNamed:@"Art.scnassets/Puppet.scn"];
    SCNNode *node = [scene.rootNode childNodeWithName:@"puppetBox" recursively:YES ];
    _rcsBullet = [scene.rootNode childNodeWithName:@"bullet" recursively:YES ];
    SCNNode *animnode = [scene.rootNode childNodeWithName:@"animation" recursively:YES ];

    // make puppet list
    _lstPuppet = [[NSMutableArray alloc] init];
    
    // for test
    _player = [self makePuppet:NodeTypePlayer rcs:node animrcs:animnode]; // player
    
    // for test make monster
    LNPuppet* mon = nil;
    mon = [self makePuppet:NodeTypeAI rcs:node animrcs:animnode]; // ai
    mon.name = @"mon001";
    mon = [self makePuppet:NodeTypeAI rcs:node animrcs:animnode]; // ai
    mon.name = @"mon002";
    //[self makePuppet:NodeTypeAI rcs:node animrcs:animnode]; // ai
    //
    
    [self addDelegate];
    
    return self;
}

- (LNPuppet*)makePuppet:(NodeType)type rcs:(SCNNode*)rcs animrcs:(SCNNode*)animrcs
{
    LNPuppet* puppet = [[LNPuppet alloc] init];
    // 1. add delegate
    [puppet addDelegate];
    if(type == NodeTypePlayer)
        [puppet addInpuDelegate]; // player add input delegate
    
    // 2. make ai controller by nodetype
    if(type == NodeTypePlayer) {
        puppet.controller = [[LNPuppetPlayerCtrl alloc] init:puppet];
        puppet.controller.teamType = TeamRed;
    }
    else if(type == NodeTypeAI) {
        puppet.controller = [[LNPuppetAICtrl alloc] init:puppet];
        puppet.controller.teamType = TeamBlue;
    }
    else if(type == NodeTypeBullet) {
        puppet.controller = [[LNBulletCtrl alloc] init:puppet];
        puppet.controller.teamType = TeamRed;
    }
    
    // 3. add puppet list
    [_lstPuppet addObject:puppet];
    
    // 4. copy node resource
    [puppet add:rcs animrcs:animrcs];
    
    // 5. add child node
    [self addChildNode:puppet];
    
    return puppet;
}

- (LNPuppet*)GetNearPuppet:(LNPuppet*)puppet isEnemy:(bool)isEnemy
{
    LNPuppet* ret = nil;
    float len = 10000.0f; // set maximum value
    for(int i = 0; i < _lstPuppet.count; i++)
    {
        // pass hidden puppet
        if(_lstPuppet[i].hidden == YES)
            continue;
        
        // check bullet
        if(_lstPuppet[i].controller.nodeType == NodeTypeBullet)
            continue;
        
        // check myself
        if(_lstPuppet[i] == puppet)
            continue;
        
        
        if(isEnemy) {
            if(_lstPuppet[i].controller.teamType == puppet.controller.teamType)
                continue;
        }
        
        float f = [LNUtil SCNVecLen:puppet.worldPosition v2:_lstPuppet[i].worldPosition];
        if(f < len)
        {
            ret = _lstPuppet[i];
            len = f;
        }
    }
    
    return ret;
}

- (void)update:(NSTimeInterval)time
{

}

- (LNPuppet *)MakeBullet:(nonnull LNPuppet *)owner time:(NSTimeInterval)time {
    LNPuppet* bullet = nil;
    // 1. Find Reserve Bullet
    for(int i = 0; i < _lstPuppet.count; i++) {
        if(_lstPuppet[i].controller == nil)
            continue;
        
        if(_lstPuppet[i].controller.nodeType == NodeTypeBullet && _lstPuppet[i].hidden == YES) {
            bullet = _lstPuppet[i];
            bullet.hidden = NO;
            [bullet.controller initCtrl];
            break;
        }
    }
    
    // 2. No Bullet Find
    if(!bullet) {
        bullet = [self makePuppet:NodeTypeBullet rcs:_rcsBullet animrcs:nil];
    }
    
    // 3. set bullet info
    if(bullet) {
        [bullet fire:owner time:time];
    }
    
    return bullet;
}

- (nonnull LNPuppet *)CheckCrash:(nonnull LNPuppet *)owner bound:(float)bound { 
    LNPuppet* puppet = [self GetNearPuppet:owner isEnemy:YES];
    if(puppet != nil)
    {
        float f = [LNUtil SCNVecLen:puppet.worldPosition v2:owner.worldPosition]; // get length from target
        
        if(f < bound) {
            return puppet;
        }
    }
    return nil;
}

@end
