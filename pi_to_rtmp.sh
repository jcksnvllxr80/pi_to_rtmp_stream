#!/bin/bash 
# raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://a.rtmp.youtube.com/live2/kv9b-4axc-8vdv-kjss-3j4h  # Youtube
raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv rtmp://video1.earthcam.com/myearthcam/4257=21e37a3b790bae8f336692441c15c7c4  # EarthCam
