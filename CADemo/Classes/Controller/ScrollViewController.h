//
//  ScrollViewController.h
//  CADemo
//
//  Created by プー坊 on 11/07/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *leftArrowImageView;
    IBOutlet UIImageView *rightArrowImageView;
}

@end
