cmake_minimum_required(VERSION 3.10)
project(cppuasm CXX)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(cppuasm
        lex.yy.c
        main.cpp
        uasm.tab.c
        uasm.tab.h)
