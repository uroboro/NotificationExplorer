#import "UFSAssociation.h"

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
