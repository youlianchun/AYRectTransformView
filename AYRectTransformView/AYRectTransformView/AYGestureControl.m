//
//  AYTouchControl.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/7.
//

#import "AYGestureControl.h"

typedef struct {
    BOOL gestureBegan;
    BOOL gestureMoved;
    BOOL gestureEnded;
    BOOL gestureTap;
} AYGestureControlDelegateResponds;

@interface AYGestureControl()<UIGestureRecognizerDelegate>
@end
@implementation AYGestureControl
{
    AYGestureControlDelegateResponds _delegateResponds;
    UIPanGestureRecognizer *_panGesture;
    UITapGestureRecognizer *_tapGesture;

    BOOL _disable;
    
    __weak id _target;
    SEL _action;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseCustomInit];
    }
    return self;
}

- (void)baseCustomInit {
    self.backgroundColor = [UIColor clearColor];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.delegate = self;
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_panGesture];
    [self addGestureRecognizer:_tapGesture];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    _disable = hidden;
}

- (void)setSubHidden:(BOOL)autoHidden {
    if (_disable) return;
    [super setHidden:autoHidden];
}

- (BOOL)subHidden {
    if (_disable) {
        return YES;
    }
    return self.hidden;
}

- (void)setDelegate:(id<AYGestureControlDelegate>)delegate {
    _delegate = delegate;
    _delegateResponds = [self respondsWithDelegate:delegate];
}

- (AYGestureControlDelegateResponds)respondsWithDelegate:(id<AYGestureControlDelegate>)delegate {
    AYGestureControlDelegateResponds responds;
    responds.gestureBegan = [delegate respondsToSelector:@selector(gestureControlBegan:)];
    responds.gestureMoved = [delegate respondsToSelector:@selector(gestureControlMoved:current:previous:)];
    responds.gestureEnded = [delegate respondsToSelector:@selector(gestureControlEnded:)];
    responds.gestureTap = [delegate respondsToSelector:@selector(gestureControlTap:)];
    return responds;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _panGesture) {
        return _delegate != nil && !_disablePan;
    }else {
        return  _delegateResponds.gestureTap || (_target != nil && _action != NULL);
    }
}

- (void)panHandler:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (_delegateResponds.gestureBegan) {
                [self.delegate gestureControlBegan:self];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [sender translationInView:self.superview];
            CGPoint previous = self.center;
            CGPoint current = CGPointMake(translation.x + previous.x, translation.y + previous.y);
            [sender setTranslation:CGPointZero inView:self.superview];
            if (_delegateResponds.gestureMoved) {
                [self.delegate gestureControlMoved:self current:current previous:previous];
            }
            
        } break;
        case UIGestureRecognizerStateEnded:
        default: {
            if (_delegateResponds.gestureEnded) {
                [self.delegate gestureControlEnded:self];
            }
        } break;
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)sender {
    if (_delegateResponds.gestureTap) {
        BOOL allow = [self.delegate gestureControlTap:self];
        if (!allow) {
            return;
        }
    }
    [_target performSelector:_action withObject:self afterDelay:0];
}

- (void)setTarget:(id)target action:(SEL)action {
    _target = nil;
    _action = NULL;
    if ([target respondsToSelector:action]) {
        _target = target;
        _action = action;
    }
}

- (void)removeFromSuperview {}

@end
