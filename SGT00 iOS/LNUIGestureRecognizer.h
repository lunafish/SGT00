//
//  LNUIGestureRecognizer.h
//  SGT00 iOS
//
//  Created by lunafish on 10/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNUIGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGPoint movement;
@property (nonatomic, assign) CGPoint current;
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) BOOL press;

@end

NS_ASSUME_NONNULL_END
