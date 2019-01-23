

# 网页自动访问和报警


## 目标

用Powershell脚本，实现网页运行状态监控和报警

## 一、启用Powershell

因为脚本是用powershell写的，所以需要先启动系统这个功能（也可能默认就启动了，但保险起见还是写一下）。

1、在Windows系统里，在左下的搜索框里，输入“cmd”，在“最佳匹配”里，会提示“命令提示符”，鼠标右键，然后选择“以管理员身份”运行。一定要选择“以管理员身份”运行！否则权限会不够。

![cmd-as-admin](.\images\cmd-as-admin.png)

2、回到cmd命令行状态下，单独输入以下命令，每输入完一行回车一下。这是为了启动Powershell支持。

```
powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted
powershell Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

执行过程中，可能会有一些红字提示，但一般不用管。执行的效果如下。
![setpolicy](.\images\setpolicy.png)

要确认这些命令生效了，可以再执行
```
powershell Get-ExecutionPolicy -List
```

执行完后，看到下图里，最后的两行是：` Unrestricted` 就可以，不能是 `Undefined`。执行的效果：
![setpolicy-list](.\images\setpolicy-list.png)

## 二、解压和测试脚本

压缩包理论上可以放在任何目录下。但我们假定解压在c:\monitor 目录下。这个目录不存在的话，要自己创建！在C盘根目录，右键，“新建”-》“文件夹”，新文件夹命名为“monitor”。虽然这个不是强制的。但如果要放其他目录，需要修改一些配置文件，最好还是放这个目录吧。

还是在左下的搜索栏里，输入`cmd` ，回到命令行状态。然后输入：

```
cd c:\monitor
powershell Unblock-File -Path http-monitor.ps1
```

启用我们的监控脚本 http-monitor.ps1。

然后在命令行状态下，执行：

```
run.bat
```

以上命令完整执行状态见下图：

![init](.\images\init.png)

这时候就会去访问网页了。访问的网页地址写在 c:\monitor\URLList.txt 文件里。可以写多个网址，每个网址独立一行。现在只写了唯一的一个：http://www.shhk.gov.cn/shhk/

如果访问不到，会播放这个目录下的 ALARM9.WAV 警告音文件。如果不喜欢这个文件，可以自己换一个，还叫这个名字就行。

建议先正常地测试一遍。这时候应该没什么特别的事情发生，屏幕输出就是这样：

```
c:\monitor>run.bat

c:\monitor>Powershell -file ".\http-monitor.ps1"
http://www.shhk.gov.cn/shhk/
200
```

然后在 c:\monitor\URLList.txt  里，多加一行不存在的地址，把URLList.txt的内容改为这样：

```
http://www.shhk.gov.cn/shhk/
http://www222.shhk.gov.cn/shhk/
```

然后继续执行一次run.bat，得到如下的屏幕输入，**同时如果这台电脑有耳机或者外放的喇叭，应该能听到报警的声音。**
```
c:\monitor>Powershell -file ".\http-monitor.ps1"
http://www.shhk.gov.cn/shhk/
200
http://www222.shhk.gov.cn/shhk/
```
![run](.\images\run.png)

如果能听到报警的声音，说明就实现基本功能了！

**这时候就可以把URLList.txt里那个假的第二行地址去掉了！** <<这句很重要！

##三、设置定时

1、在Windows系统里，在左下的搜索框里，输入“任务计划程序”，在“最佳匹配”里，会提示“任务计划程序”，点击即可。

2、在“任务计划程序”里，点击“创建任务”，创建一个新的定时的任务。
![定时任务设置1](.\images\new_task.png)

在新的任务创建配置界面里，有3个 tab是需要配置的：【常规】、【触发器】和【操作】。

以下界面为【常规】界面，画了红框的部分是需要配置的。先给它取名为“http monitor”（虽然这个名字其实可以随便起）。然后勾选“不管用户是否登录都要运行”和“使用最高权限运行”部分。完成后，点击上面的【触发器】到下一个界面。

![定时任务设置2](.\images\new_task2.png)

在【触发器】界面，点击【新建】，就到了以下的【新建触发器】界面。这里是配置多久执行一次这个任务。画了红框的部分是需要配置的。“开始”时间那里一定要选择从"0:00:00"开始，然后就按照下图完成其他项。完成这部分后，【确定】退出。然后再点上面的【操作】到下一个界面。

![定时任务设置3](.\images\new_task3.png)

在【操作】界面，点击【新建】，以下为【新建操作】界面。在红框和蓝框的地方，要输入的内容比较长，我分别列出来：

- 红框：C:\windows\system32\WindowsPowerShell\v1.0\powershell
- 蓝框：-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File  "C:\monitor\http-monitor.ps1"

![定时任务设置4](.\images\new_task5.png)

然后点击【确定】。这时候可能会让输入当前用户的密码，按提示输入即可。

##四、测试定时

这个时候，如果一切正常的话，就已经结束了，完整整个过程了！以下只是用于验证和调试。

这时候，在【任务计划程序库】的定时任务列表里，就应该有一条名为“http monitor”的定时任务了。

![验证定时任务](.\images\new_task6.png)

它的状态应该是【准备就绪】，需要关注的是【下次运行时间】和【上次运行结果】。上次运行结果里，正常的应该是“操作成功完成”。这样才是真的访问过指定页面。

如果不想等到【下次运行时间】，就知道它的执行结果，可以点击这条定时任务，右键->运行，就可以立刻看到执行的结果。如果不是“操作成功完成”，需要把这时的“运行结果”告知我，13916853095，朱筱丹。

![验证定时任务](.\images\new_task7.png)