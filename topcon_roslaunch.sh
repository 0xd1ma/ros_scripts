#! /bin/bash
clear

MY_PATH=$(readlink -f $(dirname $0))

echo "TOPCON setup"

stty -F /dev/ttyUSB0 115200
sleep 0.1

echo -en "%%set,/par/pos/dion/mode,smooth\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/pos/dion/extrap,300\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/pos/dion/insextrap,on\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/pos/minsnr,30\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%PDOP%set,/par/pos/pdop,6.0\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,pos/dion/satnum,6\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%aims%set,lock/aims,3\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/dev/ser/d/imode,echo\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/dev/ser/d/echo,/dev/vp/f\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/dev/ser/d/rate,38400\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/ahrs,{15,2.0}\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/ahrs,{16,400.0}\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/odom/use,on\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%SCALE%print,/par/mc/tp/kf/odom/scale\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%spoffs%set,/par/mc/tp/kf/spoffs,{0.85,0.00,-1.35}\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/odom/offs,{0,0,0}\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/mc/tp/save,on\r" > /dev/ttyUSB0
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/reset,on\r" > /dev/ttyUSB0
sleep 0.05

echo -en "em,,nmea/GGA:0.1\r" > /dev/ttyUSB0
sleep 0.05

echo "TOPCON is started"
roslaunch ./nmea_navsat.launch


