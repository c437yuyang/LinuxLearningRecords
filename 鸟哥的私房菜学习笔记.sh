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



#第11章
type ll # 查看ll这个命令是外部命令还是内置bash命令，如:ll is aliased to `ls -alF'
# -a 查看所有的路径，包括alias
# \回车键，可以让过长的命令换行
echo $variable 
echo $PATH #环境变量通常用大写表示
echo ${PATH}
# 双引号内的$是具有功能性的$
# 引用变量通常:${PATH}或者"$PATH",这样能够防止有空格导致失败
# ''单引号内的$就是一般字符
# \仍然是转义字符
# 引用其他命令的结果:`命令` 或者 $(命令)
# 如:
PATH="$PATH":/home/yxp # 设置环境变量,双引号内的$PATH就是代表实际的PATH变量
unset 变量名称 # 取消变量

#一些常用的环境变量:
$HOME
$SHELL
$PATH # 可执行文件的查找路径
$LANG # 系统的语系数据
$RANDOM # 取随机数，返回0-32767

env # 查看环境变量
set # 查看所有变量(环境变量和自定义变量)
export # 直接export不跟变量 会列出所有的环境变量


read 变量名 # 等待输入，类似于cin和scanf
read -p "please enter your name:" -t 30 name # 等待输入30秒，如果没有输入，则变量被置为空
declare -i sum=100+30*2 # declare -x 生命为环境变量(export),-i 整形，-r readonly,-a arrau
declare +x sum # +号表示取消设置变量
declare -p sum # 列出变量类型

# 数组的使用
var[1]='aaa'
var[2]='bbb'
var[3]='ccc'

ulimit # 查看系统及程序的限制关系


#shell 部分:
# 变量中的删除
${variable#/*cal/bin} # 删除符合#号后跟的字符串中最短的匹配字符,从前面开始寻找
${variable##/*cal/bin} # 删除符合##号后跟的字符串中最长的匹配字符
${variable%/*cal/bin} # 删除符合%号后跟的字符串中最短的匹配字符，从后面开始寻找进行替换，%%类似

#比如:去掉路径得到文件名:
${variable##/*/} #如果本来是/home/yxp/temp.txt 得到temp.txt
#得到路径:
${variable%/*} #得到/home/yxp

# 变量中的替换:
${variable/old/new} # 将变量中的第一个old替换成new
${variable//old/new} # 将变量中的所有old替换成new

#变量的测试与内容替换
var1=${var-root} # 如果var未设置则把var1设置为root
var1=${var:-root} #如果var未设置或者为空都把var1设置为root

alias  # 后面什么都不跟，查看当前有哪些别名
alias lm='ls -l | more' #设置别名
unalias lm # 取消别名

history n # 查看n条历史记录
history -w # 将当前history记忆内容写入histfiles中
!number # 执行之前执行过的第几条命令


# 命令执行的路径与命令查找顺序:
# 1.绝对路径 2.alias 3.bash内置的builtin命令 4.%{PATH}

# 因为通常的配置文件都是login_shell在登录的时候读取的配置文件，所以自己改了配置文件后，需要注销再登录，但是用source命令也可以实现
source 配置文件名 # 读取配置文件
. 配置文件名 # 同上

# non-login shell只会读取~/.bashrc


stty -a #查看终端支持的所有的按键
set -u # 设置后若使用未设置的变量会报错
set -x # 执行命令前会有+符号
echo $- # 查看当前bash的设置，默认是himBH

#输入输出重定向部分
# 0 1 2 分别代表标准输入，输出，错误输出 >表示覆盖，>>表示追加
ll ~ >> list_right 2>> list_error # 只存在>的时候默认是1就是标准输出
ll ~/Desktop/linuxlearningrecords/ >>list_right_and_error 2>&1 # 将两个输出都追加到指定文件

# 命令执行的依据部分
# && 和 || 就和C语言里面一样
# 手动判断命令执行正确? 用$?==0 来判断，等于0表示正确，否则错误


# 选取命令:
echo ${PATH} | cut -d ":" -f 3 # 选取输出里面按照":"分割的第3个，-f是必须的
echo ${PATH} | cut -d ":" -f 3,5 # 第三个和第五个一起取，但是会添加:分隔符
echo ${PATH} | cut -c 12-20 # 显示第12到20列的字符，1-  表示1后面的所有,1 表示只显示第1行
cut -d ' ' -f 1 # 如果想按照空格进行拆分，指定了一个就必须是一个空格

