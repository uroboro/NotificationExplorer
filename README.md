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
-   notify_post
-   notify_register_check
-   notify_register_signal
-   notify_register_mach_port
-   notify_register_file_descriptor


Cleared out list of hooked classes and functions: Hooks.h<br>
In the future it will also track NSDistributedNotificationCenter, and any other class or function that behaves like these.

Designed to be used in cycript with the following commands:<br>
?expand<br>
[[UFSNotificationList sharedInstance].notifications description]

To save the table of notifications, you can do:<br>
[[UFSNotificationList sharedInstance].notifications writeToFile:@"/User/process.notifications.plist" atomically:YES]
