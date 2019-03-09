# PodBox
提供便捷的Podfile工具

## 步骤


##### 1. PodBox.rb放在PodFile同级目录

##### 2. 在PodFile中添加
```

platform :ios, '9.0'
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

install! 'cocoapods', :deterministic_uuids => false

# 参数
# :name, :names,
# :git, :git_format,
# :root_path, :path, :path_format,
# :branch, :tag, :version,
# :method,

# 使用说明 
# 如果有method 则使用method对应的方式请求模块
# 如果配置中数据匹配对应method失败 则使用默认规则
# method            { (必选参数), [ 可选参数 ] }
# DEFAULT           LOCAL
# LOCAL             { ( (:name || :names),), [:path, :root_path, :path_format] }
# REMOTE_GIT        { ( (:name || :names), :git), [:git_format] }
# REMOTE_VERSION    { ( (:name || :names), :git), [:version] }
# REMOTE_BRANCH     { ( (:name || :names), :git), [:branch='master'] }
# REMOTE_TAG        { ( (:name || :names), :git, :tag), [] }

# 默认规则 
# 如果配置中有git地址， 优先使用git地址， 
# 如果git地址不存在， 则根据名字判断本地模块目录(当前用户模块根目录地址+模块名字)是否存在,
# 如果本地模块根目录存在, 则LOCAL（pod 'name' :path => 'path'） 
# 如果本地模块根目录不存在 则REMOTE_VERSION（pod 'name' || pod 'name' 'version'）
# DEFAULT           LOCAL
# LOCAL             ( pod 'name' :path => 'path' )
# REMOTE_GIT        ( pod 'name' :git => 'git' :branch => 'master' )
# REMOTE_VERSION    ( pod 'name' || pod 'name' 'version')
# REMOTE_BRANCH     ( pod 'name' :git => 'git' :branch => 'branch' )
# REMOTE_TAG        ( pod 'name' :git => 'git' :tag => 'tag' )

require File.join(File.dirname(__FILE__), 'PodBox.rb')

# 配置范例
{
  :name => 'Module',
  :names => ['Module1','Module1/SubModule','Module1/SubModule', 'Module2'],
  :git => 'https://github.com/username/project.git',
  :git_format => 'https://github.com/username/#{git_name}.git',
  :path => '/Users/username/workspace/Modules/Name',
  :root_path => '/Users/username/workspace/Modules',
  :path_format => '/Users/username/workspace/#{git_name}',
  :version => '~> 1.7.0',
  :branch => 'develop',
  :tag => '1.1.1',
  :method => LOCAL,
}

# 成员配置
#:force_local是否强制使用本地 如果是 默认使用LOCAL，否则默认使用REMOTE_GIT
member_configs = [
  { :name => :yuyang, :pathes => ['/Users/yuyang/Workspace/Modules'], :force_local => false, },
  { :name => :yuyang_fake, :pathes => ['/Users/yuyang_fake/Workspace_Fake/Modules'], :force_local => false, },
]

all_modules = [
    {
      :names => [ 
        'PodBox'
      ],
      :path => '../',
    },
    {
        :names => [
          'UMCCommon',
          'UMCSecurityPlugins',
          'UMCAnalytics',
          'YYCategories',
          'UMCShare/UI',
          'JXMagicMove',
          'Bugly',
          'DZNEmptyDataSet',
          'Masonry',
          'IQKeyboardManager',
          'TYCyclePagerView',
          'YYText',
          'UMCShare/Social/ReducedWeChat',
          'UMCShare/Social/ReducedQQ',
          'UMCShare/Social/ReducedSina',
        ],
        :method => REMOTE_VERSION
    },
    { :names => ['JSONModel'], :version => '~> 1.7.0' },
    { :names => ['MJRefresh'], :version => '~> 3.1.12' },
    { :names => ['MagicalRecord'], :version => '~> 2.3.2' },
    { :names => ['HandyFrame'], :version => '~> 1.1.1' },
    { :names => ['YYModel'], :version => '~> 1.0.4' },
    { :names => ['AFWebViewController'], :version => '~> 1.0' },
    { :names => ['UITextView+Placeholder'], :version => '~> 1.2' },
    {
      :names => [
            'AFNetworking',
            'FMDB',
            'MBProgressHUD',
            'SDWebImage',
            'SDWebImage/GIF',
      ], 
      :git_format => 'https://github.com/weforkapple/#{git_name}.git',
    },
]

yuyang_modules = [
        { 
          :names => [
          'MBProgressHUD',
          'SDWebImage',
          'SDWebImage/GIF',
          ],
          :method => LOCAL 
        }
    ]

yuyang_fake_modules = [
        { 
          :names => [
          'FMDB',
          'MBProgressHUD',
          ],
          :method => LOCAL
        }
    ]

member_modules = {
    :yuyang => yuyang_modules,
    :yuyang_fake => yuyang_fake_modules,
}

target 'PodBox_Example' do
  mod = PBPodModule.new(all_modules, member_modules, member_configs)
  pod_box_module_run(mod)
end

```