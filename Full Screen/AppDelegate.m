//
//  AppDelegate.m
//  Full Screen
//
//  Created by Alonso on 17/03/2018.
//  Copyright © 2018 Alonso. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.delegate = self;
    [self.window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];
    [self.window toggleFullScreen:nil];

//    //以下为向右滑屏代码
//    CGEventRef event = CGEventCreateKeyboardEvent(NULL, 124, true);
//    CGEventSetFlags(event,  kCGEventFlagMaskControl);
//    CGEventPost(kCGSessionEventTap, event);
//    CFRelease(event);
//    event = CGEventCreateKeyboardEvent(NULL, 124, false);
//    CGEventSetFlags(event,  kCGEventFlagMaskControl);
//    CGEventPost(kCGSessionEventTap, event);
//    CFRelease(event);
    
    CGEventMask eventMask = CGEventMaskBit(kCGEventLeftMouseDown) | CGEventMaskBit(kCGEventLeftMouseUp);
    CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, eventMask, eventCallback, NULL);
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
    CFRelease(eventTap);
    CFRelease(runLoopSource);
    
}




static CGEventRef eventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    CGPoint location  = CGEventGetLocation(event);
    NSSize screenSize = [[NSScreen mainScreen] frame].size;
    if( location.y > screenSize.height*0.66 )
        return NULL;
    else
        return event;
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window toggleFullScreen:self];
    });
}

@end
