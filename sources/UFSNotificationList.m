#import "UFSNotificationList.h"
#include <dispatch/dispatch.h>

@implementation UFSNotificationList

@synthesize notifications = _notifications;

+ (instancetype)sharedInstance {
	static UFSNotificationList *_sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		_sharedInstance = [[UFSNotificationList alloc] init];
	});
	return _sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _notifications = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)dealloc {
    [_notifications release];
    [super dealloc];
}

- (void)prepareNotificationKey:(NSString *)notificationName {
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
}
- (void)addAPI:(NSString *)api toNotification:(NSString *)notificationName {
	[self prepareNotificationKey:notificationName];
	[[[_notifications objectForKey:notificationName] objectForKey:@"APIs"] addObject:api];
}
- (void)addAction:(NSString *)action toNotification:(NSString *)notificationName {
	[self prepareNotificationKey:notificationName];
	[[[_notifications objectForKey:notificationName] objectForKey:@"actions"] addObject:action];
}
- (void)setType:(NSString *)type toNotification:(NSString *)notificationName {
	[self prepareNotificationKey:notificationName];
	[[_notifications objectForKey:notificationName] setObject:type forKey:@"type"];
}
- (void)addAPI:(NSString *)api action:(NSString *)action type:(NSString *)type toNotification:(NSString *)notificationName {
	[self addAPI:api toNotification:notificationName];
	[self addAction:action toNotification:notificationName];
	[self setType:type toNotification:notificationName];
}

@end
