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
		shared.associations = [[NSMutableDictionary alloc] init];
	}
	return shared;
}

- (NSArray *)allNotifications {
	return [[[self associations] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
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

%hook NSNotificationCenter

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject {
	%orig;
	[[UFSAssociation sharedInstance] setAssociation:notificationName withObject:@""];
}

- (void)postNotification:(NSNotification *)notification {
	%orig;
	[[UFSAssociation sharedInstance] setAssociation:[notification name] withObject:@""];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject {
	%orig;
	[[UFSAssociation sharedInstance] setAssociation:notificationName withObject:@""];
}
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
	%orig;
	[[UFSAssociation sharedInstance] setAssociation:notificationName withObject:@""];
}
%end
