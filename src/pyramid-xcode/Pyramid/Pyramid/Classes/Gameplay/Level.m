//
//  Level.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 20/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "Utils.h"

#import "Level.h"

@implementation Level

- (id) initWithNumber:(int)number {
    _number = number;
    return self;
}

- (void) setResultSeconds:(NSTimeInterval)resultSeconds {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:resultSeconds forKey:[NSString stringWithFormat:LEVEL_RESULT_SECONDS_KEY_TEMPLATE, _number ]];
}

- (NSTimeInterval) resultSeconds {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults doubleForKey: [NSString stringWithFormat:LEVEL_RESULT_SECONDS_KEY_TEMPLATE, _number ]];
}

- (NSString *) getResultTimeIntervalString {
    return [Utils getTimeIntervalString:self.resultSeconds];
}

- (BOOL) hasResult {
    return self.resultSeconds > 0;
}

+ (int) getBallSize:(int) level {
    return ceilf((0.0 + level) / 3.0);
}

+ (int) getBallsNumber:(int) level {
    int number = level % 3;
    if (0 == number) {
        number = 3;
    }
    return number;
}

- (int) getBallSize {
    return [Level getBallSize:_number];
}

- (int) getBallsNumber {
    return [Level getBallsNumber:_number];
}

- (int) number {
    return _number;
}


@end
