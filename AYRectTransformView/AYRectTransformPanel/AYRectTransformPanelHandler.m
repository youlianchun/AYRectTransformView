//
//  AYRectTransformPanelHandler.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/13.
//  Copyright © 2019 YLCHUN. All rights reserved.
//

#import "AYRectTransformPanelHandler.h"

@interface AYRectTransformPanelHandler()<UIGestureRecognizerDelegate>
@end

@implementation AYRectTransformPanelHandler
{
    void(^_focusElemenCallback)(AYRectTransformElementView *focusElemen);
}
@synthesize transformPanel = _transformPanel, focusElemen = _focusElement;

- (instancetype)initWithPanel:(AYRectTransformPanel *)panel {
    self = [super init];
    if (self) {
        _transformPanel = panel;
        [self baseCustomInit];
    }
    return self;
}

- (void)baseCustomInit {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [_transformPanel addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [_transformPanel addGestureRecognizer:panGesture];
}

- (void)tapHandler:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_transformPanel];
    [self focusElemenAtPoint:point byTap:YES];
}

- (void)panHandler:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint point = [sender locationInView:_transformPanel];
            [self focusElemenAtPoint:point byTap:NO];
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_focusElement) {
                CGPoint translation = [sender translationInView:_transformPanel];
                [sender setTranslation:CGPointZero inView:_transformPanel];
                CGPoint previous = _focusElement.center;
                CGPoint current = CGPointMake(translation.x + previous.x, translation.y + previous.y);
                _focusElement.center = current;
                CGRotateRect rotateRect = _focusElement.rotateRect;
                rotateRect.centerRect.center = current;
                _focusElement.rotateRect = rotateRect;
            }
        } break;
        case UIGestureRecognizerStateEnded:
        default: {
            
        } break;
    }
}

- (void)focusElemenAtPoint:(CGPoint)point byTap:(BOOL)byTap {
    _focusElement = [_transformPanel elementAtPoint:point margin:20];
    [_transformPanel focusElement:_focusElement];
    [self didFocusElemen:_focusElement byTap:byTap];
    !_focusElemenCallback?:_focusElemenCallback(_focusElement);
}

- (void)setFocusElemenCallback:(void(^)(AYRectTransformElementView *focusElemen))callback {
    _focusElemenCallback = callback;
}

- (void)didFocusElemen:(AYRectTransformElementView *)elemen byTap:(BOOL)byTap {}

@end
