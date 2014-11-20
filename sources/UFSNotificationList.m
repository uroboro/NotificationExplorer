#import "UFSNotificationList.h"
#include <dispatch/dispatch.h>

@implementation UFSNotificationList

@synthesize notifications = _notifications;
@synthesize enabled = _enabled;

+ (instancetype)sharedInstance {
	static UFSNotificationList *_sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		_sharedInstance = [UFSNotificationList new];
	});
	return _sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
		_notifications = [NSMutableDictionary new];
	}
	return self;
}
- (void)dealloc {
	[_notifications release];
	[super dealloc];
}

- (BOOL)prepareNotificationKey:(NSString *)notificationName {
	if (!self.isEnabled) {
		return NO;
	}

	if (!notificationName) {
		return NO;
	}
	NSMutableDictionary *d;
	if (!(d = [_notifications objectForKey:notificationName])) {
		d = [NSMutableDictionary dictionaryWithCapacity:1];
		[_notifications setObject:d forKey:notificationName];
	}
	if (![d objectForKey:@"APIs"]) {
		[d setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"APIs"];
	}
	if (![d objectForKey:@"actions"]) {
		[d setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"actions"];
	}

	return YES;
}
- (BOOL)addAPI:(NSString *)api toNotification:(NSString *)notificationName {
	if (![self prepareNotificationKey:notificationName]) {
		return NO;
	}
	[[[_notifications objectForKey:notificationName] objectForKey:@"APIs"] addObject:api];

	return YES;
}
- (BOOL)addAction:(NSString *)action toNotification:(NSString *)notificationName {
	if (![self prepareNotificationKey:notificationName]) {
		return NO;
	}
	[[[_notifications objectForKey:notificationName] objectForKey:@"actions"] addObject:action];

	return YES;
}
- (BOOL)setType:(NSString *)type toNotification:(NSString *)notificationName {
	if (![self prepareNotificationKey:notificationName]) {
		return NO;
	}
	[[_notifications objectForKey:notificationName] setObject:type forKey:@"type"];

	return YES;
}
- (BOOL)addAPI:(NSString *)api action:(NSString *)action type:(NSString *)type toNotification:(NSString *)notificationName {
	if (![self prepareNotificationKey:notificationName]) {
		return NO;
	}
	if (![self addAPI:api toNotification:notificationName]) {
		return NO;
	}
	if (![self addAction:action toNotification:notificationName]) {
		return NO;
	}
	if (![self setType:type toNotification:notificationName]) {
		return NO;
	}

	return YES;
}

- (NSString *)fileName {
	NSProcessInfo *p = [NSProcessInfo processInfo];
	return [NSString stringWithFormat:@"%@_(%d)_-_%@", [p processName], [p processIdentifier], [p globallyUniqueString]];
}

@end
