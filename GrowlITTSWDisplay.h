#import <Cocoa/Cocoa.h>
#import "GrowlDisplayPlugin.h"
#import "GrowlITTSWPrefs.h"

@class GrowlApplicationNotification;

@interface GrowlITTSWDisplay : GrowlDisplayPlugin {
}

- (void) displayNotification:(GrowlApplicationNotification *)notification;

@end
