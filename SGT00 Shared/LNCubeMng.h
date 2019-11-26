//
//  LNCubeMng.h
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNCubeMng : LNNode

+ (LNCubeMng*)instance;

- (bool)load;
- (bool)getIndex:(NSInteger*)x y:(NSInteger*)y dir:(Dir)dir;
- (bool)getFootPostion:(simd_float3*)postion;
- (void)update:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
