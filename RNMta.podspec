require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'RNMta'
  s.version      = package['version']
  s.summary      = package['description']
  s.description  = package['description']
  s.license      = package['license']
  s.author       = { package['author'] => 'g592842897@gmail.com' }
  s.homepage     = package['homepage']
  s.source       = { :git => package['repository']['url'], :tag => package['version'] }

  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.source_files = 'ios/**/*.{h,m}'
  s.dependency 'React'
end
