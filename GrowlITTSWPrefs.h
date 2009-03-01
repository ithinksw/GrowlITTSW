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

- (IBAction)setAppearanceEffect:(id)sender;
- (IBAction)setAppearanceSpeed:(id)sender;
- (IBAction)setVanishEffect:(id)sender;
- (IBAction)setVanishSpeed:(id)sender;
- (IBAction)setVanishDelay:(id)sender;

- (IBAction)setBackgroundStyle:(id)sender;
- (IBAction)setBackgroundColor:(id)sender;
- (IBAction)setWindowSize:(id)sender;

- (IBAction)setScreen:(id)sender;

@end
