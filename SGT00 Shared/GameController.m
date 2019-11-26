//
//  GameController.m
//  SGT00 Shared
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <SpriteKit/SpriteKit.h>

#import "GameController.h"
#import "LNCubeMng.h"
#import "LNUIMng.h"
#import "LNPuppetMng.h"

#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

@interface GameController ()

@property (strong, nonatomic) SCNScene *scene;
@property (strong, nonatomic) id <SCNSceneRenderer> sceneRenderer;

@end

@implementation GameController

static GameController* _instance = nil;
+ (GameController*) instance { @synchronized(self) { return _instance; } }

- (instancetype)initWithSceneRenderer:(id <SCNSceneRenderer>)sceneRenderer {
    self = [super init];
    if (self) {
        self.sceneRenderer = sceneRenderer;
        self.sceneRenderer.delegate = self;
        
        _instance = self; // singleton instance
        _delegates = [[NSMutableArray alloc] init]; // make delegate array
        _delegateInputs = [[NSMutableArray alloc] init]; // make input delegate array

        // create a new scene
        SCNScene *scene = [SCNScene sceneNamed:@"Art.scnassets/GameMain.scn"]; // default scene
        
        // create a cube manager
        LNCubeMng* cubeMng = [[LNCubeMng alloc] init];
        [scene.rootNode addChildNode:cubeMng];
        [cubeMng load]; // load cube
        
        // create a UI manager
        LNUIMng* uiMng = [[LNUIMng alloc] init];
        [scene.rootNode addChildNode:uiMng];
        
        // create puppet manager
        LNPuppetMng* puppetMng = [[LNPuppetMng alloc] init];
        [scene.rootNode addChildNode:puppetMng];

        self.scene = scene;
        self.sceneRenderer.scene = scene;
    }
    return self;
}

- (void)highlightNodesAtPoint:(CGPoint)point {
    NSArray<SCNHitTestResult *> *hitResults = [self.sceneRenderer hitTest:point options:nil];
    for (SCNHitTestResult *result in hitResults) {
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [SCNColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [SCNColor redColor];
        
        [SCNTransaction commit];
    }
}

- (void)clickNodesAtPoint:(CGPoint)point
{

}

- (void)moveNodesAtPoint:(CGPoint)current start:(CGPoint)start movement:(CGPoint)movement
{
    for(int i = 0; i < _delegateInputs.count; i++)
    {
        [_delegateInputs[i] moveNodesAtPoint:current start:start movement:movement];
    }
}

- (void)releaseNodesAtPoint:(CGPoint)point
{
    for(int i = 0; i < _delegateInputs.count; i++)
    {
        [_delegateInputs[i] releaseNodesAtPoint:point];
    }
}


- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    // Called before each frame isrendered
    
    for(int i = 0; i < _delegates.count; i++)
    {
        [_delegates[i] update:time];
    }
}

@end
