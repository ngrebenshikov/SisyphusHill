//
//  SharingManager.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 19/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>

#import "SharingManager.h"

@implementation SharingManager

+ (SharingManager *)instance {
    static SharingManager *c = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        c = [[self alloc] init];
    });
    return c;
}

- (void) shareCommon:(UIViewController *) controller title:(NSString*)title text:(NSString*)text {
    id<SZEntity> entity = [SZEntity entityWithKey:@"http://bit.ly/1kTr8Yu" name:@"SisyphusHill (iOS 3D simulation game)"];
    SZShareDialogViewController *share = [[SZShareDialogViewController alloc] initWithEntity:entity];
    
    share.title = title;
    SZShareOptions *options = [SZShareUtils userShareOptions];
    options.text = text;
    share.shareOptions = options;
    
    share.completionBlock = ^(NSArray *shares) {
        // Dismiss however you want here
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    
    share.cancellationBlock = ^() {
        // Dismiss however you want here
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    
    // You can hide individual share types
    //    share.hideEmail = YES;
    share.hideSMS = YES;
    share.hideFacebook = YES;
    //    share.hideTwitter = YES;
    share.hidePinterest = YES;
    
    // Present however you want here
    [controller presentViewController:share animated:YES completion:nil];
    
    
    
    [SZShareUtils showShareDialogWithViewController:controller options:options entity:entity completion:^(NSArray *shares) {
        // `shares` is a list of all shares created during the lifetime of the share dialog
        //NSLog(@"Created %d shares: %@", [shares count], shares);
    } cancellation:^{
        //NSLog(@"Share creation cancelled");
    }];
    
}

- (void) shareApplication:(UIViewController *)controller {
    [self shareCommon:controller title:@"Tell friends about SisyphusHills" text:@"Check yourself steering the balls to the top! http://bit.ly/1kTr8Yu "];
}

- (void) shareScore:(UIViewController *)controller level:(int)level timeString:(NSString*)timeString {
    [self shareCommon:controller title:@"Tell friends about your results" text:[NSString stringWithFormat:@"Great! The level %d in time %@. Try it! http://bit.ly/1kTr8Yu", level, timeString]];
}



@end
