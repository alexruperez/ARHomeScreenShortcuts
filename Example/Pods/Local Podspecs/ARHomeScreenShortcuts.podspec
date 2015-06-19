Pod::Spec.new do |s|
  s.name             = "ARHomeScreenShortcuts"
  s.version          = "0.1.0"
  s.summary          = "Installs home screen shortcuts to features of your app."
  s.description      = <<-DESC
                       ARHomeScreenShortcuts installs home screen shortcuts to features of your app like [OneTap](https://itunes.apple.com/us/app/onetap/id502840938) or [Facebook Groups](https://itunes.apple.com/us/app/facebook-groups/id931735837).
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
	
  s.dependency 'GCDWebServer', '~> 3.2'
end
