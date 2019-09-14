//
//  AYRectTransformPanel.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/10.
//

#import "AYRectTransformPanel.h"

@interface AYRectTransformPanel()
@property (nonatomic, strong) NSMutableArray <AYRectTransformElementView *> *array;
@end

@implementation AYRectTransformPanel

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (AYRectTransformElementView *)elementAtPoint:(CGPoint)point margin:(CGFloat)margin {
    if (!CGRectContainsPoint(self.bounds, point)) return nil;
    AYRectTransformElementView *frontElement;
    for (long i = self.array.count - 1; i >= 0; i--) {
        AYRectTransformElementView *element = self.array[i];
        if (element.hidden || element.alpha == 0) continue;
        
        CGRotateRect rect = element.rotateRect;
        rect.centerRect.size.width += margin;
        rect.centerRect.size.height += margin;
        if (CGRotateRectContainsPoint(rect, point)) {
            frontElement = self.array[i];
            break;
        }
    }
    return frontElement;
}

- (void)focusElement:(AYRectTransformElementView *)element {
    if (!element) return;
    NSUInteger index = [self.array indexOfObject:element];
    if (index < self.array.count) {
        [self bringSubviewToFront:element];
        [self.array removeObject:element];
        [self.array addObject:element];
    }
}

- (void)removeElement:(AYRectTransformElementView *)element {
    if (!element) return;
    if ([self.array containsObject:element]) {
        [element removeFromSuperview];
        [self.array removeObject:element];
    }
}

- (void)addElement:(AYRectTransformElementView *)element {
    if (!element) return;
    if (![self.array containsObject:element]) {
        [self addSubview:element];
        [self.array addObject:element];
    }
}

- (void)enumerateUsingBlock:(void(^)(AYRectTransformElementView *element))block {
    if (!block) return;
    NSArray *arr = [self.array copy];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)cleanAllElements {
    NSArray *arr = [self.array copy];
    [self.array removeAllObjects];
    for (AYRectTransformElementView *element in arr) {
        [element removeFromSuperview];
    }
}

@end

@implementation UIView (AYRectTransformElementView)

- (void)updateWithRotateRect:(CGRotateRect)rect {
    self.transform = CGAffineTransformIdentity;
    self.frame = CGCenterRect2CGRect(rect.centerRect);
    if (rect.radian != 0) {
        self.transform = CGAffineTransformMakeRotation(rect.radian);
    }
}

- (CGRotateRect)defRotateRect {
    CGRotateRect rect = CGRotateRectZero;
    rect.centerRect.center = self.center;
    rect.centerRect.size = self.bounds.size;
    return rect;
}
@end
