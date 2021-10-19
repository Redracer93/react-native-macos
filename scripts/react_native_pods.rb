# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

def use_react_native! (options={})
  # The prefix to react-native
  prefix = options[:path] ||= "../node_modules/react-native"

  # Include Fabric dependencies
  fabric_enabled = options[:fabric_enabled] ||= false

  # Include DevSupport dependency
  production = options[:production] ||= false

  # Include Hermes dependencies
  hermes_enabled = options[:hermes_enabled] ||= false

  # The Pods which should be included in all projects
  pod 'FBLazyVector', :path => "#{prefix}/Libraries/FBLazyVector"
  pod 'FBReactNativeSpec', :path => "#{prefix}/Libraries/FBReactNativeSpec"
  pod 'RCTRequired', :path => "#{prefix}/Libraries/RCTRequired"
  pod 'RCTTypeSafety', :path => "#{prefix}/Libraries/TypeSafety"
  pod 'React', :path => "#{prefix}/"
  pod 'React-Core', :path => "#{prefix}/"
  pod 'React-CoreModules', :path => "#{prefix}/React/CoreModules"
  pod 'React-RCTActionSheet', :path => "#{prefix}/Libraries/ActionSheetIOS"
  pod 'React-RCTAnimation', :path => "#{prefix}/Libraries/NativeAnimation"
  pod 'React-RCTBlob', :path => "#{prefix}/Libraries/Blob"
  pod 'React-RCTImage', :path => "#{prefix}/Libraries/Image"
  pod 'React-RCTLinking', :path => "#{prefix}/Libraries/LinkingIOS"
  pod 'React-RCTNetwork', :path => "#{prefix}/Libraries/Network"
  pod 'React-RCTSettings', :path => "#{prefix}/Libraries/Settings"
  pod 'React-RCTText', :path => "#{prefix}/Libraries/Text"
  pod 'React-RCTVibration', :path => "#{prefix}/Libraries/Vibration"
  pod 'React-Core/RCTWebSocket', :path => "#{prefix}/"

  unless production
    pod 'React-Core/DevSupport', :path => "#{prefix}/"
  end

  pod 'React-cxxreact', :path => "#{prefix}/ReactCommon/cxxreact"
  pod 'React-jsi', :path => "#{prefix}/ReactCommon/jsi"
  pod 'React-jsiexecutor', :path => "#{prefix}/ReactCommon/jsiexecutor"
  pod 'React-jsinspector', :path => "#{prefix}/ReactCommon/jsinspector"
  pod 'React-callinvoker', :path => "#{prefix}/ReactCommon/callinvoker"
  pod 'React-runtimeexecutor', :path => "#{prefix}/ReactCommon/runtimeexecutor"
  pod 'React-perflogger', :path => "#{prefix}/ReactCommon/reactperflogger"
  pod 'ReactCommon/turbomodule/core', :path => "#{prefix}/ReactCommon"
  pod 'Yoga', :path => "#{prefix}/ReactCommon/yoga", :modular_headers => true

  pod 'DoubleConversion', :podspec => "#{prefix}/third-party-podspecs/DoubleConversion.podspec"
  pod 'glog', :podspec => "#{prefix}/third-party-podspecs/glog.podspec"
  pod 'RCT-Folly', :podspec => "#{prefix}/third-party-podspecs/RCT-Folly.podspec"

  # TODO(macOS GH#214)
  pod 'boost-for-react-native', :podspec => "#{prefix}/third-party-podspecs/boost-for-react-native.podspec"

  if fabric_enabled
    pod 'React-Fabric', :path => "#{prefix}/ReactCommon"
    pod 'React-graphics', :path => "#{prefix}/ReactCommon/fabric/graphics"
    pod 'React-jsi/Fabric', :path => "#{prefix}/ReactCommon/jsi"
    pod 'React-RCTFabric', :path => "#{prefix}/React"
    pod 'RCT-Folly/Fabric', :podspec => "#{prefix}/third-party-podspecs/RCT-Folly.podspec"
  end

  if hermes_enabled
    pod 'React-Core/Hermes', :path => "#{prefix}/"
    pod 'hermes-engine'
    pod 'libevent', :podspec => "#{prefix}/third-party-podspecs/libevent.podspec"
  end
end

def use_flipper!(versions = {}, configurations: ['Debug'])
  versions['Flipper'] ||= '~> 0.54.0'
  versions['Flipper-DoubleConversion'] ||= '1.1.7'
  versions['Flipper-Folly'] ||= '~> 2.2'
  versions['Flipper-Glog'] ||= '0.3.6'
  versions['Flipper-PeerTalk'] ||= '~> 0.0.4'
  versions['Flipper-RSocket'] ||= '~> 1.1'
  pod 'FlipperKit', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FlipperKitLayoutPlugin', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/SKIOSNetworkPlugin', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FlipperKitUserDefaultsPlugin', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FlipperKitReactPlugin', versions['Flipper'], :configurations => configurations
  # List all transitive dependencies for FlipperKit pods
  # to avoid them being linked in Release builds
  pod 'Flipper', versions['Flipper'], :configurations => configurations
  pod 'Flipper-DoubleConversion', versions['Flipper-DoubleConversion'], :configurations => configurations
  pod 'Flipper-Folly', versions['Flipper-Folly'], :configurations => configurations
  pod 'Flipper-Glog', versions['Flipper-Glog'], :configurations => configurations
  pod 'Flipper-PeerTalk', versions['Flipper-PeerTalk'], :configurations => configurations
  pod 'Flipper-RSocket', versions['Flipper-RSocket'], :configurations => configurations
  pod 'FlipperKit/Core', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/CppBridge', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FBCxxFollyDynamicConvert', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FBDefines', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FKPortForwarding', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FlipperKitHighlightOverlay', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FlipperKitLayoutTextSearchable', versions['Flipper'], :configurations => configurations
  pod 'FlipperKit/FlipperKitNetworkPlugin', versions['Flipper'], :configurations => configurations
end

# Post Install processing for Flipper
def flipper_post_install(installer)
  installer.pods_project.targets.each do |target|
    if target.name == 'YogaKit'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.1'
      end
    end
  end
end

# Pre Install processing for Native Modules
def codegen_pre_install(installer, options={})
  prefix = options[:path] ||= "../node_modules/react-native"
  codegen_path = options[:codegen_path] ||= "../node_modules/react-native-codegen"

  Dir.mktmpdir do |dir|
    native_module_spec_name = "FBReactNativeSpec"
    schema_file = dir + "/schema-#{native_module_spec_name}.json"
    srcs_dir = "#{prefix}/Libraries"
    schema_generated = system("node #{codegen_path}/lib/cli/combine/combine-js-to-schema-cli.js #{schema_file} #{srcs_dir}")
    specs_generated = system("node #{prefix}/scripts/generate-native-modules-specs-cli.js ios #{schema_file} #{srcs_dir}/#{native_module_spec_name}/#{native_module_spec_name}")
  end
end

def use_react_native_codegen!(spec, options={})
  # The path to react-native (e.g. react_native_path)
  prefix = options[:path] ||= File.join(__dir__, "..")

  # The path to JavaScript files
  srcs_dir = options[:srcs_dir] ||= File.join(prefix, "Libraries")

  # Library name (e.g. FBReactNativeSpec)
  library_name = spec.name
  modules_output_dir = File.join(prefix, "Libraries/#{library_name}/#{library_name}")

  # Run the codegen as part of the Xcode build pipeline.
  spec.script_phase = {
    :name => 'Generate Specs',
    :input_files => [srcs_dir],
    :output_files => ["$(DERIVED_FILE_DIR)/codegen.log"],
    :script => "sh '#{File.join(__dir__, "generate-specs.sh")}' | tee \"${SCRIPT_OUTPUT_FILE_0}\"",
    :execution_position => :before_compile
  }

  # Since the generated files are not guaranteed to exist when CocoaPods is run, we need to create
  # empty files to ensure the references are included in the resulting Pods Xcode project.
  mkdir_command = "mkdir -p #{modules_output_dir}"
  generated_filenames = [ "#{library_name}.h", "#{library_name}-generated.mm" ]
  generated_files = generated_filenames.map { |filename| File.join(modules_output_dir, filename) }

  if ENV['USE_FABRIC'] == '1'
    # We use a different library name for components, as well as an additional set of files.
    # Eventually, we want these to be part of the same library as #{library_name} above.
    components_library_name = "rncore"
    components_output_dir = File.join(prefix, "ReactCommon/react/renderer/components/#{components_library_name}")
    mkdir_command += " #{components_output_dir}"
    components_generated_filenames = [
      "ComponentDescriptors.h",
      "EventEmitters.cpp",
      "EventEmitters.h",
      "Props.cpp",
      "Props.h",
      "RCTComponentViewHelpers.h",
      "ShadowNodes.cpp",
      "ShadowNodes.h"
    ]
    generated_files = generated_files.concat(components_generated_filenames.map { |filename| File.join(components_output_dir, filename) })
  end

  spec.prepare_command = "#{mkdir_command} && touch #{generated_files.reduce() { |str, file| str + " " + file }}"
end
