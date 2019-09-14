//
//  AYRectTransformControl.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/6.
//

#import <UIKit/UIKit.h>
#import "CGGeometry+Rect.h"
#import "AYGestureControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface AYRectTransformControl : UIView
@property (nonatomic, strong, readonly) CAShapeLayer *strokeLayer;
@property (nonatomic, strong, readonly) UIView *content;
@property (nonatomic, strong, readonly) UIView *ltDot;
@property (nonatomic, strong, readonly) UIView *lbDot;
@property (nonatomic, strong, readonly) UIView *rbDot;
@property (nonatomic, strong, readonly) UIView *rtDot;

@property (nonatomic, assign) BOOL disableDot;

@property (nonatomic, assign) CGFloat rectMargin;

- (void)setTransformCallback:(void(^)(CGPoint translationOffset, float scaleOffser, float radianOffset))callback NS_REQUIRES_SUPER;

- (void)setTapCallback:(void(^)(CGPoint point))callback NS_REQUIRES_SUPER;

- (void)setControl:(UIView *)control target:(id)target action:(SEL)action NS_REQUIRES_SUPER;

- (void)setScaleDot:(UIView *)dot NS_REQUIRES_SUPER;
- (void)setRadianDot:(UIView *)dot NS_REQUIRES_SUPER;

- (void)setRotateRect:(CGRotateRect)rotateRect NS_REQUIRES_SUPER;

- (void)resetRotateRect NS_REQUIRES_SUPER;

- (void)beginTransform NS_REQUIRES_SUPER;
- (void)endedTransform NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
