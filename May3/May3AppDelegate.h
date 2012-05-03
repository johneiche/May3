//
//  May3AppDelegate.h
//  May3
//
//  Created by John Eiche on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
@class View;
@class May3ViewController;

@interface May3AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate > {
    May3ViewController *_viewController;
    UIWindow *_window;
    AVAudioSession *session;
    NSURL *url;
    AVAudioPlayer *player;
    View *view;    
}

-(void) valueChanged: (id) sender;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) May3ViewController *viewController;

@end
