//
//  GameController.h
//  SGT00 Shared
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <SceneKit/SceneKit.h>


@interface GameController : NSObject <SCNSceneRendererDelegate>

+ (GameController*) instance;

@property (strong, readonly) SCNScene *scene; // scene
@property (strong, readonly) id <SCNSceneRenderer> sceneRenderer; // scene renderer
@property (strong, nonatomic) NSMutableArray* delegates; // LNNodeDelegate array
@property (strong, nonatomic) NSMutableArray* delegateInputs; // LNNodeDelegate array

- (instancetype)initWithSceneRenderer:(id <SCNSceneRenderer>)sceneRenderer;

- (void)highlightNodesAtPoint:(CGPoint)point;
- (void)clickNodesAtPoint:(CGPoint)point;
- (void)moveNodesAtPoint:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement; // drag touch
- (void)releaseNodesAtPoint:(CGPoint)point; // releas touch

@end
