@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Mon Feb 24 16:31:21 -0300 2025
REM SW Build 2902540 on Wed May 27 19:54:49 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto c7c0ed8bc4024cddbea7778843b83cfe --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot comparator_tb_behav xil_defaultlib.comparator_tb -log elaborate.log"
call xelab  -wto c7c0ed8bc4024cddbea7778843b83cfe --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot comparator_tb_behav xil_defaultlib.comparator_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
