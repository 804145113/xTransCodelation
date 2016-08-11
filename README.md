#XCODE中英文翻译插件
#Xcode版本  更新支持至XCODE 7.3(GM)
#感谢zhiyuzhao的request，优化建议
#安装方法
此插件已添加至 alcatraz-packages 插件管理器，搜索xTrans即可搜索到，没有的话，请点击Package Manager 页面右上角 设置 - Reloads Packages 重新载入最新包即可，或者手动下载整个项目运行也可以。

#更新说明
#3.0 优化UI布局
此版本舍弃2.0版的百度网页翻译模式，鉴于考虑采用SDK翻译模式，由于返回数据是JSON字符，按照目前排版来看，进步空间不是很大，而且感觉
和网页端翻译相比，少了许多东西。故采取有道网页版翻译接口，利用返回来的HTML代码，进行去顶部广告以及搜索框，进行优化排版。此排版既
美观，同时也去掉了网页端多余的内容，目前想到的较好的方式。故不再优化SDK的翻译模式，但为了平衡，SDK翻译模式的功能留着的，并没有删除。
优化后的具体排版效果看下面的GIF动画！图片有点大，可能需要多等一会才能完全加载。

#2.0  添加到 alcatraz-packages
由于百度SDK API查询方式 返回只有单一的简单翻译，后发现有道也提供免费SDK API查询方式，也是每小时 1000次免费请求，大家可以自己去有道官网申请key，在Xcode的插件配置界面配置下就可以使用，具体方法可以查看下面gif演示动画。当然如果，用网页翻译模式，
就无需申请。本次，也更新了用户配置界面，看起来更简洁明了。  
  
此插件已添加至 alcatraz-packages 插件管理器，搜索xTrans即可搜索到，没有的话，请点击Package Manager 页面右上角 设置 - Reloads Packages 重新载入最新包即可。  
  
#1.0  
XCODE中英文翻译插件，提供API查询模式和网页模式，都是利用的百度翻译。另外集成了一个可以一键关闭其他所有APP的实用功能，方便开发者

# 演示动画 #
![演示](https://github.com/AsTryE/Images/blob/master/Resoures/xTransCodelation2.gif)

The MIT License (MIT)
