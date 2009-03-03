/*
 *	GrowlITTSW
 *	GrowlITTSWController.h
 *
 *	Copyright (c) 2009 iThink Software
 *
 */

#import <Cocoa/Cocoa.h>
#import <ITFoundation/ITSharedController.h>
#import "GrowlITTSWWindow.h"

@interface GrowlITTSWController : ITSharedController {
	GrowlITTSWWindow *_window;
	float _imageSize;
	BOOL _imageNoUpscale;
	BOOL _wrapNotifications;
	int _wrapColumns;
}

- (void)showWindowWithTitle:(NSString *)title desc:(NSString *)desc image:(NSImage *)image;

@end
