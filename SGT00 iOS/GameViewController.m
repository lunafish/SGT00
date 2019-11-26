//
//  GameViewController.m
//  SGT00 iOS
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "GameViewController.h"
#import <SceneKit/SceneKit.h>
#import "GameController.h"
#import "LNUIGestureRecognizer.h"

@interface GameViewController ()

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
    
    // Allow the user to manipulate the camera
    self.gameView.allowsCameraControl = NO;
    
    // Show statistics such as fps and timing information
    self.gameView.showsStatistics = YES;
    
    // Configure the view
    self.gameView.backgroundColor = [UIColor blackColor];
    
    // Add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:self.gameView.gestureRecognizers];

    // add custom gesture
    LNUIGestureRecognizer *pressGesture = [[LNUIGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    [gestureRecognizers addObject:pressGesture];

    self.gameView.gestureRecognizers = gestureRecognizers;


}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize {
    // Highlight the tapped nodes
    CGPoint p = [gestureRecognize locationInView:self.gameView];
    [self.gameController highlightNodesAtPoint:p];
}

- (void) handlePress:(LNUIGestureRecognizer*)gestureRecognize {
    if(gestureRecognize.press)
        [self.gameController moveNodesAtPoint:gestureRecognize.current start:gestureRecognize.start movement:gestureRecognize.movement];
    else
        [self.gameController releaseNodesAtPoint:gestureRecognize.current];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
