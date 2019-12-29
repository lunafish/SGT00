//
//  LNUIMng.m
//  SGT00
//
//  Created by lunafish on 04/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LNUIMng.h"
#import "LNHud.h"

@interface LNUIMng()
{
    LNNode<LNUIDelegate>* _hud;
    
    float _lastTime;
    float _delta;
}

@property (strong, nonatomic) SKScene* uiScene;

@end

@implementation LNUIMng

static LNUIMng* _instance = nil;
+ (LNUIMng*)instance { @synchronized(self) { return _instance; } }

- (id)init
{
    self = [super init];
    
    _instance = self;
    
    _lastTime = INFINITY;
    _delta = 0;
    
    _hud = [[LNHud alloc] init];
    [_hud active:YES];
    
    [self addChildNode:_hud];
    [self addDelegate];
    
    return self;
}

- (void)update:(NSTimeInterval)time
{
    if(_lastTime == INFINITY)
        _lastTime = time;
    
    // make tick : second
    _delta = time - _lastTime;
    _lastTime = time;
    
    [_hud update:time delta:_delta];
}

- (void)log:(NSString*)msg {
    [_hud log:msg];
}

- (void)speech:(nonnull NSString *)msg pos:(SCNVector3)pos {
    [_hud sppech:msg x:pos.x y:pos.y];
}

@end
