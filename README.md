## Food Dictator

>No soup for you!

---

#### Install and Run

- Clone this repo to your Mac that has the latest Xcode installed.
- Once you have [CocoaPods](http://cocoapods.org) installed, run:

```shell
$ pod install
```
to install any 3rd party dependencies.

- Open the `.xcworkspace` file that is generated.
- Build and run the project in the iOS simulator or your device.

#### Core Functionality

- Sign in with Facebook
- Select friends to eat with
- Generate a new food dictator for the day
- See options to eat scrumptious food

#### Assumptions

- iOS 8.0+.
- We only need Portrait orientation for now, so did not handle device rotation.
- Only iPhone / iPod Touch devices rather than a universal app, but should run fine on an iPad.
- Prototype only, so no tests were written.

#### Improvements

- Need to implement proper font scaling.
- Unit tests should be written.
