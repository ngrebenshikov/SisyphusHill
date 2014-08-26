//
//  Utils.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 06/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(float) minByAbs:(float)f absolut:(float)absolut {
    if (fabsf(f) <= absolut) {
        return f;
    } else if (f > 0) {
        return absolut;
    } else {
        return -absolut;
    }
}

+ (NSString *) getTimeIntervalString:(NSTimeInterval)interval {
    int totalSeconds = interval;
    
    if (totalSeconds > 0) {
        int seconds = totalSeconds % 60; totalSeconds /= 60;
        int minutes = totalSeconds % 60; totalSeconds /= 60;
        //        int hours = totalSeconds;
        
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    } else {
        return @"-- : --";
    }
}

@end
