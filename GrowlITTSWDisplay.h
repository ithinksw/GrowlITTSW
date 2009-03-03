/*
 *	GrowlITTSW
 *	GrowlITTSWDisplay.h
 *
 *	Copyright (c) 2009 iThink Software
 *
 */

#import <Cocoa/Cocoa.h>
#import "GrowlDisplayPlugin.h"
#import "GrowlITTSWPrefs.h"

@class GrowlApplicationNotification;

@interface GrowlITTSWDisplay : GrowlDisplayPlugin {
}

- (void) displayNotification:(GrowlApplicationNotification *)notification;

@end
