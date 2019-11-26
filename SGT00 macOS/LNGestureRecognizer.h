//
//  LNGestureRecognizer.h
//  SGT00 macOS
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNGestureRecognizer : NSGestureRecognizer

@property (nonatomic, assign) CGPoint movement;
@property (nonatomic, assign) CGPoint current;
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) BOOL press;

@end

NS_ASSUME_NONNULL_END
