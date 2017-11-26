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
shutdown -t 5 # 5秒后关机
sync # 把数据同步到磁盘

# 因为执行等级也有关机，重启这两个，因此用:
init 0 # 也可以关机,6就是重启了

# 第六章:
chgrp groupname filename # 更改指定文件名为指定用户组，用户组必须出现在/etc/group 中，否则报错
chown [-R] username filename # 更改为指定用户，用户必须出现在/etc/passwd中，-R 递归修改其子目录
chown [-R] username:groupname filename #同时修改所有者和用户组

cp src dst # cp命令会连着执行者的属性和权限一起复制
chmod [-R] username filename
chmod u=rwx,go=rx filename # 用法有:u g o a,+,-
# 目录有r权限才能ls 目录
# 目录的w权限对应涉及到修改目录里面的文件名，子目录名等相关操作
# 目录的执行权限是代表用户能够进入该目录并使该目录成为工作目录

# FHS:FileSystem Hierarchy Standard
# 最重要的几个目录:
/ # root根目录
/usr # UNIX software resource，软件安装执行有关，类似于windows的c:\windows 和c:\programfiles 的结合体
/var # variable
/etc # 配置文件目录
/dev # 所需要的设备文件
/usr/local  # 管理员自己下载安装的软件，通常建议安装到这个目录
# 几个bin目录的区分:
/bin # 存放在单用户维护模式下还能被操作的命令，cat,chmod,ls等最常用的
/sbin # 存放开机过程需要用到的 fdisk ifconfig init等
/usr/bin # 用户可以使用的命令，比如自己装的python,chrome
/usr/sbin # 某些网络服务器的软件的服务命令(daemon)



# 第7章:
# 文件目录操作相关命令:
pwd [-P] # print working directory ,-P 不使用链接
mkdir -p dirname # 递归创建目录
mkdir -m 711 test2 # 不适用umask，直接指定权限创建目录
# 涉及到修改原有文件名或目录名的时候，-i 都是询问的意思，-f 是强制执行，-u 是较新才会执行
basename /home/yxp/test.txt # 获取文件名或者最后一层的目录名
dirname /home/yxp/test.tex # 获取目录名,取到的目录都是带前不带后


#查看文件内容相关命令
tac # 从最后一行开始显示，就是cat倒着来
nl # cat -n 
tail [-n number] filename 
head -n -100 filename # 后面跟的一个负数，表示打印除了最后100行的所有
od -t c /home/yxp/.bashrc # 用指定方式显示文件内容，-t 后接文件类型描述符
c 是用ascii字符显示,x是用16进制显示

touch 可以修改文件时间，-a 修改访问时间,-m 修改 mtime

创建文件本身默认是666的权限，目录是777，
但是因为有umask(022),所以创建文件默认是644,目录默认是755
umask 022 # 指定umask为022

chattr # 修改文件隐藏属性
sudo chattr +i temp.txt # temp.txt这个文件不能被删除，改名，设置链接
sudo chattr +a temp.txt # 只能增加数据，不能删除和修改
lsattr # 可以查看文件的隐藏属性

file # 查看文件的基本数据类型

which [-a] command # 查找执行文件,-a将查询到的所有的列出，默认值列出第一个

# 通常不用find，太慢，用whereis  locate,是通过查询数据库
whereis ifconfig  # -b只查找二进制文件，-s 之查找source文件
locate passwd # -i 忽略大小写,-r 可以跟正则表达式,后面的文件名只需要是部分名称即可。
locate "passwd" | grep ".*/passwd$" # 查找文件名为passwd的文件,单双引号都可以

find [PATH] [option] [action]
find / -name passwd # 只有locate是可以部分匹配的，其他几个搜索都是全字匹配

#第8章
# 文件名实际上是记录在所在目录的block里面的，因此新增、重命名、删除操作需要目录的w权限
ll -i #查看文件对应inode号码
sync #将内存中的属性为Dirty的数据同步到磁盘，正常关机时也会调用sync命令

ls -l /lib/modules/$(uname -r)/kernel/fs # 查看当前系统支持的文件系统格式
cat /proc/filesystems # 查看当前已经加载到内存的文件系统

df # 列出指定目录文件系统的整体磁盘使用量 -m 用MB的方式显示,-h用较为人性化的方式显示
du # 评估当前目录文件系统的磁盘使用量，参数类似df，常用 du -sh # 查看指定目录大小，-a 还列出文件的大小

ln /etc/crontab /root  # 创建硬链接，之后/root/crontab和/etc/crontab 就是指向的同一个文件，但是在两个目录下都有对应的文件，只是指向的inode是同一个
ll -i /etc/crontab /root/crontab # 可以看到链接数是2，指向的inode是同一个
# 硬链接的好处:删除其中任何一个文件名，其实inode和block都是还在的，只要还有其他硬链接存在，则都可以再编辑,但是硬链接不能跨文件系统，以及不能链接到目录
ln -s #创建软连接，就和windows里面的快捷方式一模一样，但是快捷方式本身是创建了新文件的，因此是有大小的，就是文件名的长度
#链接数这个东西，每次信件一个目录，会有. .. ，因此因目录的链接数都是2


df / # 可以查看到设备名称
fdisk /dev/sda # 对这个硬件设备使用fdisk,不能是/dev/sda1

dd if=/dev/zero of=/home/yxp/test_big_file bs=1M count=512 # 创建一个空白大文件
# if 是输入设备 /dev/zero 是一个一直输出0的设备 of是输出文件 bs是block_size,count是输出的bs个数

dumpe2fs /dev/sda #查看硬盘的相关信息(blocksize等等)

ll -s # 查看的时候第一列显示占用block的数目(4为一个)，8的话就占用了两个
sudo du -sb /etc # 查看实际占用的大小
sudo du -sm /etc # 查看本来应该占用的大小

#第九章
#-c　新建打包文件，－v显示过程中的文件名,-f后面跟文件名
#-x 解压文件　配合-C 解压在特定路径
#-j 通过bzip2的方式进行压缩解压缩，文件名最好是.tar.bz2
#-z 通过gzip的方式进行。。。　.tar.gz
#--exclude 忽略指定文件名
# 打包文件
tar -cvf 打包文件.tar 被打包的文件或路径...  #并没有压缩文件,只是打包，压缩需要加z
tar -cvf a1.tar a1/ #打包目录
tar -cvf a1.tar 121.txt 122.txt  #多个文件用文件名分开，可以用通配符
# 解包文件
tar -xvf 打包文件.tar  # 必须进到压缩包所在目录
# gzip压缩文件
tar -zcvf 打包文件.tar.gz 被压缩的文件或路径...
# 解压缩文件
tar -zxvf 打包文件.tar.gz
# 解压缩到指定路径
tar -zxvf 打包文件.tar.gz -C 目标路径
# bzip2压缩
tar -jcvf 打包文件.tar.bz2 被压缩的文件或路径...
# 解压缩文件
tar -jxvf 打包文件.tar.bz2


#备份部分
# 目录备份只支持level0,不支持-u参数(将此次备份记录到/etc/dumpates文件中)
# -f 接filename,-j 加入bzip2进行压缩
dump -S . #查看备份当前目录所需要的大小
dump -0u -f /home/yxp/backupdir # 将当前目录备份到指定目录，级别用0
restore -t -f 备份文件 # 回复dump备份的文件
dump -W # 查看是否存在备份

#dd 用于备份
dd if=/etc/passwd of=~/back_up/passwd.bak # 备份指定文件，默认512bytes 一个bs,其实这样使用就是cp命令了
dd if=/dev/hdc of=~/back_up/mbr.bak # 备份自己的第一个扇区
# 还原的时候交换if和of即可。

# 第10章:VIM
# hjkl 左下上右，配合n使用可以个方向的移动指定步数
# nG 移动到第n行
# H M L 分别是移动到当前页的首、中、尾
# n[SPACE] 移动到第n列
# ctrl+d 向下移动半屏 ctrl+u向上移动半屏
# ctrl+f 查看当前文件目录,可能是配置了vimplus的原因，默认的应该是向下翻一页
# ctrl+b 向前翻一页

# :n1,n2s/word1/word2/g # 在n1到n2之间寻找word1并且替换成word2
# :1,$s/word1/word2/g # 在第一行到最后一行。。。
# :1,$s/word1/word2/gc # 替换前询问

#第11章

/etc/shells # 查看系统可用的合法的shell
/etc/passwd # 最后一列记录了用户登录时获得的shell
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

echo $$  # 查看目前这个shell使用的PID
echo $? # 查看上一个命令的回传码

# 子进程只会继承父进程的环境变量，子进程不会继承父进程的自定义变量
# 因此如果想要子进程继承自己定义的变量，则需要使用export

locale # 查看系统语系相关的变量
locale -a # 查看系统支持的语系

read 变量名 # 等待输入，类似于cin和scanf
read -p "please enter your name:" -t 30 name # 等待输入30秒，如果没有输入，则变量被置为空
declare -i sum=100+30*2 # declare -x 生命为环境变量(export),-i 整形，-r readonly,-a array
declare +x sum # +号表示取消设置变量
declare -p sum # 列出变量类型
delcare -r sum # 声明为readonly的变量，如果对其进行赋值会报错
# typeset 和 declare 是一模一样的功能
# 数组的使用
var[1]='aaa'
var[2]='bbb'
var[3]='ccc'
echo "${var[1]},${var[2]},${var[3]}"

ulimit # 查看系统及程序的限制关系
ulimit -f # 查看当前系统文件size限制
ulimit -f 10240 # 限制用户仅能建立10MB以下的容量的文件
# 这时再来创建大文件就会报错

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
alias lm='ls -l | more' #设置别名,注意有两个'',""也是可以的，其实就是只要是字符串即可
unalias lm # 取消别名

history n # 查看n条历史记录
history -w # 将当前history记忆内容写入histfiles中
!number # 执行之前执行过的第几条命令
!! # 执行上一条指令
!al # 执行上一条以al开头的指令

# 命令执行的路径与命令查找顺序:
# 1.绝对路径 2.alias 3.bash内置的builtin命令 4.%{PATH}
# 所以当执行ls的时候，是优先执行的alias ls='ls --color=auto',如果去直接执行/bin/ls的话就没有颜色信息了出来


# 因为通常的配置文件都是login_shell在登录的时候读取的配置文件，所以自己改了配置文件后，需要注销再登录
# 但是用source命令也可以实现
source 配置文件名 # 读取配置文件
. 配置文件名 # 同上

# login shell 会读取两个配置文件:
# /etc/profile # 系统整体的配置，最好不要修改
# ~/.bashrc 或者 ~/.bash_login 或者 ~/.profile:属于用户的个人设置，你要修改自己的数据，就写入这里
# non-login shell只会读取~/.bashrc

# 默认系统可用的终端有tty 1-7 
# tty7 是图形界面

stty -a #查看终端支持的所有的按键

ctrl+j #等于回车
ctrl+h #等于backspace
ctrl+s #暂停当前屏幕输出
ctrl+q #回复屏幕输出
ctrl+d #输入exit eof
ctrl+m #输入回车
ctrl+? #清除输入

# bash支持的通配符
*0个或任意多个任意字符、? 一定有一个任意字符、[]、[0-9]、[^] #非

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
# $$代表 当前进程的ID号
# $?代表 当前进程执行后成功还是失败

# 选取命令（对一段数据进行分析，取出我们想要的）:
echo ${PATH} | cut -d ":" -f 3 # 选取输出里面按照":"分割的第3个，-f是必须的
echo ${PATH} | cut -d ":" -f 3,5 # 第三个和第五个一起取，但是会添加:分隔符
echo ${PATH} | cut -c 12-20 # 显示第12到20列的字符，1-  表示1后面的所有,1 表示只显示第1行
cut -d ' ' -f 1 # 如果想按照空格进行拆分，指定了一个就必须是一个空格
export | cut -c 12- # 取出第12列到最后(从1开始数)的数据

# cut是针对每一行信息做提取，取出自己想要的，grep是针对所有行中找出符合条件的行
last | grep 'root' | cut -d ' ' -f1 # 找到含有root的行并且只取第一列

# sort , -f 忽略大小写,-b忽略开始的空格，-r反向排序,-t指定分割符，-k指定排序区间
cat /etc/passwd | sort # 将输出的行按照字典序进行排序
cat /etc/passwd | sort -t ':' -k 3 # 将输出按照:进行分割，按分割后的第三列进行排序
last | cut -d ' ' -f1 | sort # 取输出的第一列并且排序

#uniq 去除重复 -i 忽略大小写，-c 显示计数
last | cut -d ' ' -f1 | sort | uniq -c # 取输出第一列排序然后去除重复,并且显示计数
last | cut -d ' ' -f1 |sort | uniq -c | sort  -r  # 统计登录次数最多的用户

#wc 统计文本的信息
cat /etc/passwd | wc # 输出行数、字数、字符数, -l w m 分别对应只显示三个中的一个

#tee 会同时将数据送到文件和屏幕
tee [-a] file # -a 以累加方式
last | tee last.list # 同时到文件和屏幕
ls -l /home | tee ~/homefile | less # 同时到文件和less

# 字符转换命令
# tr 删除一段信息中的文字或是进行文字信息的转换
last | tr '[a-z]' 'A-Z' # 进行大小写转换
cat /etc/passwd | tr -d ':' # 删除信息中的:

#col 用于替换字符串
col [-xb] # -x 将tab转换成对等的空格键

#join 用于将两个文件中有相同数据的那一行加在一起
join -t ':' /etc/passwd /etc/shadow #以:作为分隔符，对比第一个字段的数据，然后进行合并

#paste 简单的将两个文件的两行合并在一起，用tab分开
paste /etc/passwd /etc/shadow #-d 指定分隔符，默认是tab
cat /etc/group|paste /etc/passwd /etc/shadow -|head -n 3 # - 指定从标准输出读取数据，这里就是把cat的输出作为输入，最后三个文件粘贴在了一起，取出前三行

#expand用于将tab转换成空格键
expand [-t] file # -t 6 就是把tab替换成6个空格

#split 切割大文件
split -b 300k filename prefix # 将文件切割成300k为单位的小文件，用prefix作为前缀
# 合并:
cat prefix* >> filename # 就用cat就可以

split -l # 用行数进行分割
ls -al / | split -l 10 - prefix # 将结果以每10行进行分割，这里的第三个- 代表stdin
wc -l prefix* # 查看每个文件的行数

#xargs 参数代换
cut -d ':' -f1 /etc/passwd | head -n 3 | xargs finger # 取出文件的第一列的前三行(就是三个用户名)，作为finger的输入
# -p 执行每个指令之前都会询问用户
# -n 每次执行的时候，跟几个参数，-n 5的话，finger命令就一次查询5个人
# -e 后跟字符串，每次分析到指定字符串的时候就认为是EOF结束。

#第12章
grep [-A数字] [-B数字] '搜索字符串' filename # -A后面跟数字表示当前行后面的多少行也列出来，-B是之前多少行
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
grep -n 'ooo*' regular_express.txt # .本身的含义还是任意一个字符，*的含义还是0次或任意次
grep -n 'o\{2,6\}' regular_express.txt  # o出现两次到6次
grep -n 'g..d' regular_express.txt # .表示任意字符

# sed命令的使用(sed 是管道命令，可以将数据进行替换、删除、新增、选取特定行等功能)
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

# sed 选取特定行
nl /etc/passwd | sed -n '5,7p' #仅查看5到7行

# 扩展正则表达式
# 包含 +,?,|,(),()+
egrep -vn '^$|^#' regular_express.txt # 找到不是#和空白行的

# awk (sed是将数据一整行一起处理，awk是将一行分为数个字段进行处理)
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

# test可以用中括号加空格替换(注意空格不能少)
[ -z "$HOME" ] #等价于 test -z "$HOME"

# shell中参数
# $0代表程序名，$1第一个参数.依次类推
# $#参数个数，#@:全部参数
# shift n # 将参数左移，移出去的就丢掉
# $? 代表上次指令执行的结果是否错误
# bash里面判断相等用一个和两个等号是一样的，但是建议还是用两个，保持程序书写习惯

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
for var in con1 con2 con3... # 写在for后面的注释，一定要先有一个空格，不然会出问题
do

done

for (( i=0;i<=100;i=i+1 ))
do

done

# shell 脚本的调试
sh -n # 不执行，仅仅检查语法
sh -v # 在执行之前，先把scripts的内容输出到屏幕上
sh -x # 在执行的时候打印每一步的指令


# shell 脚本需要执行的话，至少需要r权限，比如用sh sh17.sh
# 需要直接执行的话，比如./sh17.sh 就需要有x权限

# 第14章
man 5 passwd # man查看passwd，很清晰的写的，比如每一列的内容
man 5 shadow # man查看密码相关
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
useradd -D # 查看添加用户时系统会执行的默认操作有哪些

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
# RAID1:两块以上磁盘，一块磁盘当做备份盘，每次写入往两块磁盘写相同的数据，这样性能降低(容量相当于只有一半)
# 但是数据安全性非常好，任何一块坏了都可以从备份盘获取到相同的数据。
# RAID0+1 ：先组成RAID0，在组成RAID1
# RAID1+0：类似
# 这两种虽然同时具有0和1的优点，但是性能和磁盘容量还是只有一半
# RAID5: 多块磁盘(三块以上)
# 每次写入的时候，按照RAID0的方式写入，但是有一块盘用来写备份数据、每次写入是不同的盘来写备份数据
# 这样，只损失一块磁盘的容量，但是仍然能够在有一块磁盘损坏的情况下，恢复数据。
# RAID6:两块磁盘用作备份，允许出现两块磁盘损坏。

# 总的来说，RAID就是在性能与数据保全两方面上做权衡

# 第16章 例行性工作
at now +2 minutes
xxxxx
xxxxx  # 可以直接执行多个命令
ctrl+d  # 设置两分钟后执行xxx

atq # 查看当前有哪些工作调度
atrm n # 删除第n个工作调度

batch 23:00 2017-11-13 # 在指定时间
sync
sync
shutdown -r now 
ctrl+d 
# batch和at的用法一样，但是会选择在CPU负载低于0.8的时候才执行

#crontab的使用
# crontab是循环执行，at是一次执行
# /etc/cron.allow和deny 记录允许和不允许执行的用户
# /etc/crontab # 记录系统所有的
# 这个命令其实就是编辑/etc/crontab 文件，然后系统每分钟会读取一次这个文件

crontab -e # 启动vim编辑
* * * * * sh xxx.sh # 每分钟执行一次指定脚本文件,分别是minute,hour,day,month,week


# 第17章  程序管理
top [-d 数字] # 刷新的秒数
top [-n] # 与-d配合，输出的次数
top -b -n 2 #输出两次
top -p # 指定某个PID检测

pstree  # 查看进程树

#系统资源的查看
free # 查看内存使用情况 -m 用MB的方式显示，默认字节

uname # 查看系统与内核相关的信息 -a 所有信息
uname -r # 查看内核版本
uptime # 查看系统启动时间与工作负载

netstat # 跟踪网络 -a 列出所有连接、监听、Socket数据 -t 列出tcp网络数据包的数据 -u 列出udp..
# 输出分为两部分，第一部分是网络的连接，第二部分是系统进程的连接(进程也可以收到各种进程发来的消息)
# -n 只看网络部分，不看进程部分
# -l 列出正在进行网络监听的服务
# -p 列出 pid和所属程序名称
netstat -tnlp # 查看那些进程有网络访问

kill -9 PID # 杀死指定PID进程  man SIGNAL 查看系统的信号集

dmesg # 分析系统内核产生的信息:开机的时候一闪而过的硬件检测信息
dmesg |grep -i hd # 查看开机

vmstat 1 3 # 统计目前主机CPU状态，每秒一次，一共三次

fuser -uv . #查看当前面目录在被那些进程使用,文件也可以，但是自己试了不行
fuser -ki ./ShellRecords.sh # 试图删除这个文件，看有没有人再用
lsof # 列出当前系统被打开的所有文件名和设备
lsof -u root -a -U # -u 指定用户,-U 指定类型为socket类型，-a 表示and，连接两个条件
lsof -u root | grep bash # 查看root打开的所有bash相关的文件

# 第18章 系统服务
# daemon和service的关系: daemon是用来启动service的程序
# 服务有:stand_alone 一直在后台运行，响应速度块
# super daemon 需要使用的时候才唤醒，响应速度慢
# stand alone的通常用来做单一服务的窗口
# super daemon 通常用来做多功能的窗口，需要干什么就干什么
# daemon的命名规则: 都以d结尾


/etc/services # 查看系统服务对应的端口
/etc/init.d/× # 这个目录里面存放的是几乎所有的服务的启动脚本
/etc/sysconfig/* #各项服务的初始化环境配置文件
/etc/xinetd.conf # super daemon 的配置文件
/etc/xinetd.d/* # 同上

# 所有stand alone服务的操作方式
service [service name] (start|stop|restart...)# 对服务进行操作
service --status-all # 查看当前所有服务运行状态

# 所有super daemon服务的操作方式
# 其实所有super daemon都由xinetd进行管理，而xinetd其实就是一个stand_alone服务
grep -i 'disable' /etc/xinetd.d/* #查看当前有哪些服务，=yes就是没有启动



# 第19章:
# linux系统通过run level来规定系统使用不同的服务来启动，让linux的使用环境不同
# run level 3 : 完整含有网络功能的纯文本模式
# run level 5 : 和3类似，但是使用x window 加载
# 0 4 6 分别是关机，系统保留，重启


# 第22章:
ldconfig #这个指令其实是将/etc/ld.so.conf 里面的内容读入高速缓存，因为动态库的话在硬盘，使用起来会很慢，同时也记录在/etc/ld.so.cache 
ldd 可执行文件名 # 查看用到的动态库


# 第26章
/lib/modules/$(uname -r)/kernel # 查看内核提供的模块
