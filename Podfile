platform :ios, '16.0'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   xcconfig_path = config.base_configuration_reference.real_path
   xcconfig = File.read(xcconfig_path)
   xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
   File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
  end
 end
end

target 'Flash Chat iOS13' do
  use_frameworks!

  # Pods for Flash Chat iOS13
  pod 'Firebase'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'

end
