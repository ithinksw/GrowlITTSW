//
//  GrowlITTSWController.m
//  Growl
//
//  Created by Joseph Spiros on 2/28/09.
//  Copyright 2009 iThink Software. All rights reserved.
//

#import "GrowlITTSWController.h"
#import "GrowlITTSWWindow.h"

#import <ITKit/ITTSWBackgroundView.h>
#import <ITKit/ITWindowEffect.h>

@implementation NSImage (SmoothAdditions)

- (NSImage *)imageScaledSmoothlyToSize:(NSSize)scaledSize
{
    NSImage *newImage;
    NSImageRep *rep = [self bestRepresentationForDevice:nil];
    
    newImage = [[NSImage alloc] initWithSize:scaledSize];
    [newImage lockFocus];
    {
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [[NSGraphicsContext currentContext] setShouldAntialias:YES];
        [rep drawInRect:NSMakeRect(3, 3, scaledSize.width - 6, scaledSize.height - 6)];
    }
    [newImage unlockFocus];
    return [newImage autorelease];
}

@end

@implementation GrowlITTSWController

- (id)init
{
    if ( ( self = [super init] ) ) {
		NSArray *screens = [NSScreen screens];
        
		_window = [[GrowlITTSWWindow sharedWindow] retain];
		
		[_window setScreen:[screens objectAtIndex:0]];
		
        [_window setExitMode:ITTransientStatusWindowExitAfterDelay];
        [_window setExitDelay:4.0];
        
        [_window setHorizontalPosition:ITWindowPositionRight];
        [_window setVerticalPosition:ITWindowPositionTop];
        
        [_window setSizing:ITTransientStatusWindowMini];
        
        [_window setEntryEffect:[[[NSClassFromString(@"ITSlideVerticallyWindowEffect") alloc] initWithWindow:_window] autorelease]];
        [_window setExitEffect:[[[NSClassFromString(@"ITSlideHorizontallyWindowEffect") alloc] initWithWindow:_window] autorelease]];
        
        [[_window entryEffect] setEffectTime:0.8];
        [[_window exitEffect]  setEffectTime:0.8];
        
        [(ITTSWBackgroundView *)[_window contentView]setBackgroundMode:
		 ITTSWBackgroundReadable];
    }
    
    return self;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)showWindowWithText:(NSString *)text image:(NSImage *)image
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
	NSSize newSize;
	NSSize oldSize = [image size];
	
	if (oldSize.width > oldSize.height) {
		newSize = NSMakeSize(110.0f, (oldSize.height * (110.0f / oldSize.width)));
	} else {
		newSize = NSMakeSize((oldSize.width * (110.0f / oldSize.height)), 110.0f);
	}
	
	image = [[[[NSImage alloc] initWithData:[image TIFFRepresentation]] autorelease] imageScaledSmoothlyToSize:newSize];
	
	[_window setImage:image];
    [_window buildTextWindowWithString:attributedText];
    [_window appear:self];
	[attributedText release];
}

@end