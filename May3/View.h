//
//  View.h
//  May3
//
//  Created by John Eiche on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class May3ViewController;

@interface View : UIView {
    May3ViewController *viewController;
    UITextView *textView;
    UISwitch *mySwitch;
    UISlider *slider;
    UILabel *label;
    UISegmentedControl *control;
}

- (id) initWithFrame: (CGRect) frame controller: (May3ViewController *) c;


@property (strong, nonatomic) UISwitch *mySwitch;
@property (strong, nonatomic) UISlider *slider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *control;

@end
