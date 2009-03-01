//
//  GrowlITTSWWindow.m
//  Growl
//
//  Created by Joseph Spiros on 2/28/09.
//  Copyright 2009 iThink Software. All rights reserved.
//

#import "GrowlITTSWWindow.h"

#define SW_PAD             24.00
#define SW_SPACE           24.00
#define SW_MINW           211.00
#define SW_BORDER          32.00
#define SW_METER_PAD        4.00
#define SW_BUTTON_PAD_R    30.00
#define SW_BUTTON_PAD_B    24.00
#define SW_BUTTON_DIV      12.00
#define SW_BUTTON_EXTRA_W   8.00
#define SW_SHADOW_SAT       1.25

@interface GrowlITTSWWindow (Private)
- (NSRect)setupWindowWithDataSize:(NSSize)dataSize;
@end

@implementation GrowlITTSWWindow


/*************************************************************************/
#pragma mark -
#pragma mark INITIALIZATION / DEALLOCATION METHODS
/*************************************************************************/

- (id)initWithContentView:(NSView *)contentView
                 exitMode:(ITTransientStatusWindowExitMode)exitMode
           backgroundType:(ITTransientStatusWindowBackgroundType)backgroundType
{
    if ( ( self = [super initWithContentView:contentView
									exitMode:exitMode
							  backgroundType:backgroundType] ) ) {
		// Set default values.
        _image  = [[NSImage imageNamed:@"NSApplicationIcon"] retain];
        _sizing = ITTransientStatusWindowRegular;
    }
    
    return self;
}

- (void)dealloc
{
    [_image release];
    [super dealloc];
}


/*************************************************************************/
#pragma mark -
#pragma mark ACCESSOR METHODS
/*************************************************************************/

- (void)setImage:(NSImage *)newImage
{
	if (!newImage) {
		newImage = [NSImage imageNamed:@"NSApplicationIcon"];
	}
    [_image autorelease];
    _image = [newImage copy];
}

- (void)setSizing:(ITTransientStatusWindowSizing)newSizing
{
    _sizing = newSizing;
}

/*************************************************************************/
#pragma mark -
#pragma mark INSTANCE METHODS
/*************************************************************************/

- (void)appear:(id)sender
{
    [super appear:sender];
}

- (void)vanish:(id)sender
{
    [super vanish:sender];
}

- (NSRect)setupWindowWithDataSize:(NSSize)dataSize
{
    float        divisor       = 1.0;
    NSRect       imageRect;
    float        imageWidth    = 0.0;
    float        imageHeight   = 0.0;
    float        dataWidth     = dataSize.width;
    float        dataHeight    = dataSize.height;
    float        contentHeight = 0.0;
    float        windowWidth   = 0.0;
    float        windowHeight  = 0.0;
    NSRect       visibleFrame  = [[self screen] visibleFrame];
    NSPoint      screenOrigin  = visibleFrame.origin;
    float        screenWidth   = visibleFrame.size.width;
    float        screenHeight  = visibleFrame.size.height;
    float        maxWidth      = ( screenWidth  - (SW_BORDER * 2) );
    float        maxHeight     = ( screenHeight - (SW_BORDER * 2) );
    float        excessWidth   = 0.0;
    float        excessHeight  = 0.0;
    NSPoint      windowOrigin  = NSZeroPoint;
    ITImageView *imageView;
    BOOL         shouldAnimate = ( ! (([self visibilityState] == ITWindowAppearingState) ||
                                      ([self visibilityState] == ITWindowVanishingState)) );
	
    if ( _sizing == ITTransientStatusWindowSmall ) {
        divisor = SMALL_DIVISOR;
    } else if ( _sizing == ITTransientStatusWindowMini ) {
        divisor = MINI_DIVISOR;
    }
	
	//  Get image width and height.
    imageWidth  = ( [_image size].width  / divisor );
    imageHeight = ( [_image size].height / divisor );
    
	//  Set the content height to the greater of the text and image heights.
    contentHeight = ( ( imageHeight > dataHeight ) ? imageHeight : dataHeight );
	
	//  Setup the Window, and remove all its contentview's subviews.
    windowWidth  = ( (SW_PAD / divisor) + imageWidth + ((dataWidth > 0) ? (SW_SPACE / divisor) + dataWidth : 0) + (SW_PAD / divisor) );
    windowHeight = ( (SW_PAD / divisor) + contentHeight + (SW_PAD / divisor) );
    
	//  Constrain size to max limits.  Adjust data sizes accordingly.
    excessWidth  = (windowWidth  - maxWidth );
    excessHeight = (windowHeight - maxHeight);
	
    if ( excessWidth > 0.0 ) {
        windowWidth = maxWidth;
        dataWidth -= excessWidth;
    }
    
    if ( excessHeight > 0.0 ) {
        windowHeight = maxHeight;
        dataHeight -= excessHeight;
    }
    
    if ( [self horizontalPosition] == ITWindowPositionLeft ) {
        windowOrigin.x = ( SW_BORDER + screenOrigin.x );
    } else if ( [self horizontalPosition] == ITWindowPositionCenter ) {
        windowOrigin.x = ( screenOrigin.x + (screenWidth / 2) - (windowWidth / 2) );
    } else if ( [self horizontalPosition] == ITWindowPositionRight ) {
        windowOrigin.x = ( screenOrigin.x + screenWidth - (windowWidth + SW_BORDER) );
    }
    
    if ( [self verticalPosition] == ITWindowPositionTop ) {
        windowOrigin.y = ( screenOrigin.y + screenHeight - (windowHeight + SW_BORDER) );
    } else if ( [self verticalPosition] == ITWindowPositionMiddle ) {
		//      Middle-oriented windows should be slightly proud of the screen's middle.
        windowOrigin.y = ( (screenOrigin.y + (screenHeight / 2) - (windowHeight / 2)) + (screenHeight / 8) );
    } else if ( [self verticalPosition] == ITWindowPositionBottom ) {
        windowOrigin.y = ( SW_BORDER + screenOrigin.y );
    }
    
    [self setFrame:NSMakeRect( windowOrigin.x,
							  windowOrigin.y,
							  windowWidth,
							  windowHeight) display:YES animate:shouldAnimate];
	
    [[[self contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
	//  Setup, position, fill, and add the image view to the content view.
    imageRect = NSMakeRect( (SW_PAD / divisor) + ((dataWidth > 0) ? 4 : 0),
						   ((SW_PAD / divisor) + ((contentHeight - imageHeight) / 2)),
						   imageWidth,
						   imageHeight );
    imageView = [[[ITImageView alloc] initWithFrame:imageRect] autorelease];
    [imageView setAutoresizingMask:(NSViewMinYMargin | NSViewMaxYMargin)];
    [imageView setImage:_image];
    [imageView setCastsShadow:YES];
    [[self contentView] addSubview:imageView];
	
    return NSMakeRect( ((SW_PAD / divisor) + imageWidth + (SW_SPACE / divisor)),
					  ((SW_PAD / divisor) + ((contentHeight - dataHeight) / 2)),
					  dataWidth,
					  dataHeight);
}

- (void)buildTextWindowWithString:(id)text
{
	float         divisor       = 1.0;
	float         dataWidth     = 0.0;
	float         dataHeight    = 0.0;
	NSRect        dataRect;
	NSArray      *lines			= [(([text isKindOfClass:[NSString class]]) ? text : [text mutableString]) componentsSeparatedByString:@"\n"];
	id			  oneLine       = nil;
	NSEnumerator *lineEnum		= [lines objectEnumerator];
	float         baseFontSize  = 18.0;
	ITTextField  *textField;
	NSFont       *font;
	NSDictionary *attr;
	
	if ( _sizing == ITTransientStatusWindowSmall ) {
		divisor = SMALL_DIVISOR;
	} else if ( _sizing == ITTransientStatusWindowMini ) {
		divisor = MINI_DIVISOR;
	}
	
	font = [NSFont fontWithName:@"LucidaGrande-Bold" size:(baseFontSize / divisor)];
	attr = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
	
	//      Iterate over each line to get text width and height
	while ( (oneLine = [lineEnum nextObject]) ) {
		//          Get the width of one line, adding 8.0 because Apple sucks donkey rectum.
		float oneLineWidth = ( [oneLine sizeWithAttributes:attr].width + 8.0 );
		//          Add the height of this line to the total text height
		dataHeight += [oneLine sizeWithAttributes:attr].height;
		//          If this line wider than the last one, set it as the text width.
		dataWidth = ( ( dataWidth > oneLineWidth ) ? dataWidth : oneLineWidth );
	}
	
	//      Add 4.0 to the final dataHeight to accomodate the shadow.
	dataHeight += 4.0;
	
	dataRect = [self setupWindowWithDataSize:NSMakeSize(dataWidth, dataHeight)];
	
	//      Create, position, setup, fill, and add the text view to the content view.
	textField = [[[ITTextField alloc] initWithFrame:dataRect] autorelease];
	[textField setAutoresizingMask:(NSViewHeightSizable | NSViewWidthSizable)];
	[textField setEditable:NO];
	[textField setSelectable:NO];
	[textField setBordered:NO];
	[textField setDrawsBackground:NO];
	[textField setFont:font];
	[textField setTextColor:[NSColor whiteColor]];
	[textField setCastsShadow:YES];
	[[textField cell] setWraps:NO];
	
	if ([text isKindOfClass:[NSString class]]) {
		[textField setStringValue:text];
	} else {
		[textField setAttributedStringValue:text];
	}
	
	[textField setShadowSaturation:SW_SHADOW_SAT];
	[[self contentView] addSubview:textField];
	
	//      Display the window.
	[[self contentView] setNeedsDisplay:YES];
	_textField = textField;
}

- (NSTimeInterval)animationResizeTime:(NSRect)newFrame
{
    return (NSTimeInterval)0.25;
}

@end
