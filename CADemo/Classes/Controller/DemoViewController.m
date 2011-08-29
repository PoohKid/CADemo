//
//  DemoViewController.m
//  CADemo
//
//  Created by プー坊 on 11/07/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DemoViewController.h"

@interface DemoViewController ()
//@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@end

@interface DemoViewController (Private)
- (void)goAnimation;
- (void)rollingAnimation;
- (void)curlAnimation;
- (void)blinkAnimation;
- (void)randomAnimation;
- (void)spotlightAnimation;
@end

@implementation DemoViewController

@synthesize mode;
//@synthesize tapGesture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    //self.tapGesture = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    srand([[NSDate date] timeIntervalSinceReferenceDate]);

    imageView.image = [UIImage imageNamed:@"background.jpg"];

    //self.tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    //[imageView addGestureRecognizer:tapGesture]; //効かない！？ -> userInteractionEnabled = YES が必要！
    //[self.view addGestureRecognizer:tapGesture];
    //[self performSelector:@selector(setGestureRecognizer) withObject:nil afterDelay:1.0f]; //NG, Delayかけてもダメ

    [self performSelector:@selector(goAnimation) withObject:nil afterDelay:0.1f]; //DelayしないとpageCurlで元画像が表示されない
}

- (void)viewDidUnload
{
    //self.tapGesture = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods

- (void)goAnimation
{
    switch (mode) {
        case 0: //くるくる回転
            [self rollingAnimation];
            break;
        case 1: //めくれる
            [self curlAnimation];
            break;
        case 2: //点滅
            [self blinkAnimation];
            break;
        case 3: //ランダム
            [self randomAnimation];
            break;
        case 4: //スポットライト
            [self spotlightAnimation];
            break;
    }
}

- (void)rollingAnimation
{
    //UIView.transform は CGAffineTransform で、CALayer.transform は CATransform3D ?
    CAKeyframeAnimation *rollingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    rollingAnimation.duration = 1.0;
    rollingAnimation.repeatCount = FLT_MAX; // 1e100f; //無限
    rollingAnimation.values = [[[NSArray alloc] initWithObjects:
                                [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 90 / 180.0f, 0, 0, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 180 / 180.0f, 0, 0, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 270 / 180.0f, 0, 0, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                nil] autorelease];
    [imageView.layer addAnimation:rollingAnimation forKey:@"rolling"];
    //[imageView.layer removeAnimationForKey:@"rolling"];
}

- (void)curlAnimation
{
    //http://www.iphonedevsdk.com/forum/iphone-sdk-development/18548-pagecurl-animation-os-3-0-a.html
    CATransition *transition = [CATransition animation];
    [transition setType:@"pageCurl"]; //逆はpageUnCurl, mapCurlは不可
    transition.duration = 1.0;
    transition.repeatCount = FLT_MAX; // 1e100f; //無限
    //transition.repeatCount = 0.5f; //効かない？
    //transition.startProgress = 0.5; //逆にする場合
    transition.endProgress = 0.5;
    transition.autoreverses = YES;
    //transition.removedOnCompletion = NO;        //
    //transition.fillMode = kCAFillModeForwards;  //この2つがセットで途中までのアニメーションが残る
    //[imageView removeFromSuperview];
    imageView.image = nil; //背景を消せるが、アニメーション終了後に画像も消える
    [imageView.layer addAnimation:transition forKey:@"curlup"];

    //めくれる感じのModalTransition
    //http://appteam.blog114.fc2.com/blog-entry-135.html
}

- (void)blinkAnimation
{
    CAKeyframeAnimation *blinkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    blinkAnimation.duration = 2.0f;
    blinkAnimation.repeatCount = FLT_MAX;
    blinkAnimation.values = [[[NSArray alloc] initWithObjects:
                              [NSNumber numberWithFloat:1.0f],
                              [NSNumber numberWithFloat:0.3f],
                              [NSNumber numberWithFloat:1.0f],
                              nil] autorelease];
    [imageView.layer addAnimation:blinkAnimation forKey:@"blink"];
}

- (void)randomAnimation
{
    //NSLog(@"cx: %f, cy: %f", imageView.center.x, imageView.center.y); //cx: 160.000000, cy: 218.000000

    int min = -50;
    int max = 50;
    int vx = min + (int)(rand() * (max - min + 1.0) / (1.0 + RAND_MAX));
    int vy = min + (int)(rand() * (max - min + 1.0) / (1.0 + RAND_MAX));

    //NSLog(@"vx: %d, vy: %d", vx, vy);

    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         imageView.center = CGPointMake(160 + vx, 218 + vy);
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"finished: %d", finished);
                         if (finished) {
                             [self randomAnimation];
                         }
                     }];
}

- (void)spotlightAnimation
{
    //完全に表示するための円の直径
    float diameter = sqrtf(powf(imageView.bounds.size.width, 2) + powf(imageView.bounds.size.height, 2));
    diameter = ceilf(diameter);   //切り上げ
    if ((int)diameter % 2 != 0) { //偶数化
        diameter += 1;
    }
    CGRect maskFrame = CGRectMake(0 - (diameter - imageView.bounds.size.width)/2,
                                  0 - (diameter - imageView.bounds.size.height)/2,
                                  diameter, diameter);

    //スポットライト用のマスク描画
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = maskFrame;
    UIGraphicsBeginImageContext(maskLayer.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, diameter, diameter));
    maskLayer.contents = (id)[UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    imageView.layer.mask = maskLayer;

    //アニメーション：マスクを1/10から1/1に変形
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0f;
    animation.repeatCount = FLT_MAX;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    [maskLayer addAnimation:animation forKey:@"spotlight"];
}

#pragma mark - IBAction methods

#pragma mark - Touch handling

//- (void)handleTapGesture:(UITapGestureRecognizer *)sender
//{
//    NSLog(@"tap");
//    
//    switch (mode) {
//        case 0: //くるくる回転
//            [self performSelector:@selector(rollingAnimation)];
//            break;
//        case 1: //めくれる
//            [self performSelector:@selector(curlAnimation)];
//            break;
//    }
//}

@end
