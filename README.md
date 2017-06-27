###小黑鱼iOS换肤功能使用说明

####基本原理：

针对需要配置换肤的UI控件，使用UIView的Category和关联对象为每一个UIView对象添加1个style属性。添加style属性的同时，注册1个通知，在style改变时触发更新UI的方法，根据sytle.plist文件中的配置设置新的UI。

####可配置属性与皮肤包结构
1. 可进行配置的控件属性（可扩展）

	- 字体大小
	
	 		textFontSize
	 		
	- 字体颜色(按钮控件另外支持按下、不可点击2种状态字体颜色)
			
			textColor、textColorPress、textColorDisable
			
	- 背景色
	
			backgroundColor
	- 图片
	
			backgroundImage
	

2. 皮肤包是以.skin为后缀的zip包，存放样式文件和资源文件，具体结构如下：

		xxx.skin
		  |--style.plist
		  |--Resource
			   |--xxx.png
			   |--xxx.jpeg
			   |--xxx.png

3. plist文件示例

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>skin_navigation_title</key>
	<dict>
		<key>textFontSize</key>
		<string>18</string>
		<key>textColor</key>
		<string>FFFFFF</string>
	</dict>
	<key>skin_login_button</key>
	<dict>
		<key>textColor</key>
		<string>FFFFFF</string>
		<key>textColorPress</key>
		<string>000000</string>
		<key>textColorDisable</key>
		<string>778899</string>
	</dict>
	<key>skin_index_head_image</key>
	<dict>
		<key>backgroundImage</key>
		<string>home_head_background.png</string>
	</dict>
	<key>skin_tool_icon_scan</key>
	<dict>
		<key>textColor</key>
		<string>778899</string>
		<key>backgroundImage</key>
		<string>home_tool_icon_scan.png</string>
	</dict>
	<key>skin_menu_stage_icon</key>
	<dict>
		<key>backgroundImage</key>
		<string>skin_menu_stage_icon.png</string>
	</dict>
	<key>skin_menu_title</key>
	<dict>
		<key>textColor</key>
		<string>2F4F4F</string>
	</dict>
	<key>skin_menu_subtitle</key>
	<dict>
		<key>textColor</key>
		<string>778899</string>
	</dict>
</dict>
</plist>

```

####使用方式
1.`BFSkinManager`，该单例用来管理皮肤资源，包括皮肤包的初始化、更新、切换操作等。

- App第一次启动，解压本地皮肤资源

```
[[BFSkinManager sharedInstance] configDefaultSkin];
```

- 下载皮肤包

```
[[BFSkinManager sharedInstance] downloadSkinResource];
```

- 切换皮肤主题

```
[[BFSkinManager sharedInstance] changeToSkinWithStyleId:@"Default"];
```

2.设置控件的style

例如：

```
	UILabel *label = [UILabel new];
    label.bf_skinStyle = @"skin_demo_title";
```

设置完`bf_skinStyle`之后，会从plist文件中读取`skin_demo_title`对应的样式。
