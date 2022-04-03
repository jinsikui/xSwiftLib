# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'

def common
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftyJSON'
  pod 'SnapKit'
  pod 'PromisesObjC'
  pod 'PromisesSwift'
  pod 'RxSwift'
  pod 'xUtil',    :git => "https://github.com/jinsikui/xUtil.git", :tag => 'v2.1.0-0'
  pod 'xUI',    :git => "https://github.com/jinsikui/xUI.git", :tag => 'v2.0.0-0'
  pod 'xNavigate',    :git => "https://github.com/jinsikui/xNavigate.git", :tag => 'v2.1.0-0'
  pod 'xAPI',    :git => "https://github.com/jinsikui/xAPI.git", :tag => 'v2.1.0-0'
  pod 'xTracking/Page',    :git => "https://github.com/jinsikui/xTracking.git", :tag => 'v2.2.0-0'
  pod 'xTracking/Expose',    :git => "https://github.com/jinsikui/xTracking.git", :tag => 'v2.2.0-0'
  
end

target 'xSwiftLib' do
    common
end

target 'xSwiftLibTests' do
    common
end

target 'xSwiftLibUITests' do
    common
end
