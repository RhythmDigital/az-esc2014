//
//  AppDelegate.h
//  KioskBrowser
//
//  Created by Jamie White on 21/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/Webkit.h>
#import "KioskWindow.h"
#import "JFHotkeyManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet KioskWindow *window;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet JFHotkeyManager *hkm;
@property (nonatomic, retain) NSDictionary *fullScreenOptions;
@property (weak) IBOutlet NSTextField *urlText;

@end