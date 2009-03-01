//
//  GrowlITTSWController.m
//  Growl
//
//  Created by Joseph Spiros on 2/28/09.
//  Copyright 2009 iThink Software. All rights reserved.
//

#import "GrowlITTSWController.h"

#import <ITKit/ITTSWBackgroundView.h>
#import <ITKit/ITWindowEffect.h>

#import "RegexKitLite.h"

#import "GrowlPositioningDefines.h"

@interface GrowlPositionController
+ (enum GrowlPosition)selectedOriginPosition;
@end

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
	NSSize newSize;
	NSSize oldSize = [image size];
	
	if (oldSize.width > oldSize.height) {
		newSize = NSMakeSize(110.0f, (oldSize.height * (110.0f / oldSize.width)));
	} else {
		newSize = NSMakeSize((oldSize.width * (110.0f / oldSize.height)), 110.0f);
	}
	
	image = [[[[NSImage alloc] initWithData:[image TIFFRepresentation]] autorelease] imageScaledSmoothlyToSize:newSize];
	
	NSArray *gothicChars = [NSArray arrayWithObjects:[NSString stringWithUTF8String:"☆"], [NSString stringWithUTF8String:"★"], nil];
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
	
	if (([gothicChars count] > 0) && ([text length] > 0)) {
		NSMutableString *gothicRegex = [[NSMutableString alloc] init];
		
		[gothicRegex appendString:@"["];
		for (NSString *gothicChar in gothicChars) {
			[gothicRegex appendString:gothicChar];
		}
		[gothicRegex appendString:@"]+"];
		
		NSUInteger endOfLastRange = 0;
		NSRange foundRange;
		while (endOfLastRange != NSNotFound) {
			foundRange = [text rangeOfRegex:gothicRegex inRange:NSMakeRange(endOfLastRange, ([text length] - endOfLastRange))];
			if (foundRange.location != NSNotFound) {
				[attributedText setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"AppleGothic" size:(18.0 / MINI_DIVISOR)], NSFontAttributeName, nil, nil] range:foundRange];
				endOfLastRange = foundRange.location+foundRange.length;
				if (endOfLastRange >= [text length]) {
					endOfLastRange = NSNotFound;
				}
			} else {
				endOfLastRange = NSNotFound;
			}
		}
	}
	
	switch ([GrowlPositionController selectedOriginPosition]) {
		case GrowlMiddleColumnPosition:
			[_window setVerticalPosition:ITWindowPositionMiddle];
			[_window setHorizontalPosition:ITWindowPositionCenter];
			break;
		case GrowlTopLeftPosition:
			[_window setVerticalPosition:ITWindowPositionTop];
			[_window setHorizontalPosition:ITWindowPositionLeft];
			break;
		case GrowlBottomRightPosition:
			[_window setVerticalPosition:ITWindowPositionBottom];
			[_window setHorizontalPosition:ITWindowPositionRight];
			break;
		case GrowlTopRightPosition:
			[_window setVerticalPosition:ITWindowPositionTop];
			[_window setHorizontalPosition:ITWindowPositionRight];
			break;
		case GrowlBottomLeftPosition:
			[_window setVerticalPosition:ITWindowPositionBottom];
			[_window setHorizontalPosition:ITWindowPositionLeft];
			break;
	}
	
	[_window setImage:image];
    [_window buildTextWindowWithString:attributedText];
    [_window appear:self];
	[attributedText release];
}

@end