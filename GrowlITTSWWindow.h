/*
 *	GrowlITTSW
 *	GrowlITTSWWindow.h
 *
 *	Copyright (c) 2009 iThink Software
 *
 */

#import <Cocoa/Cocoa.h>
#import <ITKit/ITKit.h>

#define SMALL_DIVISOR       1.33333
#define MINI_DIVISOR        1.66667

@interface GrowlITTSWWindow : ITTransientStatusWindow {
	NSImage *_image;
	NSTextField *_textField;
}

- (void)setImage:(NSImage *)newImage;
- (void)buildTextWindowWithString:(id)text;

@end
