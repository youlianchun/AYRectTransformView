//
//  ViewController.m
//  AYRectTransformView
//
//  Created by YLCHUN on 2019/9/13.
//  Copyright © 2019 YLCHUN. All rights reserved.
//

#import "ViewController.h"
#import "AYRectTransformPanel.h"
#import "AYRectTransformPanel.h"
#import "AYRectView.h"
#import "AYTransformElementView.h"
#import "AYRectTransformPanelHandler.h"

@interface ViewController ()
@property (nonatomic, strong) AYRectTransformPanel *transformPanel;
@property (nonatomic, strong) AYRectTransformPanelHandler *transformPanelHandler;
@property (nonatomic, strong) AYRectView *rectView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, weak) AYTransformElementView *elementView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.transformPanel];
    [self.view addSubview:self.rectView];
//    self.transformPanelHandler = [[AYRectTransformPanelHandler alloc] initWithPanel:self.transformPanel];

    [self confRectView];
    [self initDatas];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 44, 44)];
    [self.btn setTitle:@"btn" forState:UIControlStateNormal];
    [self.btn setTitleColor:randomColor() forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    // Do any additional setup after loading the view.
}

- (void)confRectView {
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
    [self.rectView setTapDeleteCallback:^{
        __strong typeof(self) self = wself;
        [self.transformPanel removeElement:self.elementView];
        [self.rectView resetRotateRect];
    }];
    [self.rectView setTapEditCallback:^{
        NSLog(@"");
    }];
}

- (void)btnAction:(UIButton *)sender {
    self.rectView.disableDot = !self.rectView.disableDot;
}

- (AYRectTransformPanel *)transformPanel {
    if (!_transformPanel) {
        _transformPanel = [[AYRectTransformPanel alloc] initWithFrame:self.view.bounds];
    }
    return _transformPanel;
}

- (AYRectView *)rectView {
    if (!_rectView) {
        _rectView = [[AYRectView alloc] initWithFrame:self.view.bounds];
    }
    return _rectView;
}

- (void)initDatas {
    for (int i = 0; i < 2; i++) {
        AYTransformElementView *view = [[AYTransformElementView alloc] initWithFrame:CGRectMake(100, 50 + i * 80, 90, 60)];
        view.rotateRect = view.defRotateRect;
        view.backgroundColor = randomColor();
        [self.transformPanel addElement:view];
    }
    
    NSArray *strs = @[@"YLCHUN", @"ylcc"];
    for (int i = 0; i < strs.count; i ++) {
        AYTransformElementLabel *label = [[AYTransformElementLabel alloc] initWithFrame:CGRectMake(100, 300 + i * 30, 0 , 0)];
        label.text = strs[i];
        [label sizeToFit];
        label.rotateRect = label.defRotateRect;
        label.textColor = randomColor();
        [self.transformPanel addElement:label];
    }
    
    NSArray *imgs = @[@"apple"];
    for (int i = 0; i < imgs.count; i ++) {
        AYTransformElementImageView *imageView = [[AYTransformElementImageView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:imgs[i]];
        imageView.rotateRect = imageView.defRotateRect;
        [self.transformPanel addElement:imageView];
    }
}

static UIColor *randomColor() {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
    
@end
