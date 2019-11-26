//
//  LNNode.m
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNNode.h"
#import "LNCtrl.h"
#import "GameController.h"

@interface LNNode()

@property (strong, nonatomic) id <SCNSceneRenderer> sceneRenderer;

@end

@implementation LNNode

- (id)init
{
    self = [super init];
    
    // get scene render
    _sceneRenderer = GameController.instance.sceneRenderer;
    
    return self;
}

- (void)copyMesh:(SCNNode*)node
{
    self.geometry = [node.geometry copy];
    self.geometry.firstMaterial = [node.geometry.firstMaterial copy];
    self.scale = node.scale;
}

- (bool)active:(bool)value
{
    self.hidden = value;
    
    return self.hidden;
}

- (NodeType)nodeType
{
    return NodeTypeNone;
}

- (TeamType)teamType
{
    return TeamNone;
}

- (void)addDelegate
{
     [GameController.instance.delegates addObject:self];
}

- (void)removeDelegate
{
     [GameController.instance.delegates removeObject:self];
}

- (void)addInpuDelegate
{
    [GameController.instance.delegateInputs addObject:self];
}

- (void)removeInputDelegate
{
    [GameController.instance.delegateInputs removeObject:self];
}


@end
