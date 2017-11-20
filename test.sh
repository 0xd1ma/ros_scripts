#! /bin/bash
clear
MY_PATH=$(readlink -f $(dirname $0))
echo "TOPCON setup"
stty -F /dev/ttyUSB0 115200
sleep 0.1
echo -en "em,,nmea/GGA:0.1\r" > /dev/ttyUSB0
sleep 0.1
echo "ROS start"
roslaunch ./nmea_navsat.launch


