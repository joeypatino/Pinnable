Pod::Spec.new do |s|
  s.name             = 'Pin'
  s.version          = '0.1.6'
  s.summary          = 'Collection of methods to help with Layout constraints'
 
  s.description      = 'Collection of functions to assist in creating NSLayoutConstraints' 
  s.homepage         = 'https://github.com/joeypatino/Pin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Joseph Patino' => 'joseph.onitap@gmail.com' }
  s.source           = { :git => 'https://github.com/joeypatino/Pin.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '8.0'
  s.source_files = 'Pin/Pin/*.swift'
 
end
