require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNZalo"
  s.version      = package["version"]
  s.summary      = "RNZalo"
  s.description  = <<-DESC
    #{package["description"]}
  DESC
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.author       = { package["author"] => "tuzan.victor@gmail.com" } 
  s.platform     = :ios, "10.0"
  s.source       = { :git => package["repository"]["url"], :tag => "v#{package["version"]}" }
  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React-Core"
  s.dependency "ZaloSDK"
end
