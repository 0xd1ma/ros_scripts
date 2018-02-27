#! /bin/bash

filename=starline
if [ "$1" != "" ]; then
    filename=$1
fi
echo "Filename for logging is $filename"

echo "Launching roscore..."
roscore &
pid=$!

sleep 3s

TOPCON_NAME="/dev/topcon"
stty -F $TOPCON_NAME 115200

sleep 0.1

echo "AGI-4 params init"
echo -en "%%set,/par/pos/dion/mode,smooth\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/pos/dion/extrap,300\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/pos/dion/insextrap,on\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/pos/minsnr,30\r" > $TOPCON_NAME
sleep 0.05
echo -en "%PDOP%set,/par/pos/pdop,6.0\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,pos/dion/satnum,6\r" > $TOPCON_NAME
sleep 0.05
echo -en "%aims%set,lock/aims,3\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/dev/ser/d/imode,echo\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/dev/ser/d/echo,/dev/vp/f\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/dev/ser/d/rate,38400\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/ahrs,{15,2.0}\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/ahrs,{16,400.0}\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/odom/use,on\r" > $TOPCON_NAME
sleep 0.05
echo -en "%SCALE%print,/par/mc/tp/kf/odom/scale\r" > $TOPCON_NAME
sleep 0.05
echo -en "%spoffs%set,/par/mc/tp/kf/spoffs,{0.85,0.00,-1.35}\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/odom/offs,{0,0,0}\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/mc/tp/save,on\r" > $TOPCON_NAME
sleep 0.05
echo -en "%%set,/par/mc/tp/kf/reset,on\r" > $TOPCON_NAME

sleep 3s

echo "AGI-4 logging configure"
# Disable internal logging
echo -en "%1x12%set,/par/mc/tp/log/activate,off\r" > $TOPCON_NAME
sleep 0.05
# delete any previous log
echo -en "%2%remove,$filename\r" > $TOPCON_NAME
sleep 0.05
# create the list of default messages
echo -en "%3%init,/msg/\r" > $TOPCON_NAME
sleep 0.05
# add additional messages
echo -en "%4%create,/msg/def/jps/SG\r" > $TOPCON_NAME
sleep 0.05
echo -en "%5%create,/msg/def/jps/DL\r" > $TOPCON_NAME
sleep 0.05
# create new log file
echo -en "%10%create,$filename:a\r" > $TOPCON_NAME
sleep 0.05
# default message set at 10 Hz
echo -en "%13%em,/cur/file/a,def:.1\r" > $TOPCON_NAME

sleep 0.5

# messeges
echo "Messeges from AGI-4"
echo "GGA 10Hz"
echo -en "em,,nmea/GGA:0.1\r" > $TOPCON_NAME
sleep 0.05

echo "TOPCON is started"

sleep 3s

echo "Launching nmea navsat node..."
sleep 0.5
roslaunch ./nmea_navsat.launch &
pid="$pid $!"

function ctrl_c() {
echo "Killing all processes!"
kill -15 $pid
sleep 3s
echo "stop recording file"
stty -F $TOPCON_NAME 115200
echo -en "%2%dm,/cur/file/a" > $TOPCON_NAME
sleep 0.5
exit
}

# trap ctrl-c and call ctrl_c()
trap ctrl_c SIGINT SIGTERM

sleep 24h
