//
//  AYRectView.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/7.
//

#import "AYRectView.h"

@implementation AYRectView
{
    void(^_tapDeleteCallback)(void);
    void(^_tapEditCallback)(void);
    void(^_tapTimeCallback)(void);
    void(^_begingEditCallback)(void);
    void(^_endedEditCallback)(void);
}

static void setDefShadow(CALayer *layer) {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.5;
    layer.shadowRadius = 0.5;
    layer.shadowOffset = CGSizeMake(0, 0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self customInit];
    return self;
}

- (void)customInit {
    self.rectMargin = 10;
    self.strokeLayer.strokeColor = [UIColor whiteColor].CGColor;
    setDefShadow(self.strokeLayer);
    [self setControl:self.ltDot imageName:@"trDelete" action:@selector(deleteControlAction)];
    [self setControl:self.lbDot imageName:@"trEdit" action:@selector(editControlAction)];
    [self setControl:self.rbDot imageName:@"trScale" action:NULL];
    [self setControl:self.rtDot imageName:@"trTime" action:@selector(timeControlAction)];
    [self setControl:self.content target:self action:@selector(editControlAction)];
    [self setScaleDot:self.rbDot];
    [self setRadianDot:self.rbDot];
    self.lbDot.hidden = YES;
}

- (CAShapeLayer *)newStrokeLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    setDefShadow(layer);
    return layer;
}

- (void)setControl:(UIView *)control imageName:(NSString *)imageName action:(SEL)action {
    setDefShadow(control.layer);
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView =[[UIImageView alloc] initWithImage:image];
    [control addSubview:imageView];
    imageView.center = CGPointMake(CGRectGetMidX(control.bounds), CGRectGetMidY(control.bounds));
    if (action != NULL) {
        [self setControl:control target:self action:action];
    }
}

- (void)deleteControlAction {
    !_tapDeleteCallback?:_tapDeleteCallback();
}
- (void)editControlAction {
    !_tapEditCallback?:_tapEditCallback();
}
- (void)timeControlAction {
    !_tapTimeCallback?:_tapTimeCallback();
}

- (void)setTapDeleteCallback:(void(^)(void))callback {
    _tapDeleteCallback = callback;
}
- (void)setTapEditCallback:(void(^)(void))callback {
    _tapEditCallback = callback;
}
- (void)setTapTimeCallback:(void(^)(void))callback {
    _tapTimeCallback = callback;
}

- (void)setBegingEditCallback:(void(^)(void))callback {
    _begingEditCallback = callback;
}
- (void)setEndedEditCallback:(void(^)(void))callback {
    _endedEditCallback = callback;
}

- (void)beginTransform {
    [super beginTransform];
    !_begingEditCallback?:_begingEditCallback();
}

- (void)endedTransform {
    [super endedTransform];
    !_endedEditCallback?:_endedEditCallback();
}

@end
