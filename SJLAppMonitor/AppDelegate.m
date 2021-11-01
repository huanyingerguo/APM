//
//  AppDelegate.m
//  SJLCatonDetector
//
//  Created by sunjinglin on 2021/10/23.
//

#import "AppDelegate.h"
#import "SJLCartonDetector.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[SJLCartonDetector sharedInstance] startMonitorCarton:0.5];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
