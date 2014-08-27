//
//  KioskWindow.h
//  KioskBrowser
//
//  Created by Jamie White on 21/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AdminView.h"

@interface KioskWindow : NSWindow

@property (readwrite) unsigned short prevKey;
@property (retain) IBOutlet AdminView *adminPanel;
@property (strong) NSTimer *mouseTimer;
@property (weak) IBOutlet NSTextField *webViewTimeout;

-(void)resetTimeout;

@end
