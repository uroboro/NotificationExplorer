#include <dispatch/dispatch.h>
#import "UFSNotificationList.h"

@implementation UFSNotificationList

+ (instancetype)sharedInstance {
	static id _sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		_sharedInstance = [self new];
	});
	return _sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
		_notifications = [NSMutableDictionary new];
		_enabled = YES;
	}
	return self;
}

- (void)dealloc {
	[_notifications release];
	[super dealloc];
}

- (BOOL)addAPI:(NSString *)api action:(NSString *)action type:(NSString *)type toNotification:(NSString *)notificationName {
	if (!self.isEnabled) {
		return NO;
	}

	if (!notificationName) {
		notificationName = @"all";
	}

	NSMutableDictionary *d = [_notifications objectForKey:notificationName];
	if (!d) {
		d = [NSMutableDictionary new];
		[_notifications setObject:d forKey:notificationName];
		[d release];
	}

	[d setObject:type forKey:@"type"];

	if (![d objectForKey:@"APIs"]) {
		NSMutableArray *a = [NSMutableArray new];
		[d setObject:a forKey:@"APIs"];
		[a release];
	}
	[[d objectForKey:@"APIs"] addObject:api];

	if (![d objectForKey:@"actions"]) {
		NSMutableArray *a = [NSMutableArray new];
		[d setObject:a forKey:@"actions"];
		[a release];
	}
	[[d objectForKey:@"actions"] addObject:action];

	return YES;
}

- (NSString *)fileName {
	NSProcessInfo *p = [NSProcessInfo processInfo];
	return [NSString stringWithFormat:@"%@_(%d)_-_%@", [p processName], [p processIdentifier], [p globallyUniqueString]];
}

@end
