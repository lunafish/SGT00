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
{
    LNPuppet* targetPuppet;
    NSTimeInterval _currentTime;
    
    // for data
    float _hp;
    float _mp;
    BulletType _bulletType;
    float _bulletDamage;
    //
}

@property (strong, nonatomic) LNNode* viewNode;
@property (strong, nonatomic) LNPuppet* puppetNode;

- (id)init:(LNNode*)viewNode;
- (void)initCtrl;
- (bool)checkFriend;
- (void)endAttack;
- (void)fire:(LNPuppet*)owner;

@end

NS_ASSUME_NONNULL_END
