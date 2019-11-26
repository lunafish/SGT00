//
//  LNGestureRecognizer.m
//  SGT00 macOS
//
//  Created by lunafish on 12/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNUtil.h"
#import "LNGestureRecognizer.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
{ \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
}

@interface LNGestureRecognizer()
{
    CGPoint _half;
}
@end

@implementation LNGestureRecognizer

- (void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    
    _movement.x = _movement.y = 0;
    _start = event.locationInWindow;
    _press = true;
    
    NSRect rect = event.window.frame;
    _half.x = (rect.size.width * 0.5f);
    _half.y = (rect.size.height * 0.5f);
    _start.x -= _half.x;
    _start.y -= _half.y;
}

- (void)mouseDragged:(NSEvent *)event
{
    [super mouseDragged:event];
    
    NSRect rect = event.window.frame;
    _current = event.locationInWindow;
    _current.x -= _half.x;
    _current.y -= _half.y;
    
    float len = rect.size.height * LNUtil.moveLength;
    [LNUtil scaleCGPoint:&_start end:&_current lengh:len];
    
    _movement.x = (_current.x - _start.x) / len;
    _movement.y = (_current.y - _start.y) / len;
    
    SuppressPerformSelectorLeakWarning( [self.target performSelector:self.action withObject:self] );
}

- (void)mouseUp:(NSEvent *)event
{
    [super mouseUp:event];
    
    _press = false;
    SuppressPerformSelectorLeakWarning( [self.target performSelector:self.action withObject:self] );
}

@end
