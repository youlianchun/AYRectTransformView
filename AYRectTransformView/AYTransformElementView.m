//
//  AYTransformElementView.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/13.
//  Copyright © 2019 YLCHUN. All rights reserved.
//

#import "AYTransformElementView.h"

@implementation AYTransformElementView

@end

@implementation AYTransformElementLabel
- (void)scaleFont:(double)scale {
    CGFloat fontSize = self.font.pointSize * scale;
    NSString *fontName = self.font.fontName;
    self.font = [UIFont fontWithName:fontName size:fontSize];
}
@end

@implementation AYTransformElementImageView

@end
