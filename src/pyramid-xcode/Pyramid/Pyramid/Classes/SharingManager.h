//
//  SharingManager.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 19/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharingManager : NSObject

+ (SharingManager *)instance;
- (void) shareApplication:(UIViewController *)controller;
- (void) shareScore:(UIViewController *)controller level:(int)level timeString:(NSString*)timeString;

@end
