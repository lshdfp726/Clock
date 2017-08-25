//
//  ViewController.m
//  aClock
//
//  Created by fns on 2017/8/21.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

@property (weak, nonatomic) IBOutlet UIImageView *minImage;
@property (weak, nonatomic) IBOutlet UIImageView *hourImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.secondImage.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minImage.layer.anchorPoint    = CGPointMake(0.5, 0.9f);
    self.hourImage.layer.anchorPoint   = CGPointMake(0.5, 0.9f);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self updateHandsAnimated:YES];
    }];
    
    [self updateHandsAnimated:NO];
}


- (void)updateHandsAnimated:(BOOL)animated {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hours  = (components.hour /12.0) * M_PI * 2.0;
    CGFloat min    = (components.minute /60.0) * M_PI * 2.0;
    CGFloat second = (components.second /60.0) * M_PI * 2.0;
    
    [self setAngle:hours forHand:self.hourImage animated:animated];
    [self setAngle:min forHand:self.minImage animated:animated];
    [self setAngle:second forHand:self.secondImage animated:animated];
}


- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated {
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.fillMode = kCAFillModeBackwards;
        animation.removedOnCompletion = NO;
        animation.fromValue = [handView.layer.presentationLayer valueForKey:@"transform"];
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 0.5;
        animation.delegate = self;
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.95 :1];
        [animation setValue:handView forKey:@"handView"];
        [handView.layer addAnimation:animation forKey:nil];
        [self updateHandsAnimated:NO];
    } else {
        handView.layer.transform = transform;
    }
}


- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    UIView *handerView = [anim valueForKey:@"handView"];
    handerView.layer.transform = [anim.toValue CATransform3DValue];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
