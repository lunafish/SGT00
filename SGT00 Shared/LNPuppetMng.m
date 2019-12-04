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
#import "LNCtrl.h"

@interface LNPuppetMng()
{
    SCNNode* _rcsPuppet; // Puppet resource
    SCNNode* _rcsPuppetAnim; // Puppet anim resource
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
    
    // make puppet list
    _lstPuppet = [[NSMutableArray alloc] init];
    [self addDelegate];
    
    // spawn
    [self spawnPuppet];
    
    return self;
}

- (void)spawnPuppet {
    // load puppet resouce
    SCNScene *scene = [SCNScene sceneNamed:@"Art.scnassets/Puppet.scn"];
    _rcsPuppet = [scene.rootNode childNodeWithName:@"puppetBox" recursively:YES ];
    _rcsBullet = [scene.rootNode childNodeWithName:@"bullet" recursively:YES ];
    _rcsPuppetAnim = [scene.rootNode childNodeWithName:@"animation" recursively:YES ];

    // player
    _player = [self make:NodeTypePlayer rcs:_rcsPuppet animrcs:_rcsPuppetAnim]; // player
    
    // monster
#if 1
    [self MakePuppet:NodeTypeEnemy name:@"mon01"];
    [self MakePuppet:NodeTypeEnemy name:@"mon02"];
#endif
    //
    
    // Bot
#if 1
    LNPuppet* mon = [self MakePuppet:NodeTypeBot name:@"bot"];
    mon.speed = _player.speed * 0.75f;
    mon.simdWorldPosition = _player.simdWorldPosition - _player.simdWorldFront * 5; // place behind player
#endif
}

- (LNPuppet*)make:(NodeType)type rcs:(SCNNode*)rcs animrcs:(SCNNode*)animrcs
{
    LNPuppet* puppet = [[LNPuppet alloc] init];
    // 1. add delegate
    [puppet addDelegate];
    if(type == NodeTypePlayer)
        [puppet addInpuDelegate]; // player add input delegate
    
    // 2. make ai controller by nodetype
    if(type == NodeTypePlayer) {
        puppet.controller = [[LNPuppetPlayerCtrl alloc] init:puppet];
        [puppet.controller setTeamType:TeamRed];
        [puppet.controller setNodeType:NodeTypePlayer];
    }
    else if(type == NodeTypeEnemy) {
        puppet.controller = [[LNPuppetAICtrl alloc] init:puppet];
        [puppet.controller setTeamType:TeamBlue];
        [puppet.controller setNodeType:NodeTypeEnemy];
    }
    else if(type == NodeTypeFriend) {
        puppet.controller = [[LNPuppetAICtrl alloc] init:puppet];
        [puppet.controller setTeamType:TeamRed];
        [puppet.controller setNodeType:NodeTypeFriend];
    }
    else if(type == NodeTypeEnemy) {
        puppet.controller = [[LNPuppetAICtrl alloc] init:puppet];
        [puppet.controller setTeamType:TeamRed];
        [puppet.controller setNodeType:NodeTypeNPC];
    }
    else if(type == NodeTypeBot) {
        puppet.controller = [[LNPuppetAICtrl alloc] init:puppet];
        [puppet.controller setTeamType:TeamRed];
        [puppet.controller setNodeType:NodeTypeBot];
    }
    else if(type == NodeTypeBullet) {
        puppet.controller = [[LNBulletCtrl alloc] init:puppet];
        [puppet.controller setTeamType:TeamBlue];
        [puppet.controller setNodeType:NodeTypeBullet];
    }
    
    // 3. init ctrl
    [puppet.controller initCtrl];
    
    // 4. add puppet list
    [_lstPuppet addObject:puppet];
    
    // 5. copy node resource
    [puppet add:rcs animrcs:animrcs];
    
    // 6. add child node
    [self addChildNode:puppet];
    
    return puppet;
}

- (LNPuppet*)GetNearPuppet:(LNPuppet*)puppet isEnemy:(bool)isEnemy
{
    LNPuppet* ret = nil;
    float len = INFINITY; // set maximum value
    for(int i = 0; i < _lstPuppet.count; i++)
    {
        // pass hidden puppet
        if(_lstPuppet[i].hidden == YES)
            continue;
        
        // check bullet
        if(_lstPuppet[i].controller.nodeType == NodeTypeBullet || _lstPuppet[i].controller.nodeType == NodeTypeBot)
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

- (nonnull LNPuppet *)MakePuppet:(NodeType)type name:(NSString*)name {
    // not make bullet
    if(type == NodeTypeBullet) {
        return nil;
    }
    LNPuppet* puppet = nil;
    // 1. Find Reuse
    for(int i = 0; i < _lstPuppet.count; i++) {
        if(_lstPuppet[i].controller == nil)
            continue;
        
        if(_lstPuppet[i].controller.nodeType == type && _lstPuppet[i].hidden == YES) {
            puppet = _lstPuppet[i];
            break;
        }
    }
    
    if(!puppet) {
        puppet = [self make:type rcs:_rcsPuppet animrcs:_rcsPuppetAnim];
    }
    
    if(puppet) {
        puppet.name = name;
        puppet.hidden = NO;
        [puppet.controller initCtrl];
    }
    
    return puppet;
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
        bullet = [self make:NodeTypeBullet rcs:_rcsBullet animrcs:nil];
    }
    
    // 3. set bullet info
    if(bullet) {
        // 4. make bullet info
        [bullet.controller setBulletInfo:owner.controller];
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
