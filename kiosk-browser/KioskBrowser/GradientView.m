//
//  GradientView.m
//  KioskBrowser
//
//  Created by Jamie White on 27/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [self setWantsLayer:YES];
       // self.layer.borderWidth = 5.f;
       // self.layer.borderColor = [NSColor blackColor].CGColor;
        //[self setWantsLayer:NO];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor lightGrayColor] set];
    
    
    NSString* hex = @"ffffff";
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != hex)
    {
        NSScanner* scanner = [NSScanner scannerWithString:hex];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    
    [result set];
    
    
    NSRectFill([self bounds]);
}

@end
