//
//  LNBTTaskSequence.h
//  SGT00
//
//  Created by lunafish on 2019/11/21.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNBTTaskSequence : NSObject<LNBTDelegate>

@property (strong, nonatomic) NSMutableArray* Sequence;

@end

NS_ASSUME_NONNULL_END
