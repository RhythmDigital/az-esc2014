//
//  KioskWindowController.m
//  KioskBrowser
//
//  Created by Jamie White on 21/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import "KioskWindowController.h"

@interface KioskWindowController ()

@end

@implementation KioskWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        NSLog(@"IT'S WORKING!");
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
