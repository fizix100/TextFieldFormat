
Pod::Spec.new do |s|
  s.name     = 'TextFieldFormat'
  s.version  = '0.0.1'
  s.platform = :ios, '7.0'
  s.license  = 'MIT'
  s.summary  = 'customize UITextField string format show as bank card format: 6222 2222 2222 2222'
  s.homepage = 'https://github.com/fizix100/TextFieldFormat'
  s.author   = { 'fizix100' => 'fizix100@hotmail.com' }
  s.source   = { :git => 'https://github.com/fizix100/TextFieldFormat.git', :tag => s.version.to_s }

  s.description = 'customize UITextField string format show as bank card format: 6222 2222 2222 2222'

  s.prefix_header_contents = '#import <objc/runtime.h>'
  s.source_files = 'Source/*.{h,m}'
  s.preserve_paths  = 'TextFieldFormat'
  s.requires_arc = true
end