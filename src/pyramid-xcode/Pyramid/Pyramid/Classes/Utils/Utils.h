//
//  Utils.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 06/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_5 (IS_IPHONE && IS_WIDESCREEN)
#define IS_IPAD_RETINA (IS_IPAD && IS_RETINA)


@interface Utils : NSObject
+(float) minByAbs:(float)f absolut:(float)absolut;
+ (NSString *) getTimeIntervalString:(NSTimeInterval)interval;
@end
