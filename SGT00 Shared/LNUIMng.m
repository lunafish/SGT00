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
    LNNode* _hud;
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
    
    _hud = [[LNHud alloc] init];
    [_hud active:YES];
    
    [self addChildNode:_hud];

    return self;
}

- (void)update:(NSTimeInterval)time
{
    
}

@end
