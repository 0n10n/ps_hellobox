# powershell_new


## 目标



## 安装和运行



## 问题

1、

.\http-monitor.ps1
```
.\http-monitor.ps1 : 无法加载文件 C:\github\powershell_new\http-monitor.ps1，因为在此系统上禁止运行脚本。有关详细信息，
请参阅 https:/go.microsoft.com/fwlink/?LinkID=135170 中的 about_Execution_Policies。
所在位置 行:1 字符: 2

.\http-monitor.ps1
~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) []，PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
~~~~~~~~~~~~~~~~~~
```

需要以管理员权限，执行以下命令
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List
```