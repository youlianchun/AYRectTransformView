//
//  AYRectTransformPanelHandler.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/13.
//  Copyright © 2019 YLCHUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYRectTransformPanel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AYRectTransformPanelHandler : NSObject
@property (nonatomic, readonly) AYRectTransformPanel *transformPanel;
@property (nonatomic, readonly) AYRectTransformElementView *focusElemen;
- (instancetype)initWithPanel:(AYRectTransformPanel *)panel;
- (void)setFocusElemenCallback:(void(^)(AYRectTransformElementView *focusElemen))callback;
- (void)didFocusElemen:(AYRectTransformElementView *)elemen byTap:(BOOL)byTap;
@end

NS_ASSUME_NONNULL_END
