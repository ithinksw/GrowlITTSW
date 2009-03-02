//
//  GrowlITTSWController.h
//  Growl
//
//  Created by Joseph Spiros on 2/28/09.
//  Copyright 2009 iThink Software. All rights reserved.
//

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

- (void)showWindowWithTitle:(NSString *)title text:(NSString *)text image:(NSImage *)image;

@end
