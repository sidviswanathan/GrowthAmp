GrowthAmp
=========

##Integration Steps

1. Download the SDK from [here](http://www.growthamp.com/download)

1. Drag libGrowthAmp.a and drop in the frameworks group of your project

1. Drag GrowthAmpResources.bundle and drop in the frameworks group of your project

1. Drag GAConfig.plist file and drop it into your project.
  
1. Added following framework dependancies to your project
    
    * AddressBook.framework
    * MessageUI.framework
    * SystemConfiguration.framework
    * CoreTelephony.framework   
    
1. Add the `-all_load` flag in your projects's *Build Settings > Other Linker Flags*

1. Open the GAConfig.plist file and add your Secret Key

1. Add "#import <GrowthAmp/GrowthAmp.h>" to top of your AppDelegate.m

1. In your AppDelegate.m, add the following code to application:didFinishWithOptions:  
```
[[GALoader sharedInstance] fetchSettings];
```

1. In your AppDelegate.m, add the following code to applicationDidBecomeActive:  
```
[[GALoader sharedInstance] checkAutoLaunch:self.window.rootViewController showSplash:YES];
```

1. Add the following code to invoke the Invitations Controller. You can optionally include the current user's name and email before invoking the Invitations Controller.  Be sure to add "#import <GrowthAmp/GrowthAmp.h>" at the top of the file.

```
// Optionally set user contact information before presenting invitation view controller
[GALoader sharedInstance].userContact = @{@"firstName" : @"",
                                          @"lastName"  : @"",
                                          @"email"     : @""};
                                          
// Invoke the Growth Amp invitation view controller
[[GALoader sharedInstance] presentInvitationsFromController:self
                                                 showSplash:YES
                                                sessionType:@"test_button_1"];
```


