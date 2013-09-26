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

#define UFSAssociationTableAdd(name, comment) \
[[UFSAssociationTable sharedInstance] setAssociation:name withObject:comment forClass:[self class]]

//-----------------------------------------------------------------------------------------------------------

%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd(notificationName, @"notification");
}

- (void)postNotification:(NSNotification *)notification {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:[notification name] withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd([notification name], @"notification");
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)userInfo {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
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
//	[[UFSAssociationTable sharedInstance] setAssociation:serverName withObject:@"serverName" forClass:[self class]];
	UFSAssociationTableAdd(serverName, @"serverName");
	return r;
}
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (void)postNotificationName:(NSString *)notificationName {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd(notificationName, @"notification");
}
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier {
	BOOL r = %orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:[self class]];
	UFSAssociationTableAdd(notificationName, @"notification");
	return r;
}

%end

typedef struct XXStruct_kUSYWB {
	unsigned _field1[8];
} XXStruct_kUSYWB;

@interface CPDistributedMessagingCenter : NSObject {
}
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(XXStruct_kUSYWB *)token;
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
/*
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(XXStruct_kUSYWB *)token {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:named withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(named, @"message");
}
*/
- (id)_initWithServerName:(id)serverName {
	id r = %orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:serverName withObject:@"serverName" forClass:[self class]];
	UFSAssociationTableAdd(serverName, @"serverName");
	return r;
}
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context {
	BOOL r = %orig;
//NSLog(@"unknown instance (%p) of class %@", message, NSStringFromClass([message class]));
//	[[UFSAssociationTable sharedInstance] setAssociation:message withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(message, @"message");
	return r;
}
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error {
	BOOL r = %orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:message withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(message, @"message");
	return r;
}
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:messageName withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(messageName, @"message");
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info {
	id r = %orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:name withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(name, @"message");
	return r;
}
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error {
	id r = %orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:name withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(name, @"message");
	return r;
}
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context {
	%orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:name withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(name, @"message");
}
- (BOOL)sendMessageName:(id)name userInfo:(id)info {
	BOOL r = %orig;
//	[[UFSAssociationTable sharedInstance] setAssociation:name withObject:@"message" forClass:[self class]];
	UFSAssociationTableAdd(name, @"message");
	return r;
}

%end