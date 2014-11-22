@interface NSNotificationCenter : NSObject {
}
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)notificationSender;
- (id<NSObject>)addObserverForName:(NSString *)name object:(id)notificationSender queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender;
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter {
}
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)notificationSender;
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)notificationSender suspensionBehavior:(NSNotificationSuspensionBehavior)suspensionBehavior;
- (id)addObserverForName:(NSString *)notificationName object:(id)notificationSender queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
- (id)addObserverForName:(NSString *)notificationName object:(id)notificationSender suspensionBehavior:(NSNotificationSuspensionBehavior)suspensionBehavior queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
- (void)postNotification:(NSString *)notificationName;
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender;
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo options:(NSUInteger)notificationOptions;
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo deliverImmediately:(BOOL)deliverImmediately;
@end

@interface CPDistributedNotificationCenter : NSObject {
}
- (id)_initWithServerName:(NSString *)serverName;
- (void)deliverNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
- (void)postNotificationName:(NSString *)notificationName;
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
- (BOOL)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo toBundleIdentifier:(NSString *)bundleIdentifier;
@end

typedef struct XXStruct_kUSYWB {
	unsigned _field1[8];
} XXStruct_kUSYWB;

@interface CPDistributedMessagingCenter : NSObject {
}
- (id)_initWithServerName:(id)serverName;
- (void)_dispatchMessageNamed:(id)named userInfo:(NSDictionary *)userInfo reply:(id *)reply auditToken:(void *)token; //token being a XXStruct_kUSYWB
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector;
- (BOOL)_sendMessage:(id)message userInfo:(NSDictionary *)userInfo receiveReply:(id *)reply error:(NSError **)error toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(NSError **)error;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:NSDictionary *userInfo;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:NSDictionary *userInfo error:(NSError **)error;
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(NSDictionary *)userInfo toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)sendMessageName:(id)name userInfo:(NSDictionary *)userInfo;
@end

void CFNotificationCenterAddObserver(CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior);
void CFNotificationCenterPostNotification(CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately);
void CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, CFOptionFlags options);

uint32_t notify_post(const char *name);
uint32_t notify_register_check(const char *name, int *out_token);
uint32_t notify_register_signal(const char *name, int sig, int *out_token);
uint32_t notify_register_mach_port(const char *name, mach_port_t *notify_port, int flags, int *out_token);
uint32_t notify_register_file_descriptor(const char *name, int *notify_fd, int flags, int *out_token);
