#import <Cocoa/Cocoa.h>
#import "GrowlDisplayPlugin.h"

@class GrowlApplicationNotification;

@interface GrowlITTSWDisplay : GrowlDisplayPlugin {
}

- (void) displayNotification:(GrowlApplicationNotification *)notification;

@end
