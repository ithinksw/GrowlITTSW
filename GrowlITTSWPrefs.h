/*
 *	GrowlITTSW
 *	GrowlITTSWPrefs.h
 *
 *	Copyright (c) 2009 iThink Software
 *
 */

#import <PreferencePanes/PreferencePanes.h>
#import <ITKit/ITKit.h>
#import <ITKit/ITTSWBackgroundView.h>

@interface GrowlITTSWPrefs : NSPreferencePane {
	IBOutlet NSPopUpButton *appearanceEffectButton;
	IBOutlet NSSlider *appearanceSpeedSlider;
	IBOutlet NSPopUpButton *vanishEffectButton;
	IBOutlet NSSlider *vanishSpeedSlider;
	IBOutlet NSSlider *vanishDelaySlider;
	
	IBOutlet NSPopUpButton *backgroundStyleButton;
	IBOutlet NSColorWell *backgroundColorWell;
	IBOutlet NSPopUpButton *windowSizeButton;
	
	IBOutlet NSPopUpButton *screenButton;
	IBOutlet NSSlider *imageSizeSlider;
	IBOutlet NSButton *imageNoUpscaleButton;
	IBOutlet NSButton *wrapNotificationsButton;
	IBOutlet NSTextField *wrapColumnsField;
}

+ (Class)appearanceEffect;
+ (float)appearanceSpeed;
+ (Class)vanishEffect;
+ (float)vanishSpeed;
+ (float)vanishDelay;
+ (ITTSWBackgroundMode)backgroundStyle;
+ (NSColor *)backgroundColor;
+ (ITTransientStatusWindowSizing)windowSize;
+ (int)screenIndex;
+ (NSScreen *)screen;
+ (ITHorizontalWindowPosition)horizontalPosition;
+ (ITVerticalWindowPosition)verticalPosition;

+ (float)imageSize;
+ (BOOL)imageNoUpscale;
+ (BOOL)wrapNotifications;
+ (int)wrapColumns;

- (IBAction)setAppearanceEffect:(id)sender;
- (IBAction)setAppearanceSpeed:(id)sender;
- (IBAction)setVanishEffect:(id)sender;
- (IBAction)setVanishSpeed:(id)sender;
- (IBAction)setVanishDelay:(id)sender;

- (IBAction)setBackgroundStyle:(id)sender;
- (IBAction)setBackgroundColor:(id)sender;
- (IBAction)setWindowSize:(id)sender;

- (IBAction)setScreen:(id)sender;
- (IBAction)setImageSize:(id)sender;
- (IBAction)setImageNoUpscale:(id)sender;
- (IBAction)setWrap:(id)sender;
- (IBAction)setWrapColumns:(id)sender;

@end
