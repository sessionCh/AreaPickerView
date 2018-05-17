#
# Be sure to run `pod lib lint AreaPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'AreaPickerView'
    s.version          = '0.1.0'
    s.summary          = '实用简洁的省市区选择器.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    一款实用简洁的省市区选择器.
    DESC
    
    s.homepage         = 'https://github.com/sessionCh/AreaPickerView'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'sessionCh' => '641331737@qq.com' }
    s.source           = { :git => 'https://github.com/sessionCh/AreaPickerView.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.swift_version             = "4.1"
    s.platform                  = :ios, "9.3"
    s.ios.deployment_target     = '8.0'
    
    s.source_files = 'AreaPickerView/Classes/**/*'
    
    s.resource_bundles = {
        'AreaPickerView' => ['AreaPickerView/Resources/*.{storyboard,xcassets,json}']
    }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
