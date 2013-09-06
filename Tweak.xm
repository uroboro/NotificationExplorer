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

- (NSArray *)allNotificationsForClass:(NSString *)className;

- (void)setAssociation:(id)key withObject:(id)object forClass:(NSString *)className;
- (id)getAssociation:(id)key forClass:(NSString *)className;

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

- (NSArray *)allNotificationsForClass:(NSString *)className {
	UFSAssociation *assoc = [self.associations objectForKey:className];
	return (assoc == nil)? nil:[assoc allNotifications];
}

- (void)setAssociation:(id)key withObject:(id)object forClass:(NSString *)className {
	UFSAssociation *assoc = [self.associations objectForKey:className];
	if (assoc == nil) {
		assoc = [[UFSAssociation alloc] init];
		[self.associations setObject:assoc forKey:className];
		[assoc release];
		assoc = [self.associations objectForKey:className];
	}
	[assoc setAssociation:key withObject:object];
}

- (id)getAssociation:(id)key forClass:(NSString *)className {
	UFSAssociation *assoc = [self.associations objectForKey:className];
	return (assoc == nil)? nil:[assoc getAssociation:key];
}

- (void)dealloc {
	[self.associations release];
	[super dealloc];
}

@end

//-----------------------------------------------------------------------------------------------------------

%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject {
	%orig;
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"NSNotificationCenter"];
}

- (void)postNotification:(NSNotification *)notification {
	%orig;
//NSLog(@"offending instance (%p) of class %@ in %@", notification, NSStringFromClass([notification class]), NSStringFromClass([self class]));
														//([notification respondsToSelector:@selector(name)])? [notification name]:@"notif"
	[[UFSAssociationTable sharedInstance] setAssociation:[notification name] withObject:@"notification" forClass:@"NSNotificationCenter"];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject {
	%orig;
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"NSNotificationCenter"];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)userInfo {
	%orig;
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"NSNotificationCenter"];
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
	[[UFSAssociationTable sharedInstance] setAssociation:serverName withObject:@"serverName" forClass:@"CPDistributedNotificationCenter"];
	return r;
}
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
//NSLog(@"uroboro %s", __PRETTY_FUNCTION__);
	%orig;
//NSLog(@"offending instance (%p) of class %@ in %@", notification, NSStringFromClass([notification class]), NSStringFromClass([self class]));
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"CPDistributedNotificationCenter"];
}
- (void)postNotificationName:(NSString *)notificationName {
	%orig;
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"CPDistributedNotificationCenter"];
}
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
	%orig;
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"CPDistributedNotificationCenter"];
}
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier {
	BOOL r = %orig;
	[[UFSAssociationTable sharedInstance] setAssociation:notificationName withObject:@"notification" forClass:@"CPDistributedNotificationCenter"];
	return r;
}

%end
