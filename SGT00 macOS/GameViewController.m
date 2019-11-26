//
//  GameViewController.m
//  SGT00 macOS
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "GameViewController.h"
#import <SceneKit/SceneKit.h>
#import "GameController.h"
#import "LNGestureRecognizer.h"


@interface GameViewController ()
{
    bool _useCamera;
}

@property (readonly) SCNView *gameView;
@property (strong, nonatomic) GameController *gameController;

@end

@implementation GameViewController

- (SCNView *)gameView {
    return (SCNView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameController = [[GameController alloc] initWithSceneRenderer:self.gameView];
    
    // Use Camera Control
    _useCamera = NO;
    
    // Allow the user to manipulate the camera
    self.gameView.allowsCameraControl = _useCamera;
    
    // Show statistics such as fps and timing information
    self.gameView.showsStatistics = YES;
    
    // Configure the view
    self.gameView.backgroundColor = [NSColor blackColor];
    
    // Add a click gesture recognizer
    NSClickGestureRecognizer *clickGesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick:)];
    LNGestureRecognizer *mouseGesture = [[LNGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:clickGesture];
    [gestureRecognizers addObject:mouseGesture];
    [gestureRecognizers addObjectsFromArray:self.gameView.gestureRecognizers];
    self.gameView.gestureRecognizers = gestureRecognizers;
}

- (void) handleClick:(NSGestureRecognizer*)gestureRecognize {
    // Highlight the clicked nodes
    CGPoint p = [gestureRecognize locationInView:self.gameView];
    [self.gameController highlightNodesAtPoint:p];
}

- (void) handlePress:(LNGestureRecognizer*)gestureRecognize {
    if(gestureRecognize.press)
        [self.gameController moveNodesAtPoint:gestureRecognize.current start:gestureRecognize.start movement:gestureRecognize.movement];
    else
        [self.gameController releaseNodesAtPoint:gestureRecognize.current];
}

@end
