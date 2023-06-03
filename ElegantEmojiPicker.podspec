Pod::Spec.new do |s|
  s.name = 'ElegantEmojiPicker'
  s.license = 'MIT'
  s.summary = 'Aesthetic, simple, and powerful emoji picker for Swift built with UIKit.'
  s.homepage = 'https://github.com/Finalet/Elegant-Emoji-Picker'
  s.author = { 'Grant Oganyan' => 'grant1599@mail.ru' }
  s.source = { :git => 'https://github.com/Finalet/Elegant-Emoji-Picker.git', :branch => 'main' }

  s.ios.deployment_target = '13.0'

  s.swift_versions = ['5']

  s.source_files = 'Sources/**/*.{swift}'

  s.resource_bundle = {
    'ElegantEmojiPicker' => ['Sources/Resources/Emoji Unicode 15.0.json', 'Sources/Resources/Icons.xcassets']
  }
end
