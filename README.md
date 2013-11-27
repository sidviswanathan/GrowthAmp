GrowthAmp
=========

##Integration Steps

1. Download the SDK from [here](http://www.growthamp.com/download)

1. Add the GrowthAmp SDK to your project

1. Added framework dependancies to your project
    
    * AddressBook.framework
    * CoreGraphics.framework
    * MessageUI.framework   

1. Add the `-all_load` flag in your projects's *Build Settings > Other Linker Flags*
(Necessary because of this [bug](https://developer.apple.com/library/mac/#qa/qa2006/qa1490.html))

1. In your AppDelegate.m, add the following code to application:didFinishWithOptions:  
 `[[GALoader sharedInstance] fetchSettings];`

1. In your AppDelegate.m, add the following code to applicationDidBecomeActive:  
`[[GALoader sharedInstance] checkAutoLaunch:self.window.rootViewController showSplash:YES];`

1. Customize the GAConfig.plist configuration for your project, including adding your Secret Key

1. Add the following code to invoke the Invitations Controller. You can optionaly include the current user's name and email:

```
    // Optionally set user contact information before presenting invitation view controller
    [GALoader sharedInstance].userContact = @{@"firstName" : @"",
                                              @"lastName"  : @"",
                                              @"email"     : @""};
                                              `
      // Invoke the Growth Amp invitation view controller
      [[GALoader sharedInstance] presentInvitationsFromController:self
                                                     showSplash:YES
                                                    sessionType:@"test_button_1"];
```

