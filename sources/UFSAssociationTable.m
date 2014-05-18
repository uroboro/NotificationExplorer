#import "UFSAssociationTable.h"

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
