//
//  LNCube.h
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNNode.h"
#import "LNEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNCube : LNNode

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) CubeMesh type;
@property (nonatomic) CubeTag tag;
@property (nonatomic) CubeStat stat;

@end

NS_ASSUME_NONNULL_END
