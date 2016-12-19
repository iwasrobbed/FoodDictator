platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# use frameworks for Swift
use_frameworks!

project 'FoodDictator'

target 'FoodDictator' do

  # Twitter Login
  pod 'TwitterKit'

  # Networking
  pod 'Alamofire'

  # Autolayout
  pod 'SnapKit'

  # Models
  pod 'LazyObject'

  # Image Downloading
  pod 'SDWebImage'

  # GIF
  pod 'SwiftyGif'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end