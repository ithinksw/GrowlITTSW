//
//  GrowlITTSWController.m
//  Growl
//
//  Created by Joseph Spiros on 2/28/09.
//  Copyright 2009 iThink Software. All rights reserved.
//

#import "GrowlITTSWController.h"
#import "GrowlITTSWPrefs.h"

#import <ITKit/ITWindowEffect.h>
#import <ITKit/ITTSWBackgroundView.h>

#import "RegexKitLite.h"

@implementation NSImage (SmoothAdditions)

- (NSImage *)imageScaledSmoothlyToSize:(NSSize)scaledSize {
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

@interface GrowlITTSWController (Private)
- (void)syncWithPrefs;
@end

@implementation GrowlITTSWController

- (id)init {
    if ( ( self = [super init] ) ) {
		_window = [[GrowlITTSWWindow sharedWindow] retain];
		[_window setExitMode:ITTransientStatusWindowExitAfterDelay];
		[self syncWithPrefs];
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(syncWithPrefs) name:@"GrowlPreferencesChanged" object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)syncWithPrefs {
	NSScreen *screen = [GrowlITTSWPrefs screen];
	ITHorizontalWindowPosition horizontalPosition = [GrowlITTSWPrefs horizontalPosition];
	ITVerticalWindowPosition verticalPosition = [GrowlITTSWPrefs verticalPosition];
	
	Class appearanceEffect = [GrowlITTSWPrefs appearanceEffect];
	float appearanceSpeed = [GrowlITTSWPrefs appearanceSpeed];
	Class vanishEffect = [GrowlITTSWPrefs vanishEffect];
	float vanishSpeed = [GrowlITTSWPrefs vanishSpeed];
	float vanishDelay = [GrowlITTSWPrefs vanishDelay];
	
	ITTSWBackgroundMode backgroundStyle = [GrowlITTSWPrefs backgroundStyle];
	NSColor *backgroundColor = [GrowlITTSWPrefs backgroundColor];
	ITTransientStatusWindowSizing windowSize = [GrowlITTSWPrefs windowSize];
	
	if ([_window screen] != screen) {
		[_window setScreen:screen];
	}
	if ([_window horizontalPosition] != horizontalPosition) {
		[_window setHorizontalPosition:horizontalPosition];
	}
	if ([_window verticalPosition] != verticalPosition) {
		[_window setVerticalPosition:verticalPosition];
	}
	
	if (![[_window entryEffect] isKindOfClass:appearanceEffect]) {
		[_window setEntryEffect:[[[appearanceEffect alloc] initWithWindow:_window] autorelease]];
	}
	if ([[_window entryEffect] effectTime] != appearanceSpeed) {
		[[_window entryEffect] setEffectTime:appearanceSpeed];
	}
	if (![[_window exitEffect] isKindOfClass:vanishEffect]) {
		[_window setExitEffect:[[[vanishEffect alloc] initWithWindow:_window] autorelease]];
	}
	if ([[_window exitEffect] effectTime] != vanishSpeed) {
		[[_window exitEffect]  setEffectTime:vanishSpeed];
	}
	if ([_window exitDelay] != vanishDelay) {
		[_window setExitDelay:vanishDelay];
	}
	
	if ([(ITTSWBackgroundView *)[_window contentView] backgroundMode] != backgroundStyle) {
		[(ITTSWBackgroundView *)[_window contentView] setBackgroundMode:backgroundStyle];
	}
	if (([(ITTSWBackgroundView *)[_window contentView] backgroundMode] == ITTSWBackgroundColored) && ![[(ITTSWBackgroundView *)[_window contentView] backgroundColor] isEqual:backgroundColor]) {
		[(ITTSWBackgroundView *)[_window contentView] setBackgroundColor:backgroundColor];
	}
	if ([_window sizing] != windowSize) {
		[_window setSizing:windowSize];
	}
}

- (void)showWindowWithText:(NSString *)text image:(NSImage *)image {
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
	
	[_window setImage:image];
    [_window buildTextWindowWithString:attributedText];
    [_window appear:self];
	[attributedText release];
}

@end