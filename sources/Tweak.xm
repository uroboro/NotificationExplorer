#import <notify.h>
#import "UFSAssociationTable.h"

#define CMCLog(format, ...) \
NSLog(@"\033[1;36m(%s) in [%s:%d]\033[0m \033[5;32;40m:::\033[0m \033[0;31m%@\033[0m", __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])

#define UNKNOWN_OBJ_FORMAT(object) @"unknown instance (%p) of class %@", object, NSStringFromClass([object class])

#define CMCLogObject(object) CMCLog(UNKNOWN_OBJ_FORMAT(object))


#define DICT(n, args...) \
[NSMutableDictionary dictionaryWithObjectsAndKeys:(n), @"data", args, nil]

#define ADDOBJPAIR(d, o) [d setObject:(o) forKey:(o)]

#define ADDATTRIBUTE_(a, b, c, class) do {\
	NSMutableDictionary *att = UFSAssociationTableGet_(a, class);\
	if (att) { ADDOBJPAIR(att, c); } else { UFSAssociationTableAdd_(a, DICT(b, c, c), class); }\
} while (0)
#define ADDATTRIBUTE(a, b, c)  ADDATTRIBUTE_(a, b, c, [self class])


%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject {
	%orig;
	ADDATTRIBUTE(notificationName, @"notification", @"observe");
}

- (void)postNotification:(NSNotification *)notification {
	%orig;
	ADDATTRIBUTE([notification name], @"notification", @"post");
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject {
	%orig;
	ADDATTRIBUTE(notificationName, @"notification", @"post");
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)userInfo {
	%orig;
	ADDATTRIBUTE(notificationName, @"notification", @"post");
}
%end

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
	ADDATTRIBUTE(serverName, @"server", @"init");
	return r;
}
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	ADDATTRIBUTE(notificationName, @"notification", @"deliver");
}
- (void)postNotificationName:(NSString *)notificationName {
	%orig;
	ADDATTRIBUTE(notificationName, @"notification", @"post");
}
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	ADDATTRIBUTE(notificationName, @"notification", @"post");
}
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier {
	BOOL r = %orig;
	ADDATTRIBUTE(notificationName, @"notification", @"post");
	return r;
}

%end

typedef struct XXStruct_kUSYWB {
	unsigned _field1[8];
} XXStruct_kUSYWB;

@interface CPDistributedMessagingCenter : NSObject {
}
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(void *)token; //token being a XXStruct_kUSYWB
- (id)_initWithServerName:(id)serverName;
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error;
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error;
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)sendMessageName:(id)name userInfo:(id)info;
@end

%hook CPDistributedMessagingCenter

- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(void *)token {
	%orig;
	ADDATTRIBUTE(named, @"message", @"dispatch");
}
- (id)_initWithServerName:(id)serverName {
	id r = %orig;
	ADDATTRIBUTE(serverName, @"server", @"init");
	return r;
}
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context {
	BOOL r = %orig;
	CMCLogObject(message);
//NSLog(@"unknown instance (%p) of class %@", message, NSStringFromClass([message class]));
	ADDATTRIBUTE(message, @"message", @"send");
	return r;
}
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error {
	BOOL r = %orig;
	ADDATTRIBUTE(message, @"message", @"send");
	return r;
}
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector {
	%orig;
	ADDATTRIBUTE(messageName, @"message", @"register");
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info {
	id r = %orig;
	ADDATTRIBUTE(name, @"message", @"send");
	return r;
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error {
	id r = %orig;
	ADDATTRIBUTE(name, @"message", @"send");
	return r;
}
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context {
	%orig;
	ADDATTRIBUTE(name, @"message", @"send");
}
- (BOOL)sendMessageName:(id)name userInfo:(id)info {
	BOOL r = %orig;
	ADDATTRIBUTE(name, @"message", @"send");
	return r;
}

%end

//End class hooking
//Start function hooking

//convenient macros

#define paste(a,b) a ## b

#define fhook(returnValue, name, ...) \
static returnValue(* paste(original_, name))(__VA_ARGS__);\
returnValue paste(custom_, name)(__VA_ARGS__)

#define fhookit(name) MSHookFunction(name, paste(custom_, name), &(paste(original_, name)))

//end macros

@interface CoreFoundationNotificationCenter : NSObject
@end

@implementation CoreFoundationNotificationCenter
@end

fhook(void, CFNotificationCenterAddObserver, CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior) {
	original_CFNotificationCenterAddObserver(center, observer, callBack, name, object, suspensionBehavior);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = (name != NULL)? (NSString *)name:@"all";
	ADDATTRIBUTE_(nameString, @"notification", @"observe", [CoreFoundationNotificationCenter class]);
	[pool release];
}

fhook(void, CFNotificationCenterPostNotification, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately) {
	original_CFNotificationCenterPostNotification(center, name, object, userInfo, deliverImmediately);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ADDATTRIBUTE_((NSString *)name, @"notification", @"post", [CoreFoundationNotificationCenter class]);
	[pool release];
}

fhook(void, CFNotificationCenterPostNotificationWithOptions, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, CFOptionFlags options) {
	original_CFNotificationCenterPostNotificationWithOptions(center, name, object, userInfo, options);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ADDATTRIBUTE_((NSString *)name, @"notification", @"post", [CoreFoundationNotificationCenter class]);
	[pool release];
}

@interface CNotifications : NSObject
@end

@implementation CNotifications
@end

fhook(uint32_t, notify_post, const char *name) {
	uint32_t r = original_notify_post(name);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];

	ADDATTRIBUTE_(nameString, @"notification", @"post", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_check, const char *name, int *out_token) {
	uint32_t r = original_notify_register_check(name, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];

	ADDATTRIBUTE_(nameString, @"notification", @"register", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_signal, const char *name, int sig, int *out_token) {
	uint32_t r = original_notify_register_signal(name, sig, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];

	ADDATTRIBUTE_(nameString, @"notification", @"register", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_mach_port, const char *name, mach_port_t *notify_port, int flags, int *out_token) {
	uint32_t r = original_notify_register_mach_port(name, notify_port, flags, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];

	ADDATTRIBUTE_(nameString, @"notification", @"register", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_file_descriptor, const char *name, int *notify_fd, int flags, int *out_token) {
	uint32_t r = original_notify_register_file_descriptor(name, notify_fd, flags, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];

	ADDATTRIBUTE_(nameString, @"notification", @"register", [CNotifications class]);
	[pool release];
	return r;
}

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[UFSAssociationTable sharedInstance];

	fhookit(CFNotificationCenterAddObserver);
	fhookit(CFNotificationCenterPostNotification);
	fhookit(CFNotificationCenterPostNotificationWithOptions);

	fhookit(notify_post);
	fhookit(notify_register_check);
	fhookit(notify_register_signal);
	fhookit(notify_register_mach_port);
	fhookit(notify_register_file_descriptor);

	[pool release];
}
