Pod::Spec.new do |s|  
  s.name             = "DZMyAlertView" 
  s.version          = "1.0.0" 
  s.summary          = "提示框"  
  s.homepage         = "https://github.com/mayaosb2/DZMyAlertView"   
  s.license          = 'MIT'  
  s.author           = { "剑啸青云梦一生" => "913831110@qq.com" }  
  s.source           = { :git => "https://github.com/mayaosb2/DZMyAlertView.git", :tag => s.version.to_s }   
  s.requires_arc = true  
  s.ios.deployment_target = '8.0'
  s.source_files = 'DZMyAlertView/*.*'
  s.dependencies = {
   'JNDZTELDTOOL' => [‘1.0.0']
   }

end 