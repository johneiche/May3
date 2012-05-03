//
//  May3AppDelegate.m
//  May3
//
//  Created by John Eiche on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "May3AppDelegate.h"

#import "May3ViewController.h"

#define  segStop    0
#define  segPause   1
#define  segPlay    2
@class View;


@implementation May3AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSBundle *bundle = [NSBundle mainBundle];
	NSLog(@"bundle.bundelPath == \"%@\"", bundle.bundlePath);
    
	NSString *filename = [bundle pathForResource: @"musette" ofType: @"mp3"];
	NSLog(@"filename == \"%@\"", filename);
    
	NSURL *url = [NSURL fileURLWithPath: filename isDirectory: NO];
	NSLog(@"url == \"%@\"", url);
    
	NSError *error = nil;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: &error];
    
	if (player == nil) {
		NSLog(@"could not initialize player:  %@", error);
	} else {
		player.volume = 0.5;		//the default is 1. set at 50%
		player.numberOfLoops = 0;	//negative for infinite loop
		[player setDelegate: self];
		//mono or stereo
		NSLog(@"player.numberOfChannels == %u", player.numberOfChannels);
        
		if (![player prepareToPlay]) {
			NSLog(@"prepareToPlay failed");
		}
	}
    
    
    //Create an audio session that will silence other applications,
	//except for telephone ringtones and Clock and Calendar alarms.
    
	session = [AVAudioSession sharedInstance];
	    
//	NSError *error = nil;
	if (![session setCategory: AVAudioSessionCategoryPlayAndRecord error: &error]) {
		NSLog(@"AVAudioSession setCategory: %@", error);
		return YES;
	}
    
	if (![session setActive: YES error: &error]) {
		NSLog(@"AVAudioSession setActive %@", error);
		return YES;
	}
    
	NSLog(@"currentHardwareInputNumberOfChannels == %d",
		  session.currentHardwareInputNumberOfChannels);
	NSLog(@"currentHardwareOutputNumberOfChannels == %d",
		  session.currentHardwareOutputNumberOfChannels);
	NSLog(@"currentHardwareSampleRate == %g",
		  session.currentHardwareSampleRate);
	NSLog(@"preferredHardwareSampleRate == %g",
		  session.preferredHardwareSampleRate);
	NSLog(@"preferredIOBufferDuration == %g",
		  session.preferredIOBufferDuration);
    
    
    
    NSEnumerator *e = [player.settings keyEnumerator];
    NSString *key;
    
    while ((key = [e nextObject]) != nil) {
        if ([key isEqualToString: @"AVFormatIDKey"]) {
            const int i = ((NSNumber *)[player.settings objectForKey: key]).intValue;
            NSLog(@"%@ %c%c%c%c", key,
                  i >> 3 * CHAR_BIT & 0xFF,
                  i >> 2 * CHAR_BIT & 0xFF,
                  i >> 1 * CHAR_BIT & 0xFF,
                  i >> 0 * CHAR_BIT & 0xFF
                  );
        } else {
            NSLog(@"%@ %@", key, [player.settings objectForKey: key]);
        }
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
	// Override point for customization after application launch.
	self.viewController = [[May3ViewController alloc] initWithNibName: nil bundle: nil];
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark Target of UISegmentedControl

- (void) valueChanged: (id) sender {
	UISegmentedControl *control = sender;
    
	switch (control.selectedSegmentIndex) {
            
             
            //    case 0:	//Stop
        case segStop:    
			
			[player stop];
			break;
            //*  
            //    case 1: //Pause
        case segPause:  
            [player pause];
            break;
            //  */  
            //	case 2:	//Play
        case segPlay:    
			if (player == nil) {
				//Create the audio player.
                
				NSError *error = nil;
				player = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: &error];
				if (player == nil) {
					NSLog(@"AVAudioPayer initWithContentsOfURL:error: %@", error);
					break;
				}
                
				player.delegate = self;
				player.volume = 1.0;		//the default
				player.numberOfLoops = 0;	//negative for infinite loop
			}
            
			if (![player prepareToPlay]) {
				NSLog(@"AVAudioPlayer prepareToPlay failed.");
			}
            
			if (![player play]) {
				NSLog(@"AVAudioPlayer play failed.");
			}
      //      [view.control setEnabled: YES forSegmentAtIndex: segPause];
			break;
            
		default:
			NSLog(@"UISegmentedControl selectedSegmentIndex == %d",
                  control.selectedSegmentIndex);
			break;
	}
}

/*
 // switch code
- (void) valueChanged: (id) sender {
	UISwitch *s = sender;
	if (s.isOn) {
		//The switch has just been turned on.
		if (![player play]) {
			NSLog(@"[player play] failed.");
		}
	} else {
		//The switch has just been turned off.
		NSLog(@"Paused at %g of %g seconds.", player.deviceCurrentTime, player.duration);
		[player pause];
	}
}
// switch code
*/
- (void) volumeChanged: (id) sender {
	UISlider *s = sender;
	//if (s.isOn)
    //   {
    //The slider volume control has been changed
    if (![player play]) {
        NSLog(@"[player play] failed.");
        
    }
    //	} else {
    //
    else {
        player.volume = s.value / 100.0;
        NSLog(@"player.volume = %g", player.volume);
    }    		
    //NSLog(@"Paused at %g of %g seconds.", player.deviceCurrentTime, player.duration);
    //[player pause];
    //	}
}


/*
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) p successfully: (BOOL) flag {
	if (p == player) {
		[view.mySwitch setOn: NO animated: YES];	//Go back to the OFF position.
	}
}
*/

#pragma mark -
#pragma mark Delegate of AVAudioPlayer

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) p
                        successfully: (BOOL) flag {
	
	NSLog(@"audioPlayerDidFinishPlaying:successfully: %d", flag);
    
	//Unpress the Play button.
//	view.control.selectedSegmentIndex = -1;
}

- (void) audioPlayerDecodeErrorDidOccur: (AVAudioPlayer *) p
                                  error: (NSError *) error {
	
	NSLog(@"audioPlayerDecodeErrorDidOccur:error: %@", error);
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
