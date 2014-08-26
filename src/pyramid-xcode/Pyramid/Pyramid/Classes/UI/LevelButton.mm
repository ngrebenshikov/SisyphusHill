//
//  LevelButton.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 15/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <UIKit/UIImage.h>
#import <CoreText/CoreText.h>

#import "LevelButton.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"

#import "AppController.h"


@implementation LevelButton {
    int _level;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont fontWithName:@"PTSans-Regular" size:[self fontSize]];
    }
    return self;
}

- (int) width {
    return (IS_IPAD) ? 220 : 110;
}

- (int) height {
    return (IS_IPAD) ? 120 : 60;
}

- (int) fontSize {
    return (IS_IPAD) ? 25 : 15;
}

- (int) factor {
    return (IS_IPAD) ? 2 : 1;
}

- (void) configureFlatButton {
    UIImage *libNormalBackgroundImage = [UIImage buttonImageWithColor:self.buttonColor
                                                      cornerRadius:self.cornerRadius
                                                       shadowColor:self.shadowColor
                                                      shadowInsets:UIEdgeInsetsMake(0, 0, self.shadowHeight, 0)];
    
    UIColor *color = self.highlightedColor == nil ? self.buttonColor : self.highlightedColor;
    UIImage *libHighlightedBackgroundImage = [UIImage buttonImageWithColor:color
                                                           cornerRadius:self.cornerRadius
                                                            shadowColor:[UIColor clearColor]
                                                           shadowInsets:UIEdgeInsetsMake(self.shadowHeight, 0, 0, 0)];
    
    [self setBackgroundImage:[self putLevelInformationToBackground:libNormalBackgroundImage shadowInsets:UIEdgeInsetsMake(self.shadowHeight, 0, 0, 0)]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[self putLevelInformationToBackground:libHighlightedBackgroundImage shadowInsets:UIEdgeInsetsMake(self.shadowHeight, 0, 0, 0)]
                    forState:UIControlStateHighlighted];
}

- (UIImage *) putLevelInformationToBackground:(UIImage *)background shadowInsets:(UIEdgeInsets)shadowInsets {
    CGRect rect = [self getButtonRect];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0f);
    CGContextRef g = UIGraphicsGetCurrentContext();
    [background drawInRect:rect];
    
    AppController * app = [AppController instance];
    Level * l = [app.levels objectAtIndex:self.level-1];
    
    CGContextSetGrayFillColor(g, 1.0, 1.0);
    
    // Draw balls
    {
        float r = [self getBallRadius:self.level];
        float y = rect.size.height - 12 * [self factor] - r;
        float x = 15 * [self factor];
        for (int i=0; i < [Level getBallsNumber:self.level]; i++) {
            CGRect borderRect = CGRectMake(x, y, r, r);
            CGContextFillEllipseInRect (g, borderRect);
            x += 1.25  * r;
        }
    }
    
    // Draw tick if needed
    if (l.resultSeconds > 0) {
        float x = 80 * [self factor];
        float y = 40 * [self factor];
        float d = 5 * [self factor];
        
        CGContextSetStrokeColorWithColor(g, [UIColor colorFromHexCode:@"be5e2a"].CGColor);
        CGContextSetLineWidth(g, 1);
        CGContextMoveToPoint(g, x + 1, y);
        CGContextAddLineToPoint(g, x + d, y + d - 1);
        CGContextAddLineToPoint(g, x + 3*d, y - d);
        CGContextStrokePath(g);

        CGContextSetStrokeColorWithColor(g, [UIColor colorFromHexCode:@"ffffff"].CGColor);
        CGContextSetLineWidth(g, 2);
        CGContextMoveToPoint(g, x, y + 1);
        CGContextAddLineToPoint(g, x + d, y + d + 1);
        CGContextAddLineToPoint(g, x + 3*d + 1, y - d + 1);
        CGContextStrokePath(g);
    }
        
    // Flip the coordinate system for Core Text
    CGContextSetTextMatrix(g, CGAffineTransformIdentity);
    CGContextTranslateCTM(g, 0, 35);
    CGContextScaleCTM(g, 1.0, -1.0);
    
    //Draw result time
    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(70, 10, 50, 15));
//    
//    CTFontRef helveticaBold = CTFontCreateWithName( CFSTR("Helvetica-Bold"), 24.0, NULL);
//    
//    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:
//                            (id)[UIColor colorFromHexCode:@"ffffff"].CGColor, (NSString *)kCTForegroundColorAttributeName,
//                            (__bridge id)helveticaBold, (NSString *)kCTFontAttributeName,
//                            nil];
//    NSAttributedString * resultAttString = [[NSAttributedString alloc] initWithString:[l getResultTimeIntervalString] attributes:attrs];
//    
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)resultAttString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [resultAttString length]), path, NULL);
//    
//    CTFrameDraw(frame, g);
    
    // Prepare font
    CTFontRef font = CTFontCreateWithName(CFSTR("PTSans-Regular"), [self fontSize] - [self factor]*2, NULL);
    
    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName };
    CFTypeRef values[] = { font, [UIColor colorFromHexCode:@"ffffff"].CGColor};
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef attrString = CFAttributedStringCreate(NULL, (CFStringRef)[l getResultTimeIntervalString], attr);
    CFRelease(attr);
    
    // Draw the string
    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    CGContextSetTextMatrix(g, CGAffineTransformIdentity);  //Use this one when using standard view coordinates
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0)); //Use this one if the view's coordinates are flipped
    
    CGContextSetTextPosition(g,
                             (IS_IPAD) ? 150 : 67,
                             (IS_IPAD) ? -10 : 13);
    CTLineDraw(line, g);
    
    // Clean up
    CFRelease(line);
    CFRelease(attrString);
    CFRelease(font);
    
    //Draw graphics context on background
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIEdgeInsets resizeableInsets = UIEdgeInsetsMake(self.cornerRadius + shadowInsets.top,
                                                     self.cornerRadius + shadowInsets.left,
                                                     self.cornerRadius + shadowInsets.bottom,
                                                     self.cornerRadius + shadowInsets.right);
    
    return [image resizableImageWithCapInsets:resizeableInsets];
}

- (void) setLevel:(int)level {
    _level =  level;
    [self configureFlatButton];
}

- (int) level {
    return _level;
}

- (void) setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"level"])
    {
        self.level = [value intValue];
    }
}

- (CGRect) getButtonRect {
    return CGRectMake(0, 0, [self width], [self height]);
}

- (float) getBallRadius:(int) level {
    return 10*[self factor] + 2.5*([Level getBallSize:level]-1)*[self factor];
}

@end
