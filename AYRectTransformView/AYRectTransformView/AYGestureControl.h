//
//  AYTouchControl.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/7.
//

#import <UIKit/UIKit.h>
@class AYGestureControl;

NS_ASSUME_NONNULL_BEGIN

@protocol AYGestureControlDelegate <NSObject>
@optional
- (void)gestureControlBegan:(AYGestureControl *)control;
- (void)gestureControlMoved:(AYGestureControl *)control current:(CGPoint)current previous:(CGPoint)previous;
- (void)gestureControlEnded:(AYGestureControl *)control;
- (void)gestureControlTap:(AYGestureControl *)control;
@end

@interface AYGestureControl : UIView
@property (nonatomic, assign) BOOL subHidden;
@property (nonatomic, assign) NSUInteger identity;
@property (nonatomic, weak) id<AYGestureControlDelegate> _Nullable delegate;
- (void)setTarget:(id)target action:(SEL)action;
@end


NS_ASSUME_NONNULL_END
