#import <notify.h>
// As associated objects were not supported until iOS 4, the work around I made for this single class was a mutable dictionary within a shared object. Now that I think about it, it could have been just a global dictionary
@interface UFSAssociation : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *associations;

+ (id)sharedInstance;

- (NSArray *)allNotifications;

- (void)setAssociation:(id)key withObject:(id)object;
- (id)getAssociation:(id)key;

@end

@implementation UFSAssociation

@synthesize associations;

+ (id)sharedInstance {
	static UFSAssociation *shared = nil;
	if (shared == nil) {
		shared = [[UFSAssociation alloc] init];
	}
	return shared;
}

- (id)init {
	if ((self = [super init])) {
		self.associations = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (NSArray *)allNotifications {
	return [[self.associations allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)setAssociation:(id)key withObject:(id)object {
	[self.associations setObject:object forKey:key];
}

- (id)getAssociation:(id)key {
	return [self.associations objectForKey:key];
}

- (void)dealloc {
	[self.associations release];
	[super dealloc];
}

@end

/*
[[UFSAssociation sharedInstance] setAssociation:a withObject:b];
b = [[UFSAssociation sharedInstance] getAssociation:a];
*/

@interface UFSAssociationTable : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *associations;

+ (id)sharedInstance;

- (NSDictionary *)allAssociationsDictionary;
- (NSArray *)allNotificationsForClass:(Class)aClass;

- (void)setAssociation:(id)key withObject:(id)object forClass:(Class)aClass;
- (id)getAssociation:(id)key forClass:(Class)aClass;

@end

@implementation UFSAssociationTable

@synthesize associations;

+ (id)sharedInstance {
	static UFSAssociationTable *shared = nil;
	if (shared == nil) {
		shared = [[UFSAssociationTable alloc] init];
	}
	return shared;
}

- (id)init {
	if ((self = [super init])) {
		self.associations = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (NSDictionary *)allAssociationsDictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	NSArray *keys = [[self associations] allKeys];
	for (NSUInteger i = 0; i < [keys count]; i++) {
		id key = [keys objectAtIndex:i];
		NSDictionary *dict = [[[self associations] objectForKey:key] associations];
		[dictionary setObject:dict forKey:key];
	}
	NSDictionary *r = [NSDictionary dictionaryWithDictionary:dictionary];
	[dictionary release];
	return r;
}

- (NSArray *)allNotificationsForClass:(Class)aClass {
	NSString *className = NSStringFromClass(aClass);
	UFSAssociation *assoc = [self.associations objectForKey:className];
	return (assoc == nil)? nil:[assoc allNotifications];
}

- (void)setAssociation:(id)key withObject:(id)object forClass:(Class)aClass {
	NSString *className = NSStringFromClass(aClass);
	UFSAssociation *assoc = [self.associations objectForKey:className];
	if (assoc == nil) {
		assoc = [[UFSAssociation alloc] init];
		[self.associations setObject:assoc forKey:className];
		[assoc release];
		assoc = [self.associations objectForKey:className];
	}
	[assoc setAssociation:key withObject:object];
}

- (id)getAssociation:(id)key forClass:(Class)aClass {
	NSString *className = NSStringFromClass(aClass);
	UFSAssociation *assoc = [self.associations objectForKey:className];
	return (assoc == nil)? nil:[assoc getAssociation:key];
}

- (void)dealloc {
	[self.associations release];
	[super dealloc];
}

@end

#define UFSAssociationTableAdd_(name, comment, class) \
[[UFSAssociationTable sharedInstance] setAssociation:name withObject:comment forClass:class]
#define UFSAssociationTableAdd(name, comment) \
UFSAssociationTableAdd_(name, comment, [self class])

//-----------------------------------------------------------------------------------------------------------

%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject {
	%orig;
	UFSAssociationTableAdd(notificationName, @"notification");
}

- (void)postNotification:(NSNotification *)notification {
	%orig;
	UFSAssociationTableAdd([notification name], @"notification");
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject {
	%orig;
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)userInfo {
	%orig;
	UFSAssociationTableAdd(notificationName, @"notification");
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
	UFSAssociationTableAdd(serverName, @"serverName");
	return r;
}
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (void)postNotificationName:(NSString *)notificationName {
	%orig;
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier {
	BOOL r = %orig;
	UFSAssociationTableAdd(notificationName, @"notification");
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
//NSLog(@"unknown instance (%p) of class %@", message, NSStringFromClass([message class]));
	UFSAssociationTableAdd(named, @"message");
}

- (id)_initWithServerName:(id)serverName {
	id r = %orig;
	UFSAssociationTableAdd(serverName, @"serverName");
	return r;
}
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context {
	BOOL r = %orig;
//NSLog(@"unknown instance (%p) of class %@", message, NSStringFromClass([message class]));
	UFSAssociationTableAdd(message, @"message");
	return r;
}
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error {
	BOOL r = %orig;
	UFSAssociationTableAdd(message, @"message");
	return r;
}
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector {
	%orig;
	UFSAssociationTableAdd(messageName, @"message");
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info {
	id r = %orig;
	UFSAssociationTableAdd(name, @"message");
	return r;
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error {
	id r = %orig;
	UFSAssociationTableAdd(name, @"message");
	return r;
}
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context {
	%orig;
	UFSAssociationTableAdd(name, @"message");
}
- (BOOL)sendMessageName:(id)name userInfo:(id)info {
	BOOL r = %orig;
	UFSAssociationTableAdd(name, @"message");
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
	UFSAssociationTableAdd_(nameString, @"notification", [CoreFoundationNotificationCenter class]);
	[pool release];
}

fhook(void, CFNotificationCenterPostNotification, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately) {
	original_CFNotificationCenterPostNotification(center, name, object, userInfo, deliverImmediately);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UFSAssociationTableAdd_((NSString *)name, @"notification", [CoreFoundationNotificationCenter class]);
	[pool release];
}

fhook(void, CFNotificationCenterPostNotificationWithOptions, CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, CFOptionFlags options) {
	original_CFNotificationCenterPostNotificationWithOptions(center, name, object, userInfo, options);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UFSAssociationTableAdd_((NSString *)name, @"notification", [CoreFoundationNotificationCenter class]);
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
	UFSAssociationTableAdd_(nameString, @"notification", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_check, const char *name, int *out_token) {
	uint32_t r = original_notify_register_check(name, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];
	UFSAssociationTableAdd_(nameString, @"notification", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_signal, const char *name, int sig, int *out_token) {
	uint32_t r = original_notify_register_signal(name, sig, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];
	UFSAssociationTableAdd_(nameString, @"notification", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_mach_port, const char *name, mach_port_t *notify_port, int flags, int *out_token) {
	uint32_t r = original_notify_register_mach_port(name, notify_port, flags, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];
	UFSAssociationTableAdd_(nameString, @"notification", [CNotifications class]);
	[pool release];
	return r;
}
fhook(uint32_t, notify_register_file_descriptor, const char *name, int *notify_fd, int flags, int *out_token) {
	uint32_t r = original_notify_register_file_descriptor(name, notify_fd, flags, out_token);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *nameString = [NSString stringWithUTF8String:name];
	UFSAssociationTableAdd_(nameString, @"notification", [CNotifications class]);
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
