Pod::Spec.new do |s|
    
  s.name                = "ProtocolProxy"
  s.version             = "0.1.0"
  s.summary             = "Flexible proxy for overriding and observing protocol method/property messages"
  s.description         = <<-DESC
                          A small helper library that provides a proxy class for overriding and observing method and property messages from one or more protocols
                          DESC

  s.homepage            = "https://github.com/SomeRandomiOSDev/ProtocolProxy"
  s.license             = "MIT"
  s.author              = { "Joseph Newton" => "somerandomiosdev@gmail.com" }

  s.ios.deployment_target     = '9.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source              = { :git => "https://github.com/SomeRandomiOSDev/ProtocolProxy.git", :tag => s.version.to_s }

  s.public_header_files = 'Sources/ProtocolProxy/include/ProtocolProxy.h'
  s.source_files        = 'Sources/ProtocolProxy/**/*.{h,m,swift}', 'Sources/ProtocolProxySwift/**/*.swift'
  s.frameworks          = 'Foundation'
  s.requires_arc        = true

  s.swift_versions      = ['5.0']
  s.cocoapods_version   = '>= 1.7.3'
  
end
