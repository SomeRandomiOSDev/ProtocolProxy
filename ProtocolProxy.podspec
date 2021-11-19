Pod::Spec.new do |s|

  s.name         = "ProtocolProxy"
  s.version      = "0.1.2"
  s.summary      = "Flexible proxy for overriding and observing protocol method/property messages"
  s.description  = <<-DESC
                   A small helper library that provides a proxy class for overriding and observing method and property messages from one or more protocols
                   DESC

  s.homepage     = "https://github.com/SomeRandomiOSDev/ProtocolProxy"
  s.license      = "MIT"
  s.author       = { "Joe Newton" => "somerandomiosdev@gmail.com" }
  s.source       = { :git => "https://github.com/SomeRandomiOSDev/ProtocolProxy.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '9.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.public_header_files = 'Sources/ProtocolProxy/include/ProtocolProxy.h'
  s.source_files        = 'Sources/ProtocolProxy/**/*.{h,m}', 'Sources/ProtocolProxySwift/*.swift'
  s.swift_versions      = ['5.0']
  s.cocoapods_version   = '>= 1.7.3'

  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target     = '9.0'
    ts.macos.deployment_target   = '10.10'
    ts.tvos.deployment_target    = '9.0'
    ts.watchos.deployment_target = '2.0'

    ts.pod_target_xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$PODS_TARGET_SRCROOT/Tests/ProtocolProxyTestsBase/include',
                               'HEADER_SEARCH_PATHS' => '$PODS_TARGET_SRCROOT/Tests/ProtocolProxyTestsBase/include' }
    ts.preserve_paths      = 'Tests/ProtocolProxyTestsBase/include/module.modulemap'
    ts.source_files        = 'Tests/ProtocolProxyObjCTests/*.m',
                             'Tests/ProtocolProxySwiftTests/*.swift',
                             'Tests/ProtocolProxyTestsBase/**/*{h,m}'
  end

end
