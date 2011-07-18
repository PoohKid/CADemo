//
//  ScrollViewController.m
//  CADemo
//
//  Created by プー坊 on 11/07/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ScrollViewController (Private)
- (void)adjustScrollRect:(UIScrollView *)scrollView;
@end

@implementation ScrollViewController

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

    //スクロール対象の横長Viewを生成
    NSArray *images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"enasi.png"],
                       [UIImage imageNamed:@"gerosi.png"],
                       [UIImage imageNamed:@"gifusi.png"],
                       [UIImage imageNamed:@"ginantyou.png"],
                       [UIImage imageNamed:@"gujyousi.png"],
                       nil];
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 * [images count], 200)] autorelease];
    view.backgroundColor = [UIColor clearColor]; //背景を透明色にする
    for (int i = 0; i < [images count]; i++) {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake((200 * i) + 5, 5, 190, 190)] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [images objectAtIndex:i];
        imageView.layer.borderWidth = 2;                                //枠線の太さ
        imageView.layer.borderColor = [[UIColor blackColor] CGColor];   //枠線の色
        imageView.layer.cornerRadius = 8;                               //角の丸みの半径
        imageView.layer.masksToBounds = YES;                            //丸くした角の部分を透過する
        [view addSubview:imageView];
    }
    [scrollView addSubview:view];
    scrollView.contentSize = view.frame.size; //コンテンツビューのサイズを指定
    scrollView.delegate = self;

    //左右矢印の初期値
    leftArrowImageView.alpha = 0;
    rightArrowImageView.alpha = 1;
}

- (void)viewDidUnload
{
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

- (void)adjustScrollRect:(UIScrollView *)sv
{
    int x = (int)sv.contentOffset.x; //余り計算はfloatだとエラーになるためintにキャスト
    if ((x % 200) != 0) {
        x += 50;        //49捨50入
        x -= x % 200;   //200の倍数にそろえる
        NSLog(@"x = %d", x);
        [scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        //[scrollView scrollRectToVisible:CGRectMake(x, 0, 200, 200) animated:YES]; //上と同じ
    } else {
        NSLog(@"x %% 200 == 0");
    }

    //左右矢印の表示切り替え
    if (x == 0) {
        leftArrowImageView.alpha = 0;
    } else {
        leftArrowImageView.alpha = 1;
    }
    if (x == sv.contentSize.width - 200) {
        rightArrowImageView.alpha = 0;
    } else {
        rightArrowImageView.alpha = 1;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate
{
    //ドラッグ終了時、decelerateがYESだとスクロールが残っているためスクロール終了後にscrollViewDidEndDeceleratingが呼ばれる
    //NSLog(@"scrollViewDidEndDragging: %f, %f, %d", sv.contentOffset.x, sv.contentOffset.y, decelerate);
    if (decelerate == NO) {
        [self adjustScrollRect:sv];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{
    //スクロール終了時
    //NSLog(@"scrollViewDidEndDecelerating: %f, %f", sv.contentOffset.x, sv.contentOffset.y);
    [self adjustScrollRect:sv];
}

@end
