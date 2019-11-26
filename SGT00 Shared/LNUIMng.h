//
//  LNUIMng.h
//  SGT00
//
//  Created by lunafish on 04/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//


#import "LNNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNUIMng : LNNode

+ (LNUIMng*)instance;

@property (strong, readonly) SKScene* uiScene;

- (void)update:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
