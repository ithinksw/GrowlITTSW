#import "GrowlITTSWPrefs.h"
#import "GrowlPositioningDefines.h"
#import "GrowlDefinesInternal.h"
#define GrowlITTSWPrefsDomain @"com.ithinksw.growl-ittsw"

@interface GrowlPositionController
+ (enum GrowlPosition)selectedOriginPosition;
@end

@implementation GrowlITTSWPrefs

+ (Class)appearanceEffect {
	SYNCHRONIZE_GROWL_PREFS();
	NSString *className = nil;
	READ_GROWL_PREF_VALUE(@"appearanceEffect", GrowlITTSWPrefsDomain, NSString *, &className);
	if (className) {
		Class effectClass = NSClassFromString(className);
		if (effectClass && [effectClass isSubclassOfClass:[ITWindowEffect class]]) {
			return effectClass;
		}
	}
	return NSClassFromString(@"ITCutWindowEffect");
}

+ (float)appearanceSpeed {
	SYNCHRONIZE_GROWL_PREFS();
	float appearanceSpeed = 0.8f;
	READ_GROWL_PREF_FLOAT(@"appearanceSpeed", GrowlITTSWPrefsDomain, &appearanceSpeed);
	return appearanceSpeed;
}

+ (Class)vanishEffect {
	SYNCHRONIZE_GROWL_PREFS();
	NSString *className = nil;
	READ_GROWL_PREF_VALUE(@"vanishEffect", GrowlITTSWPrefsDomain, NSString *, &className);
	if (className) {
		Class effectClass = NSClassFromString(className);
		if (effectClass && [effectClass isSubclassOfClass:[ITWindowEffect class]]) {
			return effectClass;
		}
	}
	return NSClassFromString(@"ITCutWindowEffect");
}

+ (float)vanishSpeed {
	SYNCHRONIZE_GROWL_PREFS();
	float vanishSpeed = 0.8f;
	READ_GROWL_PREF_FLOAT(@"vanishSpeed", GrowlITTSWPrefsDomain, &vanishSpeed);
	return vanishSpeed;
}

+ (float)vanishDelay {
	SYNCHRONIZE_GROWL_PREFS();
	float vanishDelay = 4.0f;
	READ_GROWL_PREF_FLOAT(@"vanishDelay", GrowlITTSWPrefsDomain, &vanishDelay);
	return vanishDelay;
}

+ (ITTSWBackgroundMode)backgroundStyle {
	SYNCHRONIZE_GROWL_PREFS();
	int backgroundStyle = ITTSWBackgroundReadable;
	READ_GROWL_PREF_INT(@"backgroundStyle", GrowlITTSWPrefsDomain, &backgroundStyle);
	return backgroundStyle;
}

+ (NSColor *)backgroundColor {
	SYNCHRONIZE_GROWL_PREFS();
	NSData *backgroundColorData = nil;
	READ_GROWL_PREF_VALUE(@"backgroundColor", GrowlITTSWPrefsDomain, NSData *, &backgroundColorData);
	if (backgroundColorData && [backgroundColorData isKindOfClass:[NSData class]]) {
		NSColor *backgroundColor = [NSUnarchiver unarchiveObjectWithData:backgroundColorData];
		if (backgroundColor && [backgroundColor isKindOfClass:[NSColor class]]) {
			return backgroundColor;
		}
	}
	return [NSColor blueColor];
}

+ (ITTransientStatusWindowSizing)windowSize {
	SYNCHRONIZE_GROWL_PREFS();
	ITTransientStatusWindowSizing windowSize = ITTransientStatusWindowMini;
	READ_GROWL_PREF_INT(@"windowSize", GrowlITTSWPrefsDomain, &windowSize);
	return windowSize;
}

+ (int)screenIndex {
	SYNCHRONIZE_GROWL_PREFS();
	int screenIndex = 0;
	READ_GROWL_PREF_INT(@"screenIndex", GrowlITTSWPrefsDomain, &screenIndex);
	return screenIndex;
}

+ (NSScreen *)screen {
	NSArray *screens = [NSScreen screens];
	int screenIndex = [GrowlITTSWPrefs screenIndex];
	if ([screens count] >= (screenIndex+1)) {
		return [screens objectAtIndex:screenIndex];
	}
	return [screens	objectAtIndex:0];
}

+ (ITHorizontalWindowPosition)horizontalPosition {
	switch ([GrowlPositionController selectedOriginPosition]) {
		case GrowlBottomLeftPosition:
		case GrowlTopLeftPosition:
			return ITWindowPositionLeft;
			break;
		default:
		case GrowlBottomRightPosition:
		case GrowlTopRightPosition:
			return ITWindowPositionRight;
			break;
	}
}

+ (ITVerticalWindowPosition)verticalPosition {
	switch ([GrowlPositionController selectedOriginPosition]) {
		case GrowlBottomLeftPosition:
		case GrowlBottomRightPosition:
			return ITWindowPositionBottom;
			break;
		default:
		case GrowlTopLeftPosition:
		case GrowlTopRightPosition:
			return ITWindowPositionTop;
			break;
	}
}

+ (float)imageSize {
	SYNCHRONIZE_GROWL_PREFS();
	float imageSize = 110.0f;
	READ_GROWL_PREF_FLOAT(@"imageSize", GrowlITTSWPrefsDomain, &imageSize);
	return imageSize;
}

+ (BOOL)imageNoUpscale {
	SYNCHRONIZE_GROWL_PREFS();
	BOOL imageNoUpscale = NO;
	READ_GROWL_PREF_BOOL(@"imageNoUpscale", GrowlITTSWPrefsDomain, &imageNoUpscale);
	return imageNoUpscale;
}

+ (BOOL)wrapNotifications {
	SYNCHRONIZE_GROWL_PREFS();
	BOOL wrapNotifications = NO;
	READ_GROWL_PREF_BOOL(@"wrapNotifications", GrowlITTSWPrefsDomain, &wrapNotifications);
	return wrapNotifications;
}

+ (int)wrapColumns {
	SYNCHRONIZE_GROWL_PREFS();
	int wrapColumns = 64;
	READ_GROWL_PREF_INT(@"wrapColumns", GrowlITTSWPrefsDomain, &wrapColumns);
	return wrapColumns;
}

- (NSString *)mainNibName {
	return @"GrowlITTSWPrefs";
}

- (void)didSelect {
	[appearanceEffectButton selectItemAtIndex:[appearanceEffectButton indexOfItemWithRepresentedObject:[GrowlITTSWPrefs appearanceEffect]]];
	[appearanceSpeedSlider setFloatValue:-([GrowlITTSWPrefs appearanceSpeed])];
	[vanishEffectButton selectItemAtIndex:[vanishEffectButton indexOfItemWithRepresentedObject:[GrowlITTSWPrefs vanishEffect]]];
	[vanishSpeedSlider setFloatValue:-([GrowlITTSWPrefs vanishSpeed])];
	[vanishDelaySlider setFloatValue:[GrowlITTSWPrefs vanishDelay]];
	
	ITTSWBackgroundMode backgroundStyle = [GrowlITTSWPrefs backgroundStyle];
	[backgroundStyleButton selectItemWithTag:backgroundStyle];
	if (backgroundStyle == ITTSWBackgroundColored) {
		[backgroundColorWell setEnabled:YES];
	} else {
		[backgroundColorWell setEnabled:NO];
	}
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	[backgroundColorWell setColor:[GrowlITTSWPrefs backgroundColor]];
	[windowSizeButton selectItemWithTag:[GrowlITTSWPrefs windowSize]];
	
	[screenButton removeAllItems];
	NSArray *screens = [NSScreen screens];
	int screenCount = 0;
	for (NSScreen *screen in screens) {
		NSSize screenSize = [screen frame].size;
		NSMenuItem *screenItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Screen %i (%1.0fx%1.0f)", screenCount+1, screenSize.width, screenSize.height] action:NULL keyEquivalent:@""];
		[screenItem setRepresentedObject:screen];
		[[screenButton menu] addItem:screenItem];
		screenCount++;
	}
	if (screenCount > 1) {
		[screenButton setEnabled:YES];
	} else {
		[screenButton setEnabled:NO];
	}
	[screenButton selectItemAtIndex:[screenButton indexOfItemWithRepresentedObject:[GrowlITTSWPrefs screen]]];
	[imageSizeSlider setFloatValue:[GrowlITTSWPrefs imageSize]];
	[imageNoUpscaleButton setState:([GrowlITTSWPrefs imageNoUpscale] ? NSOnState : NSOffState)];
	
	BOOL wrapNotifications = [GrowlITTSWPrefs wrapNotifications];
	[wrapNotificationsButton setState:(wrapNotifications ? NSOnState : NSOffState)];
	[wrapColumnsField setIntValue:[GrowlITTSWPrefs wrapColumns]];
	[wrapColumnsField setEnabled:wrapNotifications];
}

- (void)awakeFromNib {
	NSArray *effectClasses = [ITWindowEffect effectClasses];
	for (Class effectClass in effectClasses) {
		NSMenuItem *appearanceEffectItem = [[NSMenuItem alloc] initWithTitle:[effectClass effectName] action:NULL keyEquivalent:@""];
		NSMenuItem *vanishEffectItem = [[NSMenuItem alloc] initWithTitle:[effectClass effectName] action:NULL keyEquivalent:@""];
		[appearanceEffectItem setRepresentedObject:effectClass];
		[vanishEffectItem setRepresentedObject:effectClass];
		
		[[appearanceEffectButton menu] addItem:[appearanceEffectItem autorelease]];
		[[vanishEffectButton menu] addItem:[vanishEffectItem autorelease]];
	}
	
	NSArray *backgroundStyles = [NSArray arrayWithObjects:
									[NSDictionary dictionaryWithObjectsAndKeys:@"Mac OS X", @"name", [NSNumber numberWithInt:ITTSWBackgroundApple], @"index", nil],
									[NSDictionary dictionaryWithObjectsAndKeys:@"Very Readable", @"name", [NSNumber numberWithInt:ITTSWBackgroundReadable], @"index", nil],
									[NSDictionary dictionaryWithObjectsAndKeys:@"Custom Color...", @"name", [NSNumber numberWithInt:ITTSWBackgroundColored], @"index", nil],
								 nil];
	for (NSDictionary *backgroundStyleDict in backgroundStyles) {
		NSString *backgroundStyleName = [backgroundStyleDict objectForKey:@"name"];
		ITTSWBackgroundMode backgroundStyle = [[backgroundStyleDict objectForKey:@"index"] intValue];
		NSMenuItem *backgroundStyleItem = [[NSMenuItem alloc] initWithTitle:backgroundStyleName action:NULL keyEquivalent:@""];
		[backgroundStyleItem setTag:backgroundStyle];
		
		[[backgroundStyleButton menu] addItem:[backgroundStyleItem autorelease]];
	}
	
	NSArray *windowSizes = [NSArray arrayWithObjects:
								[NSDictionary dictionaryWithObjectsAndKeys:@"Regular", @"name", [NSNumber numberWithInt:ITTransientStatusWindowRegular], @"index", nil],
								[NSDictionary dictionaryWithObjectsAndKeys:@"Small", @"name", [NSNumber numberWithInt:ITTransientStatusWindowSmall], @"index", nil],
								[NSDictionary dictionaryWithObjectsAndKeys:@"Mini", @"name", [NSNumber numberWithInt:ITTransientStatusWindowMini], @"index", nil],
							nil];
	for (NSDictionary *windowSizeDict in windowSizes) {
		NSString *windowSizeName = [windowSizeDict objectForKey:@"name"];
		ITTransientStatusWindowSizing windowSize = [[windowSizeDict objectForKey:@"index"] intValue];
		NSMenuItem *windowSizeItem = [[NSMenuItem alloc] initWithTitle:windowSizeName action:NULL keyEquivalent:@""];
		[windowSizeItem setTag:windowSize];
		
		[[windowSizeButton menu] addItem:[windowSizeItem autorelease]];
	}
	
	[self didSelect];
}

- (IBAction)setAppearanceEffect:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	WRITE_GROWL_PREF_VALUE(@"appearanceEffect", NSStringFromClass([[appearanceEffectButton selectedItem] representedObject]), GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setAppearanceSpeed:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	float appearanceSpeed = -([appearanceSpeedSlider floatValue]);
	WRITE_GROWL_PREF_FLOAT(@"appearanceSpeed", appearanceSpeed, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setVanishEffect:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	WRITE_GROWL_PREF_VALUE(@"vanishEffect", NSStringFromClass([[vanishEffectButton selectedItem] representedObject]), GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setVanishSpeed:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	float vanishSpeed = -([vanishSpeedSlider floatValue]);
	WRITE_GROWL_PREF_FLOAT(@"vanishSpeed", vanishSpeed, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setVanishDelay:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	float vanishDelay = [vanishDelaySlider floatValue];
	WRITE_GROWL_PREF_FLOAT(@"vanishDelay", vanishDelay, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setBackgroundStyle:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	int style = [[backgroundStyleButton selectedItem] tag];
	if (style == 2) { // colored
		[backgroundColorWell setEnabled:YES];
	} else {
		[backgroundColorWell setEnabled:NO];
	}
	WRITE_GROWL_PREF_INT(@"backgroundStyle", style, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setBackgroundColor:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	WRITE_GROWL_PREF_VALUE(@"backgroundColor", [NSArchiver archivedDataWithRootObject:[backgroundColorWell color]], GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setWindowSize:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	int size = [[windowSizeButton selectedItem] tag];
	WRITE_GROWL_PREF_INT(@"windowSize", size, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setScreen:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	int screenIndex = [screenButton indexOfSelectedItem];
	WRITE_GROWL_PREF_INT(@"screenIndex", screenIndex, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setImageSize:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	float imageSize = [imageSizeSlider floatValue];
	WRITE_GROWL_PREF_FLOAT(@"imageSize", imageSize, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setImageNoUpscale:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	BOOL imageNoUpscale = ([imageNoUpscaleButton state] == NSOnState) ? YES : NO;
	WRITE_GROWL_PREF_BOOL(@"imageNoUpscale", imageNoUpscale, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setWrap:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	BOOL wrapNotifications = ([wrapNotificationsButton state] == NSOnState) ? YES : NO;
	[wrapColumnsField setEnabled:wrapNotifications];
	WRITE_GROWL_PREF_BOOL(@"wrapNotifications", wrapNotifications, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

- (IBAction)setWrapColumns:(id)sender {
	SYNCHRONIZE_GROWL_PREFS();
	int wrapColumns = [wrapColumnsField intValue];
	[wrapColumnsField setIntValue:wrapColumns];
	WRITE_GROWL_PREF_INT(@"wrapColumns", wrapColumns, GrowlITTSWPrefsDomain);
	UPDATE_GROWL_PREFS();
}

@end
