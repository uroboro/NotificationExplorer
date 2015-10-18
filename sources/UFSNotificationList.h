#import <Foundation/Foundation.h>

@interface UFSNotificationList : NSObject
@property (nonatomic, retain) NSMutableDictionary *notifications;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

+ (instancetype)sharedInstance;

- (BOOL)addAPI:(NSString *)api action:(NSString *)action type:(NSString *)type toNotification:(NSString *)notificationName;

- (NSString *)fileName;
/*
- (BOOL)sendList;
- (BOOL)writeToFile:(NSString *)path;
*/
@end
