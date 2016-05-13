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
- Build and run the project in the iOS simulator or your device (iOS 8+).
- Turn up your speaker volume for a little tada action 

#### Core Functionality

- Sign in with Twitter (Facebook doesn't allow getting lists of friends anymore :()
- Select / search for friends to eat with
- Once you select someone, relaunching the app will ensure they stay selected
- Generate a new food dictator for the day
- See options to eat scrumptious food near Viv

#### Architecture

I took a fairly straightforward MVC approach with manager classes doing any API calls. Storage is just a wrapper around `NSKeyedArchiver` to persist the humans onto the device. For fun projects like these that need more personality, I prefer to create my own UI classes rather than using out-of-the-box Apple UI controls (e.g. the search bar is a custom textfield, navigation doesn't use the standard nav bar, etc.).

I tend to avoid using storyboards since they become difficult to code review and conflict fix on larger teams, therefore the view code is all written using autolayout so it scales nicely across devices.

#### Assumptions

- Written in Swift 2.x (requires Xcode 7.3+)
- iOS 8.0+
- We only need Portrait orientation for now, so did not handle device rotation
- Only iPhone / iPod Touch devices rather than a universal app, but should run fine on an iPad
- Prototype only, so no tests were written

#### Improvements

- Need to implement proper font scaling.
- Unit tests should be written.
- Hook up keyboard avoidance.
- Twitter API limits are very low (15 calls per 15 minute window); would have to cache to work around it.
- Food options are scoped only to Viv area. Easy enough to hook up CoreLocation, but ran out of time.
- TwitterKit doesn't support canceling pending requests like Alamofire does.

#### Audio Credit

- https://www.freesound.org/people/pfranzen/sounds/254049/ (http://creativecommons.org/licenses/by/3.0/)

#### Loading GIF Credit

- https://dribbble.com/shots/1964664-Rubik-s-Loader

#### Other Artwork

- I created the logo & designs in Sketch for a personal project called ChefBrain and they were easy enough to port over.
- Icons: http://www.streamlineicons.com