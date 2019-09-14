//
//  AYRectView.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/7.
//

#import "AYRectTransformControl.h"


NS_ASSUME_NONNULL_BEGIN

@interface AYRectView : AYRectTransformControl

- (void)setTapDeleteCallback:(void(^)(void))callback;
- (void)setTapEditCallback:(void(^)(void))callback;
- (void)setTapTimeCallback:(void(^)(void))callback;
- (void)setBegingEditCallback:(void(^)(void))callback;
- (void)setEndedEditCallback:(void(^)(void))callback;
@end

NS_ASSUME_NONNULL_END
