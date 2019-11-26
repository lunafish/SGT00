//
//  LNUIGestureRecognizer.m
//  SGT00 iOS
//
//  Created by lunafish on 10/03/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNUtil.h"
#import "LNUIGestureRecognizer.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
{ \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
}

@interface LNUIGestureRecognizer()
{
    CGPoint _half;
    SEL _action;
    id _target;
}
@end

@implementation LNUIGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
    return [super initWithTarget:target action:action];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //self.state = UIGestureRecognizerStateBegan;
    _movement.x = _movement.y = 0;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    _start = location;
    _press = true;
    CGRect rect = touch.view.frame;
    _half.x = (rect.size.width * 0.5f);
    _half.y = (rect.size.height * 0.5f);
    _start.x -= _half.x;
    _start.y -= _half.y;
    _start.y *= -1.0f;
    _current = _start;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    //self.state = UIGestureRecognizerStateChanged;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    // get window size
    CGRect rect = touch.view.frame;
    // move delta
    _current = location;
    _current.x -= _half.x;
    _current.y -= _half.y;
    _current.y *= -1.0f;
    
    float len = rect.size.height * 0.25f;
    [LNUtil scaleCGPoint:&_start end:&_current lengh:len];
    _movement.x = (_current.x - _start.x) / len;
    _movement.y = (_current.y - _start.y) / len;
    
    //NSLog(@"%f %f -> %f %f", _start.x, _start.y, _current.x, _current.y);
    
    SuppressPerformSelectorLeakWarning( [_target performSelector:_action withObject:self] );
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    //self.state = UIGestureRecognizerStateEnded;
    _press = false;
    SuppressPerformSelectorLeakWarning( [_target performSelector:_action withObject:self] );
    
    [self reset];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    NSLog(@"touchesEnded");
}

@end
