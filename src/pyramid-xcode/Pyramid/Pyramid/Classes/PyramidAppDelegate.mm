/**
 *  PyramidAppDelegate.m
 *  Pyramid
 *
 *  Created by Nickolay Grebenshikov on 19/03/14.
 *  Copyright Nickolay Grebenshikov 2014. All rights reserved.
 */


#import "PyramidAppDelegate.h"

#import <Socialize/Socialize.h>

#import "PyramidLayer.h"
#import "PyramidScene.h"
#import "CC3CC2Extensions.h"

#import "AppController.h"

@implementation PyramidAppDelegate


-(void) applicationDidFinishLaunching: (UIApplication*) application {
    [Socialize storeLocationSharingDisabled:true];
    [Socialize storeConsumerKey:@"8bd79d98-899e-4341-85a6-515fbda8f454"];
    [Socialize storeConsumerSecret:@"8a1a2dda-df66-4aab-8d73-e80dfd100dd3"];
    //[SZFacebookUtils setAppId:@"686732571382195"];
    [SZTwitterUtils setConsumerKey:@"Kts61XqQpN5dg3aFLs0Aer8Fk" consumerSecret:@"iSmgmC9WnLNlYt8BTc5qFelVWrcqNhFMuKM9og0BqHlj3MsknG"];
    [AppController startApplication];
}

-(void) applicationWillResignActive: (UIApplication*) application {
    [((AppController *)[AppController instance]).ccViewController pauseAnimation];
}

/** Resume the cocos3d/cocos2d action. */
-(void) resumeApp { [((AppController *)[AppController instance]).ccViewController resumeAnimation]; }

-(void) applicationDidBecomeActive: (UIApplication*) application {
	
	// Workaround to fix the issue of drop to 40fps on iOS4.X on app resume.
	// Adds short delay before resuming the app.
	[NSTimer scheduledTimerWithTimeInterval: 0.25
									 target: self
								   selector: @selector(resumeApp)
								   userInfo: nil
									repeats: NO];
	
	// If dropping to 40fps is not an issue, remove above, and uncomment the following to avoid delay.
	//	[self resumeApp];
}

-(void) applicationDidReceiveMemoryWarning: (UIApplication*) application {
}

-(void) applicationDidEnterBackground: (UIApplication*) application {
    [((AppController *)[AppController instance]).ccViewController stopAnimation];
}

-(void) applicationWillEnterForeground: (UIApplication*) application {
    [((AppController *)[AppController instance]).ccViewController startAnimation];

}

-(void)applicationWillTerminate: (UIApplication*) application {
    [((AppController *)[AppController instance]).ccViewController terminateOpenGL];
}

-(void) applicationSignificantTimeChange: (UIApplication*) application {
	[CCDirector.sharedDirector setNextDeltaTimeZero: YES];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}



@end
