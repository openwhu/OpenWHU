// stdafx.h : 标准系统包含文件的包含文件，
// 或是经常使用但不常更改的
// 特定于项目的包含文件
//

#pragma once

#include "targetver.h"

#include <stdio.h>
#include <tchar.h>
#include <graphics.h>
#include <conio.h>
#include <time.h>
#include <math.h>
#include "Ball.h"
#include "Dot.h"

#define GRAPH_WIDE 1300
#define GRAPH_HIGH 700

#define PLAYER_STARTX  100
#define PLAYER1_STARTY  100
#define PLAYER2_STARTY  600

#define UP 0x01
#define DOWN 0x02
#define LEFT 0x03
#define RIGHT 0x04

#define EAT 0x05
#define HIT_WALL 0x06
#define HIT_BALL 0x07
#define KEEP 0x08

#define GAME_OVER 50
#define SLEEP_TIME 30

// TODO:  在此处引用程序需要的其他头文件
