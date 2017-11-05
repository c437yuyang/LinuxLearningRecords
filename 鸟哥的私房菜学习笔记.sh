#第五章:
date # 查看时间
date +%Y/%m/%d # 2017/10/11
date +%H:%M # 11:43

cal # 查看日历
cal 2009 # 查看09年日历
cal 10 2009 #查看09年10月日历

bc # 使用计算器 scale=3 设置小数点位数为3位 quit离开

ctrl + d # 等价于exit  代表end of file(EOF)或者 end of input(EOI)

shutdown -h now # -h 立刻关机
shutdown -h 20:25
shutdown -h  +10 # 10分钟后
shutdown -c # 取消之前设置的shutdown命令
shutdown -k now "System will be shutdown now" # 发出警告信件


# 第六章:
# 目录的执行权限是代表用户能够进入该目录并使该目录成为工作目录


# 第7章:
basename /home/yxp/test.txt # 获取文件名或者最后一层的目录名
dirname /home/yxp/test.tex # 获取目录名,取到的目录都是带前不带后

od -t c /home/yxp/.bashrc # 用指定方式显示文件内容，-t 后接文件类型描述符
c 是用ascii字符显示,x是用16进制显示

touch 可以修改文件时间，-a 修改访问时间,-m 修改 mtime

创建文件本身默认是666的权限，目录是777，
但是因为有umask(022),所以创建文件默认是644,目录默认是755

chattr # 修改文件隐藏属性
sudo chattr +i temp.txt # temp.txt这个文件不能被删除，改名，设置链接
sudo chattr +a temp.txt # 只能增加数据，不能删除和修改
lsattr # 可以查看文件的隐藏属性

file # 查看文件的基本数据类型

which [-a] command # 查找执行文件,-a将查询到的所有的列出，默认值列出第一个

# 通常不用find，太慢，用whereis  locate,是通过查询数据库
whereis ifconfig  # -b只查找二进制文件，-s 之查找source文件
locate passwd # -i 忽略大小写,-r 可以跟正则表达式,后面的文件名只需要是部分名称即可。

#第8章
# 文件名实际上是记录在所在目录的block里面的，因此新增、重命名、删除操作需要目录的w权限
ll -i #查看文件对应inode号码
sync #将内存中的属性为Dirty的数据同步到磁盘，正常关机时也会调用sync命令


df # 列出指定目录文件系统的整体磁盘使用量 -m 用MB的方式显示,-h用较为人性化的方式显示
du # 评估当前目录文件系统的磁盘使用量，参数类似df，常用 du -sh # 查看指定目录大小，-a 还列出文件的大小

ln /etc/crontab /root  # 创建硬链接，之后/root/crontab和/etc/crontab 就是指向的同一个文件，但是在两个目录下都有对应的文件，只是指向的inode是同一个
ll -i /etc/crontab /root/crontab # 可以看到链接数是2，指向的inode是同一个
# 硬链接的好处:删除其中任何一个文件名，其实inode和block都是还在的，只要还有其他硬链接存在，则都可以再编辑,但是硬链接不能跨文件系统，以及不能链接到目录
ln -s #创建软连接，就和windows里面的快捷方式一模一样，但是快捷方式本身是创建了新文件的，因此是有大小的，就是文件名的长度
#链接数这个东西，每次信件一个目录，会有. .. ，因此因目录的链接数都是2


df / # 可以查看到设备名称
fdisk /dev/sda # 对这个硬件设备使用fdisk,不能是/dev/sda1


#第九章
dump -S . #查看备份当前目录所需要的大小
dump -0u -f /home/yxp/backupdir # 将当前目录备份到指定目录，级别用0
restore -t -f 备份文件 # 回复dump备份的文件




