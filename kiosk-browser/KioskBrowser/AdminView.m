//
//  AdminView.m
//  KioskBrowser
//
//  Created by Jamie White on 22/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import "AdminView.h"

@implementation AdminView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        self.layer.borderWidth = 5.f;
        self.layer.borderColor = [NSColor blackColor].CGColor;
        //[self setWantsLayer:NO];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);
}

@end