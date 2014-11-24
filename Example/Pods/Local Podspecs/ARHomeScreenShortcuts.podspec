Pod::Spec.new do |s|
  s.name             = "ARHomeScreenShortcuts"
  s.version          = "0.1.0"
  s.summary          = "ARHomeScreenShortcuts."
  s.description      = <<-DESC
                       ARHomeScreenShortcuts.
                       DESC
  s.homepage         = "https://github.com/alexruperez/ARHomeScreenShortcuts"
  # s.screenshots     = "https://raw.githubusercontent.com/alexruperez/ARHomeScreenShortcuts/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "alexruperez" => "contact@alexruperez.com" }
  s.source           = { :git => "https://github.com/alexruperez/ARHomeScreenShortcuts.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/alexruperez'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'ARHomeScreenShortcuts' => ['Pod/Assets/*.png', 'Pod/Assets/*.html']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'GCDWebServer', '~> 3.2'
end
