//
//  LNNode.h
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "LNEnum.h"
#import "LNDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class LNCtrl;
@interface LNNode : SCNNode<LNNodeDelegate, LNNodeInputDelegate>

@property (strong, readonly) id <SCNSceneRenderer> sceneRenderer;
@property (strong, nonatomic) LNCtrl* controller;

- (void)copyMesh:(SCNNode*)node;
- (bool)active:(bool)value;
- (void)addDelegate;
- (void)removeDelegate;
- (void)addInpuDelegate;
- (void)removeInputDelegate;

@end

NS_ASSUME_NONNULL_END
