#import <notify.h>
#import "interfaces.h"
#import "UFSNotificationList.h"

#ifndef CMCLog
#ifdef DEBUG
#define CMCLog(format, ...) 	NSLog(@"\033[1;36m(%s) in [%s:%d]\033[0m \033[5;32;40m:::\033[0m \033[0;31m%@\033[0m", __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])
#else
#define CMCLog(format, ...)
#endif

#define CMCLogObject(object)	CMCLog(@"unknown instance (%p) of class %@: %@", object, NSStringFromClass([object class]), [object description])
#endif

// macros end

static UFSNotificationList *sharedNotificationList;

// Start class hooking

%group gNSNotificationCenter

%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)notificationSender {
	%orig;
	[sharedNotificationList addAPI:@"NSNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
}
- (id<NSObject>)addObserverForName:(NSString *)notificationName object:(id)notificationSender queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
	id<NSObject> r = %orig;
	[sharedNotificationList addAPI:@"NSNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
	return r;
}
- (void)postNotification:(NSNotification *)notification {
	%orig;
	NSString *notificationName = [notification name];
	[sharedNotificationList addAPI:@"NSNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender {
	%orig;
	[sharedNotificationList addAPI:@"NSNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo {
	%orig;
	[sharedNotificationList addAPI:@"NSNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}

%end

%end /* gNSNotificationCenter */

%group gNSDistributedNotificationCenter

%hook NSDistributedNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)notificationSender {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
}
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)notificationSender suspensionBehavior:(CFNotificationSuspensionBehavior)suspensionBehavior {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
}
- (id)addObserverForName:(NSString *)notificationName object:(id)notificationSender queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
	id r = %orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
	return r;
}
- (id)addObserverForName:(NSString *)notificationName object:(id)notificationSender suspensionBehavior:(CFNotificationSuspensionBehavior)suspensionBehavior queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
	id r = %orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
	return r;
}
- (void)postNotification:(NSString *)notificationName {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo options:(NSUInteger)notificationOptions {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo deliverImmediately:(BOOL)deliverImmediately {
	%orig;
	[sharedNotificationList addAPI:@"NSDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}

%end

%end /* gNSDistributedNotificationCenter */

%group gCPDistributedNotificationCenter

%hook CPDistributedNotificationCenter

- (id)_initWithServerName:(NSString *)serverName {
	id r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedNotificationCenter" action:@"init" type:@"server" toNotification:serverName];
	return r;
}
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	[sharedNotificationList addAPI:@"CPDistributedNotificationCenter" action:@"deliver" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName {
	%orig;
	[sharedNotificationList addAPI:@"CPDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	[sharedNotificationList addAPI:@"CPDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier {
	BOOL r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
	return r;
}

%end

%end /* gCPDistributedNotificationCenter */

%group gCPDistributedMessagingCenter

%hook CPDistributedMessagingCenter

- (id)_initWithServerName:(NSString *)serverName {
	id r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"init" type:@"server" toNotification:serverName];
	return r;
}
- (void)_dispatchMessageNamed:(NSString *)messageNamed userInfo:(NSDictionary *)userInfo reply:(id *)reply auditToken:(void *)token {
	%orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"dispatch" type:@"message" toNotification:messageNamed];
}
- (BOOL)_sendMessage:(NSString *)messageNamed userInfo:(NSDictionary *)userInfo receiveReply:(id *)reply error:(NSError **)error toTarget:(id)target selector:(SEL)selector context:(void *)context {
	BOOL r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:messageNamed];
	return r;
}
- (BOOL)_sendMessage:(NSString *)messageNamed userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(NSError **)error {
	BOOL r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:messageNamed];
	return r;
}
- (void)registerForMessageName:(NSString *)messageNamed target:(id)target selector:(SEL)selector {
	%orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"register" type:@"message" toNotification:messageNamed];
}
- (id)sendMessageAndReceiveReplyName:(NSString *)messageNamed userInfo:(NSDictionary *)userInfo {
	id r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:messageNamed];
	return r;
}
- (id)sendMessageAndReceiveReplyName:(NSString *)messageNamed userInfo:(NSDictionary *)userInfo error:(NSError **)error {
	id r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:messageNamed];
	return r;
}
- (void)sendMessageAndReceiveReplyName:(NSString *)messageNamed userInfo:(NSDictionary *)userInfo toTarget:(id)target selector:(SEL)selector context:(void *)context {
	%orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:messageNamed];
}
- (BOOL)sendMessageName:(NSString *)messageNamed userInfo:(NSDictionary *)userInfo {
	BOOL r = %orig;
	[sharedNotificationList addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:messageNamed];
	return r;
}

%end

%end /* gCPDistributedMessagingCenter */

// End class hooking

// Start function hooking

%group gCFNotificationCenter

%hookf(void, CFNotificationCenterAddObserver, CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior) {
	%orig;
	NSString *notificationName = (NSString *)name;
	[sharedNotificationList addAPI:@"CFNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];
}
%hookf(void, CFNotificationCenterPostNotification, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately) {
	%orig;
	NSString *notificationName = (NSString *)name;
	[sharedNotificationList addAPI:@"CFNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}
%hookf(void, CFNotificationCenterPostNotificationWithOptions, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, CFOptionFlags options) {
	%orig;
	NSString *notificationName = (NSString *)name;
	[sharedNotificationList addAPI:@"CFNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];
}

%end /* gCFNotificationCenter */

%group gnotify

%hookf(uint32_t, notify_post, const char *name) {
	uint32_t r = %orig;
	NSString *notificationName = [[NSString alloc] initWithUTF8String:name];
	[sharedNotificationList addAPI:@"CNotifications" action:@"post" type:@"notification" toNotification:notificationName];
	[notificationName release];
	return r;
}
%hookf(uint32_t, notify_register_check, const char *name, int *out_token) {
	uint32_t r = %orig;
	NSString *notificationName = [[NSString alloc] initWithUTF8String:name];
	[sharedNotificationList addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];
	[notificationName release];
	return r;
}
%hookf(uint32_t, notify_register_signal, const char *name, int sig, int *out_token) {
	uint32_t r = %orig;
	NSString *notificationName = [[NSString alloc] initWithUTF8String:name];
	[sharedNotificationList addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];
	[notificationName release];
	return r;
}
%hookf(uint32_t, notify_register_mach_port, const char *name, mach_port_t *notify_port, int flags, int *out_token) {
	uint32_t r = %orig;
	NSString *notificationName = [[NSString alloc] initWithUTF8String:name];
	[sharedNotificationList addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];
	[notificationName release];
	return r;
}
%hookf(uint32_t, notify_register_file_descriptor, const char *name, int *notify_fd, int flags, int *out_token) {
	uint32_t r = %orig;
	NSString *notificationName = [[NSString alloc] initWithUTF8String:name];
	[sharedNotificationList addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];
	[notificationName release];
	return r;
}

%end /* gnotify */

// End function hooking

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	sharedNotificationList = [UFSNotificationList sharedInstance];

	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.Facebook.Messenger"]) {
		[sharedNotificationList setEnabled:NO];
	}

	if (%c(NSNotificationCenter)){
		CMCLog(@"Initing group: %s", "gNSNotificationCenter");
		%init(gNSNotificationCenter);
	}
	if (%c(NSDistributedNotificationCenter)){
		CMCLog(@"Initing group: %s", "gNSDistributedNotificationCenter");
		%init(gNSDistributedNotificationCenter);
	}
	if (%c(CPDistributedNotificationCenter)){
		CMCLog(@"Initing group: %s", "gCPDistributedNotificationCenter");
		%init(gCPDistributedNotificationCenter);
	}
	if (%c(CPDistributedMessagingCenter)){
		CMCLog(@"Initing group: %s", "gCPDistributedMessagingCenter");
		%init(gCPDistributedMessagingCenter);
	}
	%init(gCFNotificationCenter);
	%init(gnotify);

	[pool release];
}
