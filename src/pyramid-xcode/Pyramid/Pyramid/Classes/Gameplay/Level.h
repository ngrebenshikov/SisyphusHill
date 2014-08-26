//
//  Level.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 20/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LEVEL_RESULT_SECONDS_KEY_TEMPLATE @"level-%d-result-seconds"

@interface Level : NSObject {
    @public int _number;
}

@property NSTimeInterval resultSeconds;
@property (readonly) BOOL hasResult;
@property (readonly) int number;

+ (int) getBallSize:(int) level;
+ (int) getBallsNumber:(int) level;

- (id) initWithNumber:(int)number;
- (NSString *) getResultTimeIntervalString;

- (int) getBallSize;
- (int) getBallsNumber;

@end
