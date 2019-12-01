//
//  LNBlackboard.h
//  SGT00
//
//  Created by lunafish on 2019/12/01.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LNPuppet;
@class LNCtrl;
@interface LNBlackboard : NSObject

@property (assign, nonatomic) LNPuppet* tagetPuppet;

@end

NS_ASSUME_NONNULL_END
