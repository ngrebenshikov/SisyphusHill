//
//  UniversalUIViewController.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 23/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "UniversalUIViewController.h"
#import "Utils.h"

@implementation UniversalUIViewController

+ (BOOL)isRetina{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?1:0;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (NULL != nibNameOrNil) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            NSString * format = IS_WIDESCREEN ? @"%@_iPhoneWide" : @"%@_iPhone";
            nibNameOrNil = [NSString stringWithFormat:format, nibNameOrNil];
        } else {
            nibNameOrNil = [NSString stringWithFormat:@"%@_iPad", nibNameOrNil];
        }
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

@end
