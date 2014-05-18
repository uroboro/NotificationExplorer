#import "UFSAssociation.h"

@interface UFSAssociationTable : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *associations;

+ (id)sharedInstance;

- (NSDictionary *)allAssociationsDictionary;
- (NSArray *)allNotificationsForClass:(Class)aClass;

- (void)setAssociation:(id)key withObject:(id)object forClass:(Class)aClass;
- (id)getAssociation:(id)key forClass:(Class)aClass;

@end

#define UFSAssociationTableAdd_(name, object, class) \
[[UFSAssociationTable sharedInstance] setAssociation:name withObject:object forClass:class]
#define UFSAssociationTableAdd(name, object) \
UFSAssociationTableAdd_(name, object, [self class])

#define UFSAssociationTableGet_(name, class) \
[[UFSAssociationTable sharedInstance] getAssociation:name forClass:class]
#define UFSAssociationTableGet(name) \
UFSAssociationTableGet_(name, [self class])