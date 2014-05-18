// As associated objects were not supported until iOS 4, the work around I made for this single class was a mutable dictionary within a shared object. Now that I think about it, it could have been just a global dictionary

#import <Foundation/Foundation.h>

@interface UFSAssociation : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *associations;

+ (id)sharedInstance;

- (NSArray *)allNotifications;

- (void)setAssociation:(id)key withObject:(id)object;
- (id)getAssociation:(id)key;

@end