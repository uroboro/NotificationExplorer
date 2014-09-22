#import <Foundation/Foundation.h>

@interface UFSNotificationList : NSObject
{
	NSMutableDictionary *_notifications;
	BOOL _enabled;
}
@property (nonatomic, retain) NSMutableDictionary *notifications;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

+ (instancetype)sharedInstance;

- (BOOL)prepareNotificationKey:(NSString *)notificationName;
- (BOOL)addAPI:(NSString *)api toNotification:(NSString *)notificationName;
- (BOOL)addAction:(NSString *)action toNotification:(NSString *)notificationName;
- (BOOL)setType:(NSString *)type toNotification:(NSString *)notificationName;
- (BOOL)addAPI:(NSString *)api action:(NSString *)action type:(NSString *)type toNotification:(NSString *)notificationName;

- (NSString *)fileName;
/*
- (BOOL)sendList;
- (BOOL)writeToFile:(NSString *)path;
*/
@end
