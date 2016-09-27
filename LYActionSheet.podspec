Pod::Spec.new do |s|
  s.name         = "LYActionSheet"
  s.version      = "1.2.1"
  s.summary      = "An actionSheet like WeChat"
  s.homepage     = "https://github.com/louis-ly/LYActionSheet"
  s.license      = "MIT"
  s.frameworks   = "UIKit"
  s.platform     = :ios, '6.0'
  s.author       = { "louis" => "396868934@qq.com" }
  s.source       = { :git => "https://github.com/louis-ly/LYActionSheet.git", :tag => s.version }
  s.source_files  = 'LYActionSheet/Classes/*.{h,m}'
  s.requires_arc = true
end
