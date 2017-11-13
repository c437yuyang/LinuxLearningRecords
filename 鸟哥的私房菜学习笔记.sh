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


#第12章

# grep命令使用部分 ，和基本的正则表达式差不多，下面有一些例子
# 这些例子都是针对行的(因为本身grep就是一个针对行的)
grep -n 'xxx' filename # -n显示行号
grep -vn 'the' regular_express.txt #-v 显示没有的行
grep -n 't[ae]st' regular_express.txt 
grep -n '[^g]oo' regular_express.txt
grep -n '[^[:lower:]]' regular_express.txt # 匹配非小写字母的
grep -n '[^[:digit:]]' regular_express.txt # 非数字的
grep -n '^the' regular_express.txt # 以the开始的
grep -n '\.$' regular_express.txt # 找以.结尾的
grep -n '^$' regular_express.txt # 找到空白行
grep -n 'ooo*' regular_express.txt # .本身的额含义还是任意一个字符，*的含义还是0次或任意次
grep -n 'o\{2,6\}' regular_express.txt  # o出现两次到6次


# sed命令的使用
nl /etc/passwd | sed '2,5d' # 删除2-5行
nl /etc/passwd | sed '2d' # 删除2行
nl /etc/passwd | sed '2,$d' # 删除2-最后一行
nl /etc/passwd | sed '2a hello' #第二行后面加上'hello',2-5行就把2换成2,5
nl /etc/passwd | sed '2,5a hello\
    world' #增加多行的数据就用\来进行换行
nl /etc/passwd | sed -n '5,7p' # 显示5到7行  或者head -n 7 | tail -n 5

ifconfig eth0 | grep 'inet addr' # 查看eth0的ip信息

# sed 的替换功能:
# 整行替换
nl /etc/passwd | sed '2,5c No 2-5 number' # 将2-5行替换为这个字符串
# 部分替换(和vim类似)
sed 's/old/new/g' # 执行替换
ifconfig eth0 | grep 'inet addr' | sed 's/^.*addr://g' # 查看eth0的ip信息并且去除前缀
ifconfig eth0 | grep 'inet addr' | sed 's/^.*addr://g' | sed 's/Bcast.*$//g' # 去除前缀后缀
cat /etc/manpath.config  | grep 'MAN' | sed 's/#.*$//g' # 只查看MAN的数据并且去掉#开始的注释

# sed 直接写入文件
sed -i '$a this is test' regular_express.txt # 直接在最后一行后面写入，-i 就是直接写入而不是输出到屏幕的意思
sed -i 's/\.$/\!/g' regular_express.txt  # 把所有带.结尾的换成! 直接写入文件


# 扩展正则表达式
# 包含 +,?,|,(),()+
egrep -vn '^$|^#' regular_express.txt # 找到不是#和空白行的

# awk
awk '条件类型1 {动作1} 条件类型2 {动作2}'
# 先读入一行，设置$0等变量，判断条件是否执行动作，执行动作，重复其余行，类似于for其实
# sed 处理一行数据,awk将一行分成数个字段来处理
last -n 5 | awk '{print $1 "\t" $3}' # 提取输出的第一列和第三列，$0代表整行
# awk的内置变量: NF 每一行拥有的总字符数 NR 目前awk处理的是第几行的数据 FS目前的分隔字符，默认是空格
last -n 5 | awk '{print $0 "\t lines:" NR "\t columns: " NF}' # 在打印的时候同时显示当前行的位置及字符数

cat /etc/passwd | awk '{FS=":"} $3 < 10 {print $1 "\t " $3}' # 将分隔符设置为:,找到第三列小于10的数据并且显示
cat /etc/passwd | awk 'BEGIN {FS=":"} $3 < 10 {print $1 "\t " $3}' # 因为是先判断条件才执行动作，所以第一行有问题，这里加上BEGIN让第一行也能正常处理



# 第13章
echo -e "hello world \n" # -e 设置后可以解析\n等转义字符

# 时间部分
date1=$(date +%Y%m%d) # 20171011这种格式
echo "$(date +%Y-%m-%d)" # 2017-10-11
date1=$(date --date='2 days ago' +%Y%m%d) # 两天后的日期


# 简单的算数运算
echo $(( 13%3 )) # 注意空格


# test的使用

# 判断字符串部分
test -z $var # 判断是否为空，空返回true
test -n $var # 。。。。。非空
# 还有== 和 !=
test str1==str2

# 判断文件相关:
# -e 存在 -f 存在且为文件 -d 存在且为目录
# -r 具有读权限 -r ... -x ...
# -nt file1 比 file2 新 
# -ot ....旧
# -ef 判断是不是同一个文件(指向同一个inode,所以硬链接和软连接都会判断成是同一个)

# 整数的判定
# -eq,-ne,-gt,-lt,-ge,-le

# 多条件
test -f a.txt -o -d dir # -o表示or,-a表示and.!表示取反

# test可以用中括号加空格替换
[ -z "$HOME" ] #等价于 test -z "$HOME"



# shell中参数
# $0代表程序名，$1第一个参数.依次类推
# $#参数个数，#@:全部参数
# shift n # 将参数左移，移出去的就丢掉


# 条件判断式
if [ 条件判断式  ];then

fi

#多个条件
if [ 条件判断式1 ] && [ 条件判断式2  ];then

else

fi

if [ 条件判断式1 ] && [ 条件判断式2  ];then

elif [ 条件判断是 ];then 
else

fi



# netstat 查看目前主机打开的网络端口服务
netstat -tuln # 查看在运行的服务

# case 语句

case $变量 in
    "第一个变量内容" )
        程序段
        ;;
    "第二个变量内容")
        ;;
    "第三个变量内容")
        ;;
    *)
        exit 1
        ;;
esac

# 函数的使用
# 参见sh12.sh

# 循环的使用
while [ condition ]
do
    程序段落
done

until [ condition ] # do while
do 

done

# for
for var in con1 con2 con3...
do

done

for (( i=0;i<=100;i=i+1 ))
do

    done

# shell 脚本的调试
sh -n # 不执行，仅仅检查语法
sh -v # 在执行之前，先把scripts的内容输出到屏幕上
sh -x # 在执行的时候打印每一步的指令

# 第14章

# /etc/passwd 文件结构
# 里面每一行数据共有7列
# 每一列分别是:账号名，密码，UID，GID，用户信息说名列，主文件夹，Shell

# /etc/shadow 文件结构
# 记录了用户密码相关内容

# /etc/group 文件结构
# 记录了GID与组名的对应
# 4列分别是:1.用户组名称2.用户组密码3.GID4.此用户组支持的账号名称

groups # 查看当前用户支持的用户组
newgrp users # 切换到新的用户组，但是必须是当前用户已经支持的用户组(在/etc/group中对应位置加上)


#/etc/gshadow # 记录了用户组密码相关的内容
# 4列分别是 用户组名 密码列 用户组管理员账号，该用户组的所属账号(就是boss?)


# 14.2账号管理
useradd username # 默认创建，会创建主文件夹并且权限为700,ubuntu不会创建,不指定用户组的话会默认创建一个相同名称的用户组
useradd -m -g groupname -u uid # -m创建家目录，-g指定组名 -u 指定uid,-r 创建为系统账号(UID默认从100后开始算，普通用户从500后开始算(ubuntu里面是1000？)),-G指定组名，-g指定gid
sudo grep testuser1 /etc/passwd /etc/shadow /etc/group # 查看创建用户后做出的修改
useradd -D # 查看添加用户时执行的默认操作

# useradd后账号默认是不能使用的，需要设置新密码才能使用
passwd testuser1  # 设置新密码
passwd #设置当前登录用户的密码

# 设置完成后可以通过usermod来进行修改
usermod -e "2009-12-31" testuser1 # 使账号失效在指定时间
usermod -c 账号说明 username
usermod -u uid username
usermod -l 新用户名 username
usermod -L 暂时冻结用户 username

userdel -r username # -r连同主文件夹一起删除，主要是删除掉/etc/passwd /etc/shadow /etc/group /etc/gshadow


# 上面的命令都是需要root权限的，finger和id也可以查看相关信息
finger [-s] username  # -s 仅列出。。。  
id username 


# 用户组相关管理操作
groupmod groupname
groupdel 
groupadd
gpasswd


# 查看用户相关信息
w
who # 都可以



# 第15章
# 磁盘阵列RAID:(RedundantArrays of Inexpensive Disks RAID)
# RAID0:两块以上磁盘，每次写入的时候，把数据等分写到每块磁盘上，这样读写性能全部会得到提升。
# 但缺点是数据损坏后，无法找回。
# RAID1:两块以上磁盘，一块磁盘当做备份盘，每次写入往两块磁盘写相同的数据，这样性能降低(容量相当于只有一般)
# 但是数据安全性非常好，任何一块坏了都可以从备份盘获取到相同的数据。
# RAID0+1 ：先组成RAID0 ，在组成RAID1
# RAID1+0：类似
# 这两种虽然同时具有0和1的优点，但是性能和磁盘容量还是只有一半
# RAID5: 多块磁盘(三块以上)
# 每次写入的时候，按照RAID0的方式写入，但是有一块盘用来写备份数据、每次写入是不同的盘来写备份数据
# 这样，只损失一块磁盘的容量，但是仍然能够在有一块磁盘损坏的情况下，恢复数据。
# RAID6:两块磁盘用作备份，允许出现两块磁盘损坏。


# 总的来说，RAID就是在性能与数据保全两方面上做权衡



# 第16章 例行性工作
# at now +2 minutes
# xxxxx
# ctrl+d  # 设置两分钟后执行xxx
