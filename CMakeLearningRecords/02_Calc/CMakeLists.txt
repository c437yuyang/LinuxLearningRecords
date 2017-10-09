project(hello)

cmake_minimum_required(VERSION 2.8)

aux_source_directory(./src DIR_SRCS)

add_executable(calc.bin ${DIR_SRCS} main.c)

add_dependencies()

## 不会，还没写完，是错误的现在20171009
