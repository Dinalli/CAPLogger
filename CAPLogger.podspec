Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "CAPLogger"
s.summary = "CAPLogger is a ligthweight logger to log to file on iOS."
s.requires_arc = true
s.version = "0.3.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Andrew Donnelly" => "Dinalli@gmail.com" }
s.homepage = "https://github.com/Dinalli/CAPLogger"
s.source = { :git => "https://github.com/Dinalli/CAPLogger.git", :tag => "#{s.version}"}
s.framework = "UIKit"
s.source_files = "CAPLogger/**/*.{h,m}"
end