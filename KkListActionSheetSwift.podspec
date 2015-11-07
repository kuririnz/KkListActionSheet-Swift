#
#  Be sure to run `pod spec lint KkListActionSheet-Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "KkListActionSheetSwift"
  s.version      = "0.0.2"
  s.summary      = "it's light weight library. this library is extended the tableview to actionsheet"
  s.homepage     = "https://github.com/kuririnz/KkListActionSheet-Swift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "keisuke kuribayashi" => "montblanc.notdelicious@gmail.com" }
  # s.platform     = :ios, "5.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/kuririnz/KkListActionSheet-Swift.git", :tag => "0.0.2" }
  s.source_files = "KkListActionSheetSwift/source/*.swift"
  s.resource     = "KkListActionSheetSwift/resource/*.xib"
  s.resource_bundles = {
    "KkListActionSheetSwift" => ["resource/*.xib"]
  }
  s.framework    = "QuartzCore"
  s.requires_arc = true
end
