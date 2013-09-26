NotificationExplorer
====================

See what notifications exist at runtime.

It keeps a list of notifications that come in contact with:
<br>classes:
-   NSNotificationCenter
-   CPDistributedNotificationCenter
-   CPDistributedMessagingCenter

<br>functions:
-   CFNotificationCenterAddObserver
-   CFNotificationCenterPostNotification
-   CFNotificationCenterPostNotificationWithOptions

In the future it will also track NSDistributedNotificationCenter;
Cleared out list of hooked classes and functions: https://ghostbin.com/paste/yyr9w

Designed to be used in cycript with the following commands:
?expand
[[[UFSAssociation sharedInstance] allNotifications] description]

UFSAssosiation may change its name without notice to reflect the objective of this project. The reason is that this class was created to replace objc_{get,set}AssosiatedObject() functions as they are not available in the iOS 3.2 SDK.
