#
# Be sure to run `pod lib lint SwiftyDraft.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftyDraft"
  s.version          = "0.0.1"
  s.summary          = "Rich-text editor with Draft.js"
  s.homepage         = "https://github.com/oneteam-dev/SwiftyDraft"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "ngs" => "a@ngs.io" }
  s.source           = { :git => "https://github.com/oneteam-dev/SwiftyDraft.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SwiftyDraft/Classes/**/*'
  s.resource_bundles = {
    'SwiftyDraft' => ['SwiftyDraft/Assets/*.js', 'SwiftyDraft/Assets/*.html', 'SwiftyDraft/Assets/Icons/*.png']
  }

  s.prepare_command = <<-CMD
    if [ -d $HOME/.nodenv/bin ]; then
      export PATH=$HOME/.nodenv/bin:$PATH
      eval "$(nodenv init -)"
    fi

    if [ -d $HOME/.nodenv/shims ]; then
      export PATH=$HOME/.nodenv/shims:$PATH
      eval "$(nodenv init -)"
    fi

    npm -v >/dev/null 2>&1 && npm install && npm run build
  CMD
end
