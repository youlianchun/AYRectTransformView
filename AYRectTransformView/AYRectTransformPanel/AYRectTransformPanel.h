//
//  AYRectTransformPanel.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/10.
//

#import <UIKit/UIKit.h>
#import "CGGeometry+Rect.h"

@protocol AYRectTransformElement <NSObject>
@property (nonatomic, assign) CGRotateRect rotateRect;
@optional
- (void)updateWithRotateRect:(CGRotateRect)rect;
@property (nonatomic, readonly) CGRotateRect defRotateRect;
@end
typedef __kindof UIView<AYRectTransformElement> AYRectTransformElementView;

NS_ASSUME_NONNULL_BEGIN

@interface AYRectTransformPanel : UIView
- (AYRectTransformElementView *)elementAtPoint:(CGPoint)point margin:(CGFloat)margin;
- (void)focusElement:(AYRectTransformElementView *)element;
- (void)addElement:(AYRectTransformElementView *)element;
- (void)removeElement:(AYRectTransformElementView *)element;
- (void)enumerateUsingBlock:(void(^)(AYRectTransformElementView *element))block;

- (void)cleanAllElements;
@end

@interface UIView (AYRectTransformElementView)
- (void)updateWithRotateRect:(CGRotateRect)rect;
@property (nonatomic, readonly) CGRotateRect defRotateRect;
@end

NS_ASSUME_NONNULL_END

