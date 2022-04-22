---
sidebar_position: 1
---

# Project Setup

In order to get your project ready for Siri Shortcuts, you need to follow a couple steps.

## Enable the Siri Capability

Open your project's xcworkspace in Xcode > Capabilities > Add the Siri Capability.

![Add Siri Capability Xcode Screenshot](/img/getting-started/add-capability-example.png)

## Declare Shortcuts

Add each of your shortcuts' Activity Type in your Info.plist.

```xml title="Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  ...
  // highlight-start
  <key>NSUserActivityTypes</key>
  <array>
    <string>your.bundle.identifier.ExampleActivityType</string>
  </array>
  // highlight-end
</dict>
</plist>
```
