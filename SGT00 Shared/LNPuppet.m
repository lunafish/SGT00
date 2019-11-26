//
//  LNPuppet.m
//  SGT00
//
//  Created by lunafish on 17/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNPuppet.h"
#import "LNUtil.h"
#import "LNCubeMng.h"
#import "LNPuppetPlayerCtrl.h"
#import "LNPuppetMng.h"
#import "LNCtrl.h"

@interface LNPuppet()
{
    NSTimeInterval _lastTime; // last update time
    float _delta; // update delta
    SCNNode* _mesh; // mesh node;
    float _deltaCrash; // hold time for crash
    bool _initFootPos; // init foot position
    
    bool _playRootAni; // root animation playing state : YES is playing root animation
    SCNNode* _puppet; // puppet node;
    simd_float3 _rootPos; // root animation move postion

    // root animation
    SCNNode* _rootAniBone; // root animation bone
    
    // for test
    bool _debugStop;
    float _endAnim;
}

@end

@implementation LNPuppet

- (id)init
{
    self = [super init];
    
    // init value
    _lastTime = 0;
    _checkGround = true;
    _initFootPos = false;
    _delta = 0.0f;
    // test
    _speed = 5.0f; // set speed
    //
    _deltaCrash = 0.0f;
    
    // test
    _endAnim = 0.f;

    return self;
}

- (void)reset {
    _deltaCrash = 0.0f;
}


- (bool)add:(SCNNode*)rcs animrcs:(SCNNode*)animrcs
{
    if(rcs == nil)
        return NO;
    
    // clone resource node
    _mesh = [rcs clone];
    // get puppet node
    _puppet = [_mesh childNodeWithName:PUPPET recursively:YES];
    // get root Ani node
    _rootAniBone = [_mesh childNodeWithName:PUPPETBONE recursively:YES];
    // add child node
    [self addChildNode:_mesh];
    
    // add anims
    if(animrcs)
        [self addAnim:animrcs];

    _debugStop = NO;
    return YES;
}

- (NodeType)nodeType
{
    // return controllers node type
    return [self.controller nodeType];
}

- (bool)doMove:(simd_float3*)pos
{
    // If not check ground return YES
    if(_checkGround == true) {
        // check ground
        if([LNCubeMng.instance getFootPostion:pos] == NO) {
            return NO;
        }
    }
    
    // check crash
    LNPuppet* puppet = [LNPuppetMng.instance CheckCrash:self bound:3.f];
    if(puppet != nil)
    {
        if(self.controller.nodeType == NodeTypeBullet) {
            if(self.controller.teamType != puppet.controller.teamType) {
                [self crashed:puppet];
            }
        }
        else {
            [self crashed:puppet];
            float curLen = simd_distance(puppet.simdWorldPosition, self.simdWorldPosition);
            float tryLen = simd_distance(puppet.simdWorldPosition, *pos);
            
            if(tryLen < curLen) {
                return NO;
            }
        }
    }
    
    self.simdPosition = *pos;
    return YES;
}

- (bool)move:(simd_float3)postion
{
    if(_playRootAni)
        return NO; // root ani playing state
    
    // check crashed
    if(_deltaCrash > 0.f)
        return NO;
    
    simd_float3 mov = self.simdPosition;
    
    // move = current position * time delta(second) * speed
    mov.x += postion.x * _delta * _speed;
    mov.y += postion.y * _delta * _speed;
    mov.z += postion.z * _delta * _speed;
    
    return [self doMove:&mov];
}

- (bool)warp:(simd_float3)postion
{
    if(_playRootAni)
        return NO; // root ani playing state
    
    simd_float3 mov = self.simdPosition;
    
    // move = current position * time delta(second) * speed
    mov.x = postion.x;
    mov.y = postion.y;
    mov.z = postion.z;
    
    return [self doMove:&mov];
}

- (void)look:(simd_float3)postion
{
    if(_playRootAni)
        return; // root ani playing state
    
    // lookat target
    simd_float3 dir = [LNUtil dir2Vec:postion v2:self.simdPosition]; // get direction
    simd_float3 rot = self.simdEulerAngles; // get lookat y angle
    rot.y = [LNUtil angleYAxis:dir];
    self.simdEulerAngles = rot;
}

- (void)lookdir:(simd_float3)dir
{
    // make look dir vector : world position + look vector
    simd_float3 v = simd_make_float3(self.simdWorldPosition.x + dir.x, self.simdWorldPosition.y + dir.y, self.simdWorldPosition.z + dir.z);
    
    [self look:v];
}

- (void)moveNodesAtPoint:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement
{
    // delegate input to controller
    [_inputDelegate moveNodesAtPoint:current start:start movement:movement];
}

- (void)releaseNodesAtPoint:(CGPoint)point
{
    // delegate input to controller
    [_inputDelegate releaseNodesAtPoint:point];
}

- (void)update:(NSTimeInterval)time
{
    // init foot pos
    [self initFootPosition];
    
    // update root ani
    [self updateRootAni];
    
    // make tick : second
    _delta = time - _lastTime;
    _lastTime = time;
    
    if(_deltaCrash > 0.f) {
        _deltaCrash -= _delta;
    }
    
    if(_endAnim > 0.f) {
        _endAnim -= _delta;
        if(_endAnim <= 0.f) {
            [self stop:_puppet key:PUPPETATTACK];
            [self play:_puppet key:PUPPETIDLE];
        }
    }

    // // delegate update to contorller
    [_delegate update:time delta:_delta];
}

// animation

// load animation keys and player by scnnode
- (void)addAnim:(SCNNode*)rcs
{
    SCNAnimationPlayer* player = nil;
    
    // add root ani
    //[self addRootAnim:rcs key:ROOTANI00]; // add ROOTANI00 (short knockback)

    // add idle animation and play
    player = [self addPuppetAnim:rcs key:PUPPETIDLE];
    if(player) {
        player.animation.animationEvents = @[[SCNAnimationEvent animationEventWithKeyTime:0.5 block:^(CAAnimation *animation, id animatedObject, BOOL playingBackward) {
            NSLog(@"idle event");
        }]];
    }
    
    // add attack animation
    player = [self addPuppetAnim:rcs key:PUPPETATTACK];
    if(player)
    {
        // add attack event point
        player.animation.animationEvents = @[[SCNAnimationEvent animationEventWithKeyTime:0.5 block:^(CAAnimation *animation, id animatedObject, BOOL playingBackward) {
            NSLog(@"attack event");
        }]];
    }
    
    // add short Knockback
    player = [self addPuppetAnim:rcs key:PUPPETSHORTKB];
    if(player) {
        player.animation.animationEvents = @[[SCNAnimationEvent animationEventWithKeyTime:0 block:^(CAAnimation *animation, id animatedObject, BOOL playingBackward)
                                 {
                                     NSLog(@"AnimStart");
                                     self->_playRootAni = true; // root animation start
                                 }], [SCNAnimationEvent animationEventWithKeyTime:1 block:^(CAAnimation *animation, id animatedObject, BOOL playingBackward)
                                 {
                                     NSLog(@"AnimEnd");
                                     // root animation end
                                     self->_playRootAni = false;
                                     self->_endAnim = 0.1f;
                                 }]];
    }
    

    [self play:_puppet key:PUPPETIDLE];
}

- (bool)addRootAnim:(SCNNode*)rcs key:(NSString*)key
{
    // 1. clone root animation from node
    SCNNode* rootani = [[rcs childNodeWithName:key recursively:YES] clone];
    // 2. get animation plyaer
    SCNAnimationPlayer* player = [self loadAnim:rootani];
    // 3. get animation for callback function
    SCNAnimation* ani = player.animation;
    ani.repeatCount = 0; // no repeat
    // 4. add start, end event
    ani.animationEvents = @[[SCNAnimationEvent animationEventWithKeyTime:0 block:^(CAAnimation *animation, id animatedObject, BOOL playingBackward)
                             {
                                 NSLog(@"AnimStart");
                                 self->_playRootAni = true; // root animation start
                             }], [SCNAnimationEvent animationEventWithKeyTime:1 block:^(CAAnimation *animation, id animatedObject, BOOL playingBackward)
                             {
                                 NSLog(@"AnimEnd");
                                 // root animation end
                                 self->_playRootAni = false;
                                 self->_endAnim = true;
                                 /*
                                 // move puppet position to final position
                                 self.simdWorldPosition = self.rootPos;
                                 // init mesh position
                                 self.puppet.simdPosition = simd_make_float3(0.f, 0.f, 0.f);
                                 */
                             }]];
    // 5. set don't remove after playing
    ani.removedOnCompletion = NO;
    // 6. add player
    [_puppet addAnimationPlayer:player forKey:key];
    return YES;
}

- (SCNAnimationPlayer*)addPuppetAnim:(SCNNode*)rcs key:(NSString*)key
{
    // 1. clone animation
    SCNNode* ani = [rcs childNodeWithName:key recursively:YES];
    if(ani == nil)
        return nil;
    // 2. get animation player
    SCNAnimationPlayer* player = [[self loadAnim:ani] copy];
    if(player == nil)
        return nil;
    // 3. don't remove after playing
    player.animation.removedOnCompletion = NO;
    // 4. add animation to puppet
    [_puppet addAnimationPlayer:player forKey:key];
    return player;
}

- (bool)play:(SCNNode*)node key:(NSString*)key
{
    // get animation player
    SCNAnimationPlayer* player = [node animationPlayerForKey:key];
    if(player == nil) // check player
        return NO;
    // play animation
    [player play];
    return YES;
}

- (bool)stop:(SCNNode*)node key:(NSString*)key
{
    // get animation player
    SCNAnimationPlayer* player = [node animationPlayerForKey:key];
    if(player == nil) // check player
        return NO;
    // play animation
    [player stopWithBlendOutDuration:0.1];
    return YES;
}

- (bool)playAnim:(NSString*)key {
    _endAnim = 1.f;
    return [self play:_puppet key:key];
}


- (bool)knockback
{
    if(_debugStop)
        return NO;
    
    if(_playRootAni)
        return NO;

    // play animation
    if([self play:_puppet key:PUPPETSHORTKB] == NO)
        return NO;
    _playRootAni = YES; // set flag for starting state
    
    //_debugStop = YES;
    
    return YES;
}

- (SCNAnimationPlayer*)loadAnim:(SCNNode*)src
{
    // get keys
    NSArray<NSString*>* keys = [src animationKeys];
    if(keys == nil)
        return nil;
    
    // get animation player
    SCNAnimationPlayer* player = [src animationPlayerForKey:keys[0]];
    [player stop];
    
    return player;
}

- (bool)updateRootAni
{
    if(!_playRootAni)
        return NO;
    
    // 1. get presentaion postion (animation postion)
    simd_float3 v = _rootAniBone.presentationNode.simdWorldPosition;
    // 2. check ground
    if([LNCubeMng.instance getFootPostion:&v] == YES)
    {
        // 3. save current postion
        _rootPos = _rootAniBone.presentationNode.simdWorldPosition;
        // 4. only move puppet mesh
        //_puppet.simdWorldPosition = _rootPos;
        
        //NSLog(@"%f %f %f", _rootPos.x, _rootPos.y, _rootPos.z);
        return YES;
    }
    
    return NO;
}

- (void)crashed:(nonnull LNPuppet *)puppet {
    if(_deltaCrash > 0.f) {
        return;
    }
    
    [self.controller crashed:puppet];
    [puppet damaged:self];
    
    if(puppet.nodeType != NodeTypeBullet) {
        _deltaCrash = 1.f;
    }
}

- (void)damaged:(LNPuppet*)puppet {
    [self.controller damaged:puppet];
}

- (void)fire:(LNPuppet*)owner time:(NSTimeInterval)time {
    _lastTime = time;

    self.controller.teamType = owner.controller.teamType;
    self.simdWorldTransform = owner.simdWorldTransform;
    simd_float3 pos = self.simdPosition;
    pos.x += self.simdWorldFront.x * 1.25f;
    pos.y += 0.5f;
    pos.z += self.simdWorldFront.z * 1.25f;
    self.simdPosition = pos;
}

- (bool)stand {
    simd_float3 pos = self.simdPosition;
    if([LNCubeMng.instance getFootPostion:&pos] == NO) {
        return NO;
    }
    self.simdPosition = pos;
    return YES;
}

- (void)initFootPosition
{
    if(_initFootPos == false && _checkGround == true) {
        NSLog(@"initFootPosition");
        _initFootPos = [self stand];
    }
}

- (bool)isCrash { 
    if(_deltaCrash > 0.f) {
        return YES;
    }
    
    return NO;
}

- (void)reserve { 
    self.hidden = YES;
    // move other space
    simd_float3 pos = self.simdWorldPosition;
    pos.y -= 2000.0f;
    self.simdWorldPosition = pos;
}

@end
