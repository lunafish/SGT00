//
//  LNPuppetMng.h
//  SGT00
//
//  Created by lunafish on 10/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNNode.h"

NS_ASSUME_NONNULL_BEGIN

@class LNPuppet;
@interface LNPuppetMng : LNNode

+ (LNPuppetMng*)instance;

@property (strong, readonly) NSMutableArray<LNPuppet*>* lstPuppet; // puppet list;
@property (assign, readonly) LNPuppet* player; // player puppet for fast search

- (LNPuppet*)GetNearPuppet:(LNPuppet*)puppet isEnemy:(bool)isEnemy; // get nearest puppet
- (LNPuppet*)MakeBullet:(LNPuppet*)owner time:(NSTimeInterval)time;
- (LNPuppet*)CheckCrash:(LNPuppet*)owner bound:(float)bound;

- (void)update:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
