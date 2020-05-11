Pod::Spec.new do |s|
s.name = 'DWMediator'
s.version = '0.0.3'
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.summary = '基于Protocol的免注册的中间件方案。'
s.homepage = 'https://github.com/CodeWicky/DWMediator'
s.authors = { 'codeWicky' => 'codewicky@163.com' }
s.source = { :git => 'https://github.com/CodeWicky/DWMediator.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = 'DWMediator/**/*.{h,m}'
s.frameworks = 'UIKit'

end
