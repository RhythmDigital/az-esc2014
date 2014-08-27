//
//  KioskWindow.m
//  KioskBrowser
//
//  Created by Jamie White on 21/08/2014.
//  Copyright (c) 2014 Rhythm Digital Ltd. All rights reserved.
//

#import "KioskWindow.h"
#import "JFHotkeyManager.h"

@implementation KioskWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
#if MD_DEBUG
	NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
	NSRect screenRect = [[NSScreen mainScreen] frame];
	if ((self = [super initWithContentRect:NSMakeRect(screenRect.origin.x, screenRect.origin.y, NSWidth(screenRect), NSHeight(screenRect))
                                 styleMask:NSBorderlessWindowMask
                                   backing:NSBackingStoreBuffered defer:deferCreation])) {
		[self setOpaque:NO];
		[self setLevel:CGShieldingWindowLevel()];
	}
	return self;
}


// Windows created with NSBorderlessWindowMask normally can't be key, but we want ours to be
- (BOOL)canBecomeKeyWindow {
#if MD_DEBUG
	NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}
- (IBAction)onHomeButtonDown:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEB_HOME" object:self];
}

- (IBAction)onBackButtonDown:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEB_BACK" object:self];
}

- (IBAction)onFwdButtonDown:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEB_FWD" object:self];
}


- (void)keyDown:(NSEvent *)e
{
    NSLog(@"PREV: %d, NEW: %d", self.prevKey, e.keyCode);
    
    NSInteger firstKey = 53; // esc
    NSInteger lastKey = 46; // m
    
    // ESC + F2
    if(e.keyCode == firstKey)
    {
        // set timer to reset the prev key.
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(resetPrevKey) userInfo:nil repeats:NO];
    }
    
    if(self.prevKey == firstKey && e.keyCode == lastKey) {
        [self loadAdminPanel];
    }
    
    
    self.prevKey = e.keyCode;
}

-(void)resetPrevKey
{
    NSLog(@"Reset prev key");
    self.prevKey = 0;
}

-(void)resetTimeout
{
    if([self mouseTimer])
    {
        [[self mouseTimer] invalidate];
        self.mouseTimer = nil;
    }
    
    self.mouseTimer = [NSTimer scheduledTimerWithTimeInterval:self.webViewTimeout.floatValue target:self selector:@selector(timerTick) userInfo:nil repeats:NO];
}

-(void)timerTick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_URL" object:self];
}

-(void)mouseMoved:(NSEvent *)e
{
    [super mouseMoved:e];
    [self resetTimeout];
}

- (void)loadAdminPanel
{
    [[self adminPanel] setHidden:NO];
}


@end
