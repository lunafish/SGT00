//
//  LNCtrl.h
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class LNNode;
@class LNPuppet;
@interface LNCtrl : NSObject<LNNodeDelegate, LNNodeInputDelegate, LNDdataDelegate>

@property (strong, nonatomic) LNNode* viewNode;
@property (strong, nonatomic) LNPuppet* puppetNode;
@property (assign, nonatomic) TeamType teamType;

- (id)init:(LNNode*)viewNode;
- (void)initCtrl;
- (bool)checkFriend;

@end

NS_ASSUME_NONNULL_END
