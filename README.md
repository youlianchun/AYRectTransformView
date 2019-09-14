# AYRectTransformView
AYRectTransformView 贴纸编辑控件

#### AYTransformElementView
```
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
```

###### 
```
AYTransformElementView *view = [[AYTransformElementView alloc] initWithFrame:CGRectMake(100, 50, 90, 60)];
view.rotateRect = view.defRotateRect;
view.backgroundColor = randomColor();
[self.transformPanel addElement:view];

AYTransformElementLabel *label = [[AYTransformElementLabel alloc] initWithFrame:CGRectMake(100, 300, 0 , 0)];
label.text = @"YLCHUN";
[label sizeToFit];
label.rotateRect = label.defRotateRect;
label.textColor = randomColor();
[self.transformPanel addElement:label];

AYTransformElementImageView *imageView = [[AYTransformElementImageView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
imageView.userInteractionEnabled = YES;
imageView.image = [UIImage imageNamed:@"apple"];
imageView.rotateRect = imageView.defRotateRect;
[self.transformPanel addElement:imageView];
```


#### AYRectTransformControl

```
__weak typeof(self) wself = self;
[self.rectView setTransformCallback:^(CGPoint translationOffset, float scaleOffser, float radianOffset) {
    __strong typeof(self) self = wself;
    CGRotateRect rect = self.elementView.rotateRect;
    rect = CGRotateRectRotation(rect, radianOffset);
    rect = CGRotateRectScale(rect, scaleOffser);
    rect = CGRotateRectTranslation(rect, translationOffset);
    if ([self.elementView isKindOfClass:[AYTransformElementLabel class]]) {
        AYTransformElementLabel *label = (AYTransformElementLabel *)self.elementView;
        [label scaleFont:scaleOffser];
        rect.centerRect.size = [label sizeThatFits:CGSizeZero];
    }
    self.elementView.rotateRect = rect;
    [self.elementView updateWithRotateRect:rect];
}];
[self.rectView setTapCallback:^(CGPoint point) {
    __strong typeof(self) self = wself;
    self.elementView = [self.transformPanel elementAtPoint:point margin:20];
    [self.transformPanel focusElement:self.elementView];
    [self.rectView setRotateRect:self.elementView.rotateRect];
}];
```
