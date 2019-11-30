//
//  LNHud.m
//  SGT00
//
//  Created by lunafish on 10/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNUIMng.h"
#import "LNHud.h"
#import <SpriteKit/SpriteKit.h>
#import "GameController.h"
// puppet
#import "LNPuppetMng.h";
#import "LNPuppet.h"
#import "LNCtrl.h"

#define DRAW_LINE 0

@interface LNHud()
{
    SKNode* _down; // down icon
    SKNode* _move; // move icon
    SKLabelNode* _state; // state label
    SKShapeNode* _line; // line
    CGMutablePathRef _linePath; // line path
}

@property (strong, nonatomic) SKScene* uiScene;

@end

@implementation LNHud

- (id)init
{
    self = [super init];
    
    // load ui
    _uiScene = [SKScene nodeWithFileNamed:@"GameHud.sks"];
    _down = [_uiScene childNodeWithName:BUTTONDOWN]; // down button
    _move = [_uiScene childNodeWithName:BUTTONMOVE]; // move button
    _state = (SKLabelNode*)[_uiScene childNodeWithName:LABELSTATE]; // state label
    
    _down.hidden = YES;
    _move.hidden = YES;
   
#if DRAW_LINE
    // make line
    _line = [SKShapeNode node];
    _line.lineWidth = 4;
    _line.antialiased = NO;
    [_line setStrokeColor:[SKColor blackColor]];
    _line.hidden = YES;
    [_uiScene addChild:_line];
#endif
    
    
    [self addInpuDelegate];
    
    return self;
}

- (bool)active:(bool)value
{
    bool ret = [super active:value];
    
    if(value == YES)
        self.sceneRenderer.overlaySKScene = _uiScene;
    else
        self.sceneRenderer.overlaySKScene = nil;

    self.sceneRenderer.overlaySKScene.userInteractionEnabled = false;
    
    return ret;
}

- (void)drawCursor:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement
{
    _down.hidden = NO;
    _down.position = start;
    
    _move.hidden = NO;
    _move.position = current;
    
#if DRAW_LINE
    _linePath = CGPathCreateMutable();
    CGPathMoveToPoint(_linePath, NULL, _down.position.x, _down.position.y);
    CGPathAddLineToPoint(_linePath, NULL, _move.position.x, _move.position.y);
    _line.path = _linePath;
    _line.hidden = NO;
#endif
}

- (void)clearCursor:(CGPoint)point
{
    _down.hidden = YES;
    _move.hidden = YES;

#if DRAW_LINE
    _line.hidden = YES;
    // path clear
    CGPathRelease(_linePath);
    _linePath = nil;
#endif
}

- (void)moveNodesAtPoint:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement
{
    [self drawCursor:current start:start movement:movement];
}

- (void)releaseNodesAtPoint:(CGPoint)point
{
    [self clearCursor:point];
}

- (void)update:(NSTimeInterval)time delta:(float)delta {
    _state.text = [NSString stringWithFormat:@"HP : %0.0f MP : %0.0f",
                   [LNPuppetMng.instance.player.controller HP],
                   [LNPuppetMng.instance.player.controller MP]];
    
}

@end
