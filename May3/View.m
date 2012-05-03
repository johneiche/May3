//
//  View.m
//  May3
//
//  Created by John Eiche on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "View.h"
#import "May3ViewController.h"

@implementation View

@synthesize control;
@synthesize mySwitch;
@synthesize slider;


// retrofit a volume slider control  

- (void) volumeChanged: (id) sender {
	UISlider *s = sender;
    
    
    
    //Call the volumeChanged: method of the application delegate
    //when the value of the slider is changed.
    
    [slider addTarget: [UIApplication sharedApplication].delegate
               action: @selector(volumeChanged:)
     forControlEvents: UIControlEventValueChanged
     ];
        
	float red = (s.value - s.minimumValue)
    / (s.maximumValue - s.minimumValue);
    
	slider.backgroundColor = [UIColor colorWithRed:
                              red green: 0.0 blue: 1.0 - red alpha: 1.0];
    
	label.text = [NSString stringWithFormat: @"Volume == %5.1f\%",
                  slider.value];
    
  }
// retrofit a volume slider control 

- (id) initWithFrame: (CGRect) frame controller: (May3ViewController *) c
{
	self = [super initWithFrame: frame];
	if (self) {
		// Initialization code
		self.backgroundColor = [UIColor whiteColor];
		viewController = c;
        
	/*	code for switch control begin
     
        //Do not specify a size for the switch.
		//Let the switch assume its own natural size.
		mySwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
		if (mySwitch == nil) {
			return nil;
		}
        
		//Call the valueChanged: method of the application delegate
		//when the value of the switch is changed.
		
		[mySwitch addTarget: [UIApplication sharedApplication].delegate
                     action: @selector(valueChanged:)
           forControlEvents: UIControlEventValueChanged
         ];
		
		//Center the switch in the SwitchView.
		CGRect b = self.bounds;
        
		mySwitch.center = CGPointMake(
                                      b.origin.x + b.size.width / 2,
                                      b.origin.y + b.size.height / 2
                                      );
        
		mySwitch.on = NO;	//the default
		[self addSubview: mySwitch];
     
      //code for switch control end
        */
        
    //Create the segmented control. begin
        
		NSArray *items = [NSArray arrayWithObjects:
                          @"Pause",
                          @"Stop",
                          @"Play",
                          nil
                          ];
        
		control = [[UISegmentedControl alloc] initWithItems: items];
		control.segmentedControlStyle = UISegmentedControlStylePlain;	//default
		control.momentary = NO;		//default
        
		//Can't play until we have recorded something.
	//	[control setEnabled: NO forSegmentAtIndex: 2];
        
		//Center the control in the SegmentedView.
		CGRect b = self.bounds;
        
		control.center = CGPointMake(
                                     b.origin.x + b.size.width / 2,
                                     b.origin.y + b.size.height / 2
                                     );
        
		[control addTarget: [UIApplication sharedApplication].delegate
                    action: @selector(valueChanged:)
          forControlEvents: UIControlEventValueChanged
         ];
        
		[self addSubview: control];
        
    //  segmented  control end
        
    // retrofit a volume slider control        
        
        float minimumValue = 0;	// minimum volume
		float maximumValue = 100.0;  // maximum volume
        
    //Center the slider in the View. below the switch
		//CGRect b = self.bounds;
		CGSize s = CGSizeMake(200, 16);
        
		CGRect f = CGRectMake(
                              b.origin.x + (b.size.width - s.width) / 2,
                              b.origin.y + 10 +  control.frame.size.height + (b.size.height - s.height) / 2,
                              s.width,
                              s.height
                              );
        
		slider = [[UISlider alloc] initWithFrame: f];
        
        //90 degrees counterclockwise
        //slider.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180);
        
		slider.minimumValue = minimumValue;
		slider.maximumValue = maximumValue;
		slider.value = (minimumValue + maximumValue) / 2;
		slider.continuous = YES ;	//default is YES
        
		//As the slider goes from the minimum to the maximum value,
		//red goes from 0 to 1.  Conversely, blue goes from 1 to 0.
        
		CGFloat red = (slider.value - slider.minimumValue)
        / (slider.maximumValue - slider.minimumValue);
        
		slider.backgroundColor = [UIColor colorWithRed:
                                  red green: 0.0 blue: 1.0 - red alpha: 1.0];
        
		[slider addTarget:self
                   action: @selector(volumeChanged:)
         forControlEvents: UIControlEventValueChanged
         ];
        
		[self addSubview: slider];
        
        
        //Put the label below the slider
		//with a 10-pixel margin between them.
		UIFont *font = [UIFont fontWithName: @"Courier" size: 26];
		s = [@"Volume == 123.4f\%" sizeWithFont: font];
        
    // 30 added as fudge factor.     
        f = CGRectMake(
                       b.origin.x + (b.size.width - s.width) / 2,
                       b.origin.y + s.height + 30 + (b.size.height + slider.frame.size.height) / 2,
                       s.width,
                       s.height
                       );
        
        
        
		label = [[UILabel alloc] initWithFrame: f];
		label.textAlignment = UITextAlignmentCenter;
		label.font = font;
		[self volumeChanged: slider];
		[self addSubview: label];
        
        
        // retrofit a volume slider control          
        
        
        
		}    return self;
}

//*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 // Drawing code
 // Drawing code
    
    
    
  }
 
 
 @end