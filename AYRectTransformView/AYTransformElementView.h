//
//  AYTransformElementView.h
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/13.
//  Copyright © 2019 YLCHUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYRectTransformPanel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AYTransformElementView : UIView<AYRectTransformElement>
@property (nonatomic, assign) CGRotateRect rotateRect;
@end

@interface AYTransformElementLabel : UILabel<AYRectTransformElement>
@property (nonatomic, assign) CGRotateRect rotateRect;
- (void)scaleFont:(double)scale;
@end

@interface AYTransformElementImageView : UIImageView<AYRectTransformElement>
@property (nonatomic, assign) CGRotateRect rotateRect;
@end
NS_ASSUME_NONNULL_END
