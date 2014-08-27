//
//  AppDelegate.m
//  KioskBrowser
//
//  Created by Jamie White on 21/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // https://www.youtube.com/watch?v=ALDmCw41uJ0
    // http://www.jaimerios.com/?p=56
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/nswindow_Class/Reference/Reference.html
   
    [[self window] setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadNotificationRecieved:)
                                                 name:@"RELOAD_URL"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWebBackEvent:)
                                                 name:@"WEB_BACK"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWebFwdEvent:)
                                                 name:@"WEB_FWD"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onWebHomeEvent:)
                                                 name:@"WEB_HOME"
                                               object:nil];
   
    
    [self loadDefaultValues];
    [self loadUrlInTextField];
    
}

-(void) loadDefaultValues
{
    NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
    if(urlString != nil) {
        self.urlText.stringValue = urlString;
        NSLog(@"Loaded string %@", urlString);
    }
    
    float timeout = [[NSUserDefaults standardUserDefaults] floatForKey:@"timeout"];
    if(timeout > 0) {
        NSLog(@"timeout: %f", timeout);
        window.webViewTimeout.floatValue = timeout;
    }
}

-(void) reloadNotificationRecieved: (NSNotification *) notification
{
    if([[notification name] isEqualToString:@"RELOAD_URL"]) [self loadUrlInTextField];
}

-(void) onWebBackEvent: (NSNotification *) notification
{
    if([[notification name] isEqualToString:@"WEB_BACK"]) [[self webView] goBack];
}

-(void) onWebFwdEvent: (NSNotification *) notification
{
    if([[notification name] isEqualToString:@"WEB_FWD"]) [[self webView] goForward];
}

-(void) onWebHomeEvent: (NSNotification *) notification
{
    if([[notification name] isEqualToString:@"WEB_HOME"]) [self loadUrlInTextField];
}

- (IBAction)quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}


- (IBAction)saveAndRefresh:(id)sender {
    // clear history
    [[self webView] setMaintainsBackForwardList:NO];
    [[self webView] setMaintainsBackForwardList:YES];

    [[[self window] adminPanel] setHidden:YES];
    [self saveDefaults];
    [self loadUrlInTextField];
}

-(void)saveDefaults
{
    [[NSUserDefaults standardUserDefaults] setValue:self.urlText.stringValue forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] setFloat:window.webViewTimeout.floatValue forKey:@"timeout"];
}

-(void)loadUrlInTextField
{
    NSURL *url = [NSURL URLWithString:self.urlText.stringValue];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [[[self webView] mainFrame] loadRequest:urlRequest];
    
    [window resetTimeout];
}

@end
