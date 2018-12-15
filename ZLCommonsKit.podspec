#
# Be sure to run `pod lib lint ZLCommonsKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ZLCommonsKit'
s.version          = '0.0.1'
s.summary          = 'A short description of ZLCommonsKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/lianzhou/ZLCommonsKit'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'zhoulian' => 'lian.zhou@qq.com' }
s.source           = { :git => 'https://github.com/lianzhou/ZLCommonsKit', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'ZLCommonsKit/Classes/**/*'

s.resource_bundles = {
'ZLEmojiExpression' => ['ZLCommonsKit/Assets/ZLEmojiExpression/**/*'],

'ENImagePickerExpression' => ['ZLCommonsKit/Assets/ENImagePickerExpression/**/*'],

'ZLPlaceholderExp' => ['ZLCommonsKit/Assets/ZLPlaceholderExp/**/*']
}

# s.public_header_files = 'Pod/Classes/**/*.h', '~> 3.0.4'
s.frameworks = 'UIKit','Foundation'
s.dependency  'AFNetworking'
s.dependency  'SDWebImage', '~> 3.8.2'
s.dependency  'FMDB'
s.dependency  'DZNEmptyDataSet'
s.dependency  'YYKit'
s.dependency  'Masonry'
s.dependency  'MBProgressHUD'
s.dependency  'IQKeyboardManager'
s.dependency  'MJExtension'
s.dependency  'MJRefresh'
#ENImagePickerController 需要
s.dependency  'GPUImage'
s.dependency  'TOCropViewController'

s.dependency 'DTCoreText'



#s.subspec 'Framework' do |sss|
#s.ios.vendored_library    = 'ZLCommonsKit/Framework/**'
#end

end






