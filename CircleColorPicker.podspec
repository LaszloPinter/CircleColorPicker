Pod::Spec.new do |s|
  s.name         = "CircleColorPicker"
  s.version      = "1.1.1"
  s.summary      = "Fancy round color picker for iOS in Swift"


  s.description  = <<-DESC
This is a highly customizable color picker view written in Swift.
                   DESC

  s.homepage     = "https://github.com/LaszloPinter/CircleColorPicker"
  s.screenshots  = "https://raw.githubusercontent.com/LaszloPinter/CircleColorPicker/master/screenshots/screenshot1.png", "https://raw.githubusercontent.com/LaszloPinter/CircleColorPicker/master/screenshots/screenshot2.png"


  s.license      = "MIT"
  s.author       = { "Laszlo Pinter" => "pinter.laci@gmail.com" }

  s.source       = { :git => "https://github.com/LaszloPinter/CircleColorPicker.git", :tag => "#{s.version}" }
  s.platform     = :ios, '10.0'
  s.source_files = "CircleColorPicker/**/*.{h,m,swift}"  
  s.resource_bundle = { 'CircleColorPicker' => 'CircleColorPicker/**/*.{storyboard,xib,png,xcassets}' }

end
