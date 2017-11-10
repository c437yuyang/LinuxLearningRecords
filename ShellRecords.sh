#!/bin/bash
mkdir -p #递归创建多级目录


touch xx #文件存在的话会更新文件时间


rm -i  # 删除的时候提示

cp -i  # 若文件存在，覆盖之前提示
cp -r  # 递归复制目录

head -n 10 file # 显示文件头10行
tail -n 10 file # 类似
head file  # 默认10行

chmod u +rw a.txt  # u表示user,g表示group,o表示other,a表示all,默认是a
                    # +rw是增加权限,还有-和=，后面跟数字的方法也可以

chmod 777 b.txt  # 另一种用法


chown new_user c.txt

find dir -name "*1.txt"  #搜索指定目录指定文件  默认是会递归搜索子目录的这里面*1表示1之前必须要有个字符
find . -type f #查找指定类型，f是文件,d是目录
find . -size +10M #+大于10M，可以k -10M就是小于 10k就是等于
find . -mindepth -maxdepth  # 指定最大递归深度


grep -r "helloworld" ~/ -n  #查找家目录下带有helloworld字符串的文件并显示行号,但是不会查找文件名有这个的

kill pid #发信号给某个进程
kiil -l  #查看系统有哪些信号，9号信号就是sigkill 就是杀死，所以kill -9 就是杀死某个进程
kill -9 pid  #杀死指定pid的进程 -9表示强制杀死

# 打包文件
tar -cvf 打包文件.tar 被打包的文件／路径...  #并没有压缩文件,只是打包，压缩需要加z
tar -cvf a1.tar a1/ #打包目录
tar -cvf a1.tar 121.txt 122.txt  #多个文件用文件名分开，可以用通配符
# 解包文件
tar -xvf 打包文件.tar  # 必须进到压缩包所在目录


# gzip压缩文件
tar -zcvf 打包文件.tar.gz 被压缩的文件／路径...
# 解压缩文件
tar -zxvf 打包文件.tar.gz
# 解压缩到指定路径
tar -zxvf 打包文件.tar.gz -C 目标路径

# bzip2压缩
tar -jcvf 打包文件.tar.bz2 被压缩的文件／路径...

# 解压缩文件
tar -jxvf 打包文件.tar.bz2


dpkg -L xxxx #查看软件安装位置
sudo dpkg -i xxx.deb #安装指定安装包的程序
sudo dpkg -r xxx  # 卸载指定名称的软件



#vim部分
	#○ 替换
	#   § 替换光标所在行的字符串:
	#       □ :s/old/new/gc
	#			® g:   替换当前行所有的old
	#			® c：替换的时候添加提示信息
	#		§ 替换一个范围
	#			□ :x,ys/old/new/gc 
	#				® xy是一个范围（行数）
	#		§ 替换当前文档所有的
	#			□ :%s/old/new/gc


#gcc部分
#gcc编译C语言程序
gcc a.c b.c ./src/*.c -c  #得到对应的.o文件
gcc hello.c  -I./myHeads -D DEBUG -o hello  #-I添加包含目录，-D添加宏 -o指定输出文件 -g 保留调试信息，gdb会用到
#g++编译cpp程序
g++ -std=c++11 helloworld.cpp -o helloworld.bin

-Wall 显示warning信息
-On 优化代码，n可以取123，代表优化级别

#静态库的制作
gcc a.c b.c -c #1.得到a.o ,b.o
ar rcs libTest.a a.o b.o #2.得到静态库.a文件,库的文件名必须叫做libXXX.a，XXX是你想取的名字

# 编译使用静态库的程序
# 假设包含的头文件在./include 目录，包含的静态库文件在 ./lib 名字叫做libCalc.a
gcc main.c -I ./include/ -L ./lib/ -l Calc -o calc.bin 

# 动态库的制作
gcc *.c -c -fpic -I ../include/ #比静态库多fpic
gcc -shared *.o -o libCalcDll.so #生成的动态库的名字还是必须是libXXX.so

#生成的动态库静态库可以自己重命名都行，只要确保最后环境变量找得到即可

# 动态库的使用,和静态库基本一模一样
gcc main.c -I ./include -L ./lib/ -lCalcDll -o app

ldd 可执行文件名  #查看可执行程序需要用到哪些动态库
#对于可执行程序，首先搜索程序自身elf文件的DT_RPATH段，但是这个段不好修改
#然后搜索环境变量 LD_LIBRARY_PATH 以及 /etc/ld.so.cache 文件列表
#然后搜索/lib/ 和 /usr/lib,所以最简单的就是自己写的so文件放到这里面，但是很可能会命名冲突，所以不推荐

file 文件名  #查看文件信息(elf)

env  #查看系统环境变量
echo $PATH

export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH  #临时设置环境变量，使能够找到so文件,中间是冒号

# 动态库使用和静态库一模一样(编译的命令)，但是需要能够找到动态库的位置(同目录也没用，和windows不一样这一点，必须设置了才行)
			#§ 使用环境变量
			#	□ 临时设置：
			#	终端输入:export LD_LIBRARY_PATH=动态库的路径:$LD_LIBRARY_PATH
			#	新终端就没用了
            #   □ 永久设置：在指定文件写上面的export命令
			#		® 用户级别：
			#			◊ ~/.bashrc
			#				} 配置完成：
			#					– 重启终端   或者
			#					– source ~/.bashrc
			#		® 系统级别：
			#			◊ /etc/profile
			#				} 重启系统 或者
			#				} source /etc/profile
			#§ /etc/ld.so.cache文件列表
			#	□ 找到一个配置文件
			#		® /etc/ld.so.conf
            #		® 把动态库的绝对路径(动态库所在的目录)添加到这个文件末尾
			#	□ 执行一个命令：
			#		® sudo ldconfig -v
            # 或者使用dlopen,dlclose,dlsym等函数进行动态加载，类似于windows那边的loadLibrary();


