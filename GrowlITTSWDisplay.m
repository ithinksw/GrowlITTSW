#import "GrowlITTSWDisplay.h"
#import "GrowlITTSWController.h"
#import "GrowlITTSWPrefs.h"
#import "GrowlDefines.h"
#import "GrowlDefinesInternal.h"
#import "GrowlApplicationNotification.h"

@implementation GrowlITTSWDisplay

- (void) dealloc {
	[preferencePane release];
	[super dealloc];
}

- (NSPreferencePane *) preferencePane {
	if (!preferencePane) {
		preferencePane = [[GrowlITTSWPrefs alloc] initWithBundle:[NSBundle bundleWithIdentifier:@"com.ithinksw.growl-ittsw"]];
	}
	return preferencePane;
}

//we implement requiresPositioning entirely because it was added as a requirement for doing 1.1 plugins, however
//we don't really care if positioning is required or not, because we are only ever in the menubar.
- (BOOL)requiresPositioning {
	return NO;
}

#pragma mark -
- (void) displayNotification:(GrowlApplicationNotification *)notification {
	NSDictionary *dict = [notification dictionaryRepresentation];
	NSString *title = [dict objectForKey:GROWL_NOTIFICATION_TITLE];
	NSString *desc = [dict objectForKey:GROWL_NOTIFICATION_DESCRIPTION];
	NSImage *image = [dict objectForKey:GROWL_NOTIFICATION_ICON];
	[[GrowlITTSWController sharedController] showWindowWithTitle:title desc:desc image:image];
}

@end
