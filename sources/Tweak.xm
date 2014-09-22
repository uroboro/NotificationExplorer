#import <notify.h>
#import "UFSNotificationList.h"

#define CMCLog(format, ...) \
NSLog(@"\033[1;36m(%s) in [%s:%d]\033[0m \033[5;32;40m:::\033[0m \033[0;31m%@\033[0m", __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])

#define CMCLogObject(object) CMCLog(@"unknown instance (%p) of class %@", object, NSStringFromClass([object class])

// convenient macros

#define STRINGIFY_(x) # x
#define STRINGIFY(x) STRINGIFY_(x)

#define PASTE_(a,b) a ## b
#define PASTE(a,b) PASTE_(a,b)

#define MSHookFunctionAuto(name) MSHookFunction(name, MSHake(name))

// macros end
%group gNSNotificationCenter
%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"NSNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];;
}
- (void)postNotification:(NSNotification *)notification {
	%orig;
	NSString *notificationName = [notification name];
	[[UFSNotificationList sharedInstance] addAPI:@"NSNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"NSNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)userInfo {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"NSNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
}
%end
%end /* gNSNotificationCenter */

%group gCPDistributedNotificationCenter

@interface CPDistributedNotificationCenter : NSObject
- (id)_initWithServerName:(NSString *)serverName;
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
- (void)postNotificationName:(NSString *)notificationName;
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier;
@end

%hook CPDistributedNotificationCenter
- (id)_initWithServerName:(NSString *)serverName {
	id r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedNotificationCenter" action:@"init" type:@"server" toNotification:serverName];;
	return r;
}
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedNotificationCenter" action:@"deliver" type:@"notification" toNotification:notificationName];;
}
- (void)postNotificationName:(NSString *)notificationName {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
}
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
}
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier {
	BOOL r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
	return r;
}
%end
%end /* gCPDistributedNotificationCenter */

%group gCPDistributedMessagingCenter

typedef struct XXStruct_kUSYWB {
	unsigned _field1[8];
} XXStruct_kUSYWB;

@interface CPDistributedMessagingCenter : NSObject {
}
- (id)_initWithServerName:(id)serverName;
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(void *)token; //token being a XXStruct_kUSYWB
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error;
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error;
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)sendMessageName:(id)name userInfo:(id)info;
@end

%hook CPDistributedMessagingCenter
- (id)_initWithServerName:(id)serverName {
	id r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"init" type:@"server" toNotification:serverName];;
	return r;
}
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(void *)token {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"dispatch" type:@"message" toNotification:named];;
}
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context {
	BOOL r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:message];;
	return r;
}
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error {
	BOOL r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:message];;
	return r;
}
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"register" type:@"message" toNotification:messageName];;
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info {
	id r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:name];;
	return r;
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error {
	id r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:name];;
	return r;
}
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context {
	%orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:name];;
}
- (BOOL)sendMessageName:(id)name userInfo:(id)info {
	BOOL r = %orig;
	[[UFSNotificationList sharedInstance] addAPI:@"CPDistributedMessagingCenter" action:@"send" type:@"message" toNotification:name];;
	return r;
}
%end
%end /* gCPDistributedMessagingCenter */

//End class hooking

//Start function hooking

// CFNotificationCenter
MSHook(void, CFNotificationCenterAddObserver, CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior) {
	_CFNotificationCenterAddObserver(center, observer, callBack, name, object, suspensionBehavior);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = (name != NULL)? (NSString *)name:@"all";
	[[UFSNotificationList sharedInstance] addAPI:@"CFNotificationCenter" action:@"observe" type:@"notification" toNotification:notificationName];;
	[pool release];
}
MSHook(void, CFNotificationCenterPostNotification, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately) {
	_CFNotificationCenterPostNotification(center, name, object, userInfo, deliverImmediately);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = (NSString *)name;
	[[UFSNotificationList sharedInstance] addAPI:@"CFNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
	[pool release];
}
MSHook(void, CFNotificationCenterPostNotificationWithOptions, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, CFOptionFlags options) {
	_CFNotificationCenterPostNotificationWithOptions(center, name, object, userInfo, options);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = (NSString *)name;
	[[UFSNotificationList sharedInstance] addAPI:@"CFNotificationCenter" action:@"post" type:@"notification" toNotification:notificationName];;
	[pool release];
}

// notify_*
MSHook(uint32_t, notify_post, const char *name) {
	uint32_t r = _notify_post(name);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = [NSString stringWithUTF8String:name];
	[[UFSNotificationList sharedInstance] addAPI:@"CNotifications" action:@"post" type:@"notification" toNotification:notificationName];;
	[pool release];
	return r;
}
MSHook(uint32_t, notify_register_check, const char *name, int *out_token) {
	uint32_t r = _notify_register_check(name, out_token);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = [NSString stringWithUTF8String:name];
	[[UFSNotificationList sharedInstance] addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];;
	[pool release];
	return r;
}
MSHook(uint32_t, notify_register_signal, const char *name, int sig, int *out_token) {
	uint32_t r = _notify_register_signal(name, sig, out_token);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = [NSString stringWithUTF8String:name];
	[[UFSNotificationList sharedInstance] addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];;
	[pool release];
	return r;
}
MSHook(uint32_t, notify_register_mach_port, const char *name, mach_port_t *notify_port, int flags, int *out_token) {
	uint32_t r = _notify_register_mach_port(name, notify_port, flags, out_token);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = [NSString stringWithUTF8String:name];
	[[UFSNotificationList sharedInstance] addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];;
	[pool release];
	return r;
}
MSHook(uint32_t, notify_register_file_descriptor, const char *name, int *notify_fd, int flags, int *out_token) {
	uint32_t r = _notify_register_file_descriptor(name, notify_fd, flags, out_token);
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSString *notificationName = [NSString stringWithUTF8String:name];
	[[UFSNotificationList sharedInstance] addAPI:@"CNotifications" action:@"register" type:@"notification" toNotification:notificationName];;
	[pool release];
	return r;
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[UFSNotificationList sharedInstance];

	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.Facebook.Messenger"]) {
		[[UFSNotificationList sharedInstance] setEnabled:NO];
	}

	if (%c(NSNotificationCenter)){
		CMCLog(@"Initing group: %s", STRINGIFY(PASTE(g,NSNotificationCenter)));
		%init(gNSNotificationCenter);
	}
	if (%c(CPDistributedNotificationCenter)){
		CMCLog(@"Initing group: %s", STRINGIFY(PASTE(g,CPDistributedNotificationCenter)));
		%init(gCPDistributedNotificationCenter);
	}
	if (%c(CPDistributedMessagingCenter)){
		CMCLog(@"Initing group: %s", STRINGIFY(PASTE(g,CPDistributedMessagingCenter)));
		%init(gCPDistributedMessagingCenter);
	}
	[pool release];

	MSHookFunctionAuto(CFNotificationCenterAddObserver);
	MSHookFunctionAuto(CFNotificationCenterPostNotification);
	MSHookFunctionAuto(CFNotificationCenterPostNotificationWithOptions);

	MSHookFunctionAuto(notify_post);
	MSHookFunctionAuto(notify_register_check);
	MSHookFunctionAuto(notify_register_signal);
	MSHookFunctionAuto(notify_register_mach_port);
	MSHookFunctionAuto(notify_register_file_descriptor);
}
