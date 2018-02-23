Pod::Spec.new do |s|
  s.name                  =  'LayerKitDiagnostics'
  s.version               =  '1.0.2'
  s.summary               =  'The LayerKit Diagnostics interfaces'
  s.homepage              =  'http://layer.com'
  s.author                =  { 'Daniel Maness' => 'daniel@layer.com' }
  s.source                =  { git: 'https://github.com/layerhq/LayerKit-Diagnostics.git', tag: "v#{s.version}" }
  s.ios.frameworks        =  'UIKit'
  s.ios.deployment_target =  '8.0'
  s.license               =  'Commercial'
  s.platform              =  :ios, '8.0'
  s.requires_arc          =  true
  s.source_files          =  'Code/**/*.{h,m}'
  s.public_header_files   =  'Code/**/*.h'
  s.dependency               'LayerKit', '>= 0.22.0'
end
