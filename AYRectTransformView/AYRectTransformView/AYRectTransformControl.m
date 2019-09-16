//
//  AYRectTransformControl.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/6.
//

#import "AYRectTransformControl.h"
#import "AYGestureControl.h"
#import "CGGeometry+Rect.h"

@interface AYRectTransformControl ()<AYGestureControlDelegate, UIGestureRecognizerDelegate>
@end
@implementation AYRectTransformControl
{
    AYGestureControl *_conControl;
    AYGestureControl *_ltControl;
    AYGestureControl *_lbControl;
    AYGestureControl *_rbControl;
    AYGestureControl *_rtControl;
    __weak AYGestureControl *_scaleDot, *_radianDot;
    __weak AYGestureControl *_trackingControl;
    
    CGPoint _translation; CGFloat _scale, _radian;
    
    BOOL _lastControlHidden;
    BOOL _isPaning;
    BOOL _hasFocus;
    
    void(^_transformCallback)(CGPoint translationOffset, float scaleOffset, float radianOffset);
    void(^_tapCallback)(CGPoint point);
}
@synthesize strokeLayer = _strokeLayer;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseCustomInit];
    }
    return self;
}

- (void)baseCustomInit {
    _scale = 1;
    _radian = 0;
    _translation = CGPointZero;
    self.backgroundColor = [UIColor clearColor];
    
    _conControl = [[AYGestureControl alloc] initWithFrame:CGRectZero];
    _conControl.delegate = self;
    _conControl.disablePan = YES;
    static CGFloat len = 30;
    _ltControl = [[AYGestureControl alloc] initWithFrame:CGRectMake(0, 0, len, len)];
    _lbControl = [[AYGestureControl alloc] initWithFrame:CGRectMake(0, 0, len, len)];
    _rbControl = [[AYGestureControl alloc] initWithFrame:CGRectMake(0, 0, len, len)];
    _rtControl = [[AYGestureControl alloc] initWithFrame:CGRectMake(0, 0, len, len)];
    
    [self addSubview:_conControl];
    [self addSubview:_ltControl];
    [self addSubview:_lbControl];
    [self addSubview:_rbControl];
    [self addSubview:_rtControl];
    
    [self setScaleDot:_rbControl];
    [self setRadianDot:_rbControl];
    [self resetRotateRect];
    
    [self initGestureRecognizer];
}

- (void)initGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)setRotateRect:(CGRotateRect)rotateRect {
    if (CGRotateRectIsZero(rotateRect)) {
        [self resetRotateRect];
    }else {
        _hasFocus = YES;
        [self updateControlHidden];
        [self updateLayoutWithRect:rotateRect];
        [self updateStrokeHidden];
    }
}

- (void)resetRotateRect {
    _hasFocus = NO;
    CGRotateRect rect = CGRotateRectZero;
    [self updateLayoutWithRect:rect];
    [self setDotControlHidden:YES];
    _strokeLayer.hidden = YES;
}

- (UIView *)content {
    return _conControl;
}

- (UIView *)ltDot {
    return _ltControl;
}

- (UIView *)lbDot {
    return _lbControl;
}

- (UIView *)rbDot {
    return _rbControl;
}

- (UIView *)rtDot {
    return _rtControl;
}

- (CAShapeLayer *)strokeLayer {
    if (!_strokeLayer) {
        _strokeLayer = [CAShapeLayer layer];
        _strokeLayer.frame = self.bounds;
        _strokeLayer.lineWidth = 0.5;
        _strokeLayer.strokeColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        _strokeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer insertSublayer:_strokeLayer atIndex:0];
    }
    return _strokeLayer;
}

- (void)updateLayoutWithRect:(CGRotateRect)rotateRect {
    _conControl.transform = CGAffineTransformIdentity;
    _conControl.frame = CGCenterRect2CGRect(rotateRect.centerRect);
    if (rotateRect.radian != 0) {
        _conControl.transform = CGAffineTransformMakeRotation(rotateRect.radian);
    }
    [self updateDotControlCenter];
    [self setNeedsDisplay];
}

- (void)setTransformCallback:(void(^)(CGPoint translationOffset, float scaleOffset, float radianOffset))callback {
    _transformCallback = callback;
}

- (void)setTapCallback:(void(^)(CGPoint point))callback {
    _tapCallback = callback;
}

- (BOOL)isDotControl:(UIView *)dot {
    return dot == _ltControl || dot == _lbControl || dot == _rbControl || dot == _rtControl;
}

- (void)setControl:(UIView *)control target:(id)target action:(SEL)action {
    if (![self isDotControl:control] && control != _conControl) return;
    [(AYGestureControl *)control setTarget:target action:action];
}

- (void)removeDotdentity:(AYGestureControl *)control {
    if (!control) return;
    control.identity --;
    if (control.identity == 0) {
        control.delegate = nil;
        [self sendSubviewToBack:control];
    }
}

- (void)addDotIdentity:(AYGestureControl *)control {
    if (!control) return;
    control.identity ++;
    control.delegate = self;
    [self bringSubviewToFront:control];
}

- (void)setScaleDot:(UIView *)dot {
    if (dot && ![self isDotControl:dot]) return;
    [self removeDotdentity:_scaleDot];
    _scaleDot = (AYGestureControl *)dot;
    [self addDotIdentity:_scaleDot];
}

- (void)setRadianDot:(UIView *)dot {
    if (dot && ![self isDotControl:dot]) return;
    [self removeDotdentity:_radianDot];
    _radianDot = (AYGestureControl *)dot;
    [self addDotIdentity:_radianDot];
}

- (void)updateControlHidden {
    BOOL hidden = _isPaning ? YES : NO;
    hidden = _disableDot ? YES : hidden;
    _lastControlHidden = hidden;
    [self setDotControlHidden:hidden];
}

- (void)setDotControlHidden:(BOOL)hidden {
    _ltControl.subHidden = hidden;
    _lbControl.subHidden = hidden;
    _rbControl.subHidden = hidden;
    _rtControl.subHidden = hidden;
}

#pragma mark - XMTouchControlDelegate

- (void)gestureControlBegan:(AYGestureControl *)control{
    if (_trackingControl) return;
    _trackingControl = control;
    
    if (control == _conControl || control == _scaleDot) {
        [self beginTransform];
    }
}

- (void)gestureControlMoved:(AYGestureControl *)control current:(CGPoint)current previous:(CGPoint)previous {
    if (control == _conControl) {
        _translation.x += (current.x - previous.x);
        _translation.y += (current.y - previous.y);
        _conControl.center = CGParallelPoint(_conControl.center, previous, current);
    }else {
        CGFloat scale = 1, radian = 0;
        if (control == _scaleDot) {
            scale = CGPointScale(_conControl.center, previous, current);
            _scale *= scale;
        }
        if (control == _radianDot) {
            radian = CGPointRadian(_conControl.center, previous, current);
            _radian += radian;
        }
        CGAffineTransform transform = _conControl.transform;
        transform = CGAffineTransformRotate(transform, radian);
        transform = CGAffineTransformScale(transform, scale, scale);
        _conControl.transform = transform;
    }
    [self updateDotControlCenter];
    [self transformCallback];
    [self setNeedsDisplay];
}

- (void)updateDotControlCenter {
    CGPathRect rect = CGRect2CGPathRect(_conControl.bounds);
    rect.lt = [_conControl convertPoint:rect.lt toView:self];
    rect.lb = [_conControl convertPoint:rect.lb toView:self];
    rect.rb = [_conControl convertPoint:rect.rb toView:self];
    rect.rt = [_conControl convertPoint:rect.rt toView:self];
    rect = CGPathRectExp(rect, _rectMargin);
    _ltControl.center = rect.lt;
    _lbControl.center = rect.lb;
    _rbControl.center = rect.rb;
    _rtControl.center = rect.rt;
    
    [self updateStrokeLayerIfNeed];
}

- (void)gestureControlEnded:(AYGestureControl *)control{
    if (_trackingControl != control) return;
    _trackingControl = nil;
    [self endedTransform];
}

- (BOOL)gestureControlTap:(AYGestureControl *)control {
    if (control == _conControl) {
        BOOL isSelect = !_lastControlHidden;
        [self updateControlHidden];
        [self updateStrokeHidden];
        return isSelect;
    }
    return YES;
}

#pragma mark -
- (void)updateStrokeHidden {
    self.strokeLayer.hidden = _isPaning || _disableDot;
}

- (void)updateStrokeLayerIfNeed {
    if (!_strokeLayer) return;
    if (_hasFocus) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:self.ltDot.center];
        [path addLineToPoint:self.lbDot.center];
        [path addLineToPoint:self.rbDot.center];
        [path addLineToPoint:self.rtDot.center];
        [path closePath];
        _strokeLayer.path = path.CGPath;
    }else {
        _strokeLayer.path = nil;
    }
}

- (CGPathRect)contentPathRect {
    CGPathRect rect = CGPathRectZero;
    if (_hasFocus) {
        rect.lt = _ltControl.center;
        rect.lb = _lbControl.center;
        rect.rb = _rbControl.center;
        rect.rt = _rtControl.center;
    }
    return rect;
}


#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return _trackingControl == nil;
}

- (void)tapHandler:(UITapGestureRecognizer *)sender {
    [self transformCallback];
    CGPoint point = [sender locationInView:self];
    [self tapCallbackWithPoint:point];
}

- (void)panHandler:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            _isPaning = YES;
            CGPoint point = [sender locationInView:self];
            if (!_hasFocus || !CGPathRectContainsPoint([self contentPathRect], point)) {
                [self tapCallbackWithPoint:point];
            }
            if (_hasFocus) {
                [self gestureControlBegan:_conControl];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_hasFocus) {
                CGPoint translation = [sender translationInView:self];
                CGPoint previous = _conControl.center;
                CGPoint current = CGPointMake(translation.x + previous.x, translation.y + previous.y);
                [self gestureControlMoved:_conControl current:current previous:previous];
                [sender setTranslation:CGPointZero inView:self];
            }
        } break;
        case UIGestureRecognizerStateEnded:
        default: {
            if (_hasFocus) {
                [self gestureControlEnded:_conControl];
            }
            _isPaning = NO;
        } break;
    }
}

#pragma mark -
- (void)beginTransform {
    [self setDotControlHidden:YES];
    _trackingControl.subHidden = NO;
}

- (void)endedTransform {
    [self setDotControlHidden:_lastControlHidden];
}

- (void)transformCallback {
    CGPoint translation = _translation;
    CGFloat scale = _scale;
    CGFloat radian = _radian;
    _scale = 1;
    _radian = 0;
    _translation = CGPointZero;
    !_transformCallback?:_transformCallback(translation, scale, radian);
}

- (void)tapCallbackWithPoint:(CGPoint)point{
    [self resetRotateRect];
    !_tapCallback?:_tapCallback(point);
}


@end
