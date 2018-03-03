# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SimpleSynth' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleSynth
pod 'AudioKit'
pod 'SnapKit'

post_install do |installer|
installer.pods_project.build_configurations.each do |config|
config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(FRAMEWORK_SEARCH_PATHS)']
end
end

end
