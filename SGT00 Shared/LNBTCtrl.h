//
//  LNBTCtrl.h
//  SGT00
//
//  Created by lunafish on 2019/11/21.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDelegate.h"
#import "LNCtrl.h"
#import "LNEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNBTCtrl : NSObject

@property (strong, nonatomic) id<LNBTDelegate> root;
@property (assign, nonatomic) BTTaskType taskType;

- (BTTaskType)run:(LNCtrl*)ctrl; // 
- (BTTaskType)process:(LNCtrl*)ctrl delta:(float)delta; //


@end

NS_ASSUME_NONNULL_END
