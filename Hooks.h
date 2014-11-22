@interface NSNotificationCenter : NSObject {
}
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject;
- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject;
- (void)postNotificationName:(NSString *)notificationName object:(id)anObject userInfo:(NSDictionary *)userInfo;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter {
}
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)notificationName object:(id)arg4;
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)notificationName object:(id)arg4 suspensionBehavior:(unsigned int)arg5;
- (id)addObserverForName:(id)notificationName object:(id)arg2 queue:(id)arg3 usingBlock:(id)arg4;
- (id)addObserverForName:(id)notificationName object:(id)arg2 suspensionBehavior:(unsigned int)arg3 queue:(id)arg4 usingBlock:(id)arg5;
- (void)postNotification:(id)notificationName;
- (void)postNotificationName:(id)notificationName object:(id)arg2;
- (void)postNotificationName:(id)notificationName object:(id)arg2 userInfo:(id)arg3;
- (void)postNotificationName:(id)notificationName object:(id)arg2 userInfo:(id)arg3 options:(unsigned int)arg4;
- (void)postNotificationName:(id)notificationName object:(id)arg2 userInfo:(id)arg3 deliverImmediately:(BOOL)arg4;
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
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id *)reply auditToken:(void *)token; //token being a XXStruct_kUSYWB
- (void)registerForMessageName:(id)messageName target:(id)target selector:(SEL)selector;
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id *)reply error:(id *)error toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id *)reply error:(id *)error;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info;
- (id)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info error:(id *)error;
- (void)sendMessageAndReceiveReplyName:(id)name userInfo:(id)info toTarget:(id)target selector:(SEL)selector context:(void *)context;
- (BOOL)sendMessageName:(id)name userInfo:(id)info;
@end

void CFNotificationCenterAddObserver(CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior);
void CFNotificationCenterPostNotification(CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately);
void CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, CFOptionFlags options);

uint32_t notify_post(const char *name);
uint32_t notify_register_check(const char *name, int *out_token);
uint32_t notify_register_signal(const char *name, int sig, int *out_token);
uint32_t notify_register_mach_port(const char *name, mach_port_t *notify_port, int flags, int *out_token);
uint32_t notify_register_file_descriptor(const char *name, int *notify_fd, int flags, int *out_token);
