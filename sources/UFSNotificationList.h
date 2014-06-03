#import <Foundation/Foundation.h>

@interface UFSNotificationList : NSObject
{
	NSMutableDictionary *_notifications;
}
@property (nonatomic, retain) NSMutableDictionary *notifications;

+ (instancetype)sharedInstance;

- (void)prepareNotificationKey:(NSString *)notificationName;
- (void)addAPI:(NSString *)api toNotification:(NSString *)notificationName;
- (void)addAction:(NSString *)action toNotification:(NSString *)notificationName;
- (void)setType:(NSString *)type toNotification:(NSString *)notificationName;
- (void)addAPI:(NSString *)api action:(NSString *)action type:(NSString *)type toNotification:(NSString *)notificationName;

@end