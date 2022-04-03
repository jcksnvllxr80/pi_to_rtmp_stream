#!/bin/bash

PI_HOME=/home/pi
APP_NAME=pi_to_rtmp_stream
TIMELAPSE_DIR=$PI_HOME/$APP_NAME/timelapse
SECRETS_FILE=$PI_HOME/$APP_NAME/secrets.conf

# raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://a.rtmp.youtube.com/live2/<youtube-secret-key>  # Youtube

# this next one is what works without also saving to file // must add a secrets.conf file in the same directory as this script
. $SECRETS_FILE  # set environment variables
raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv ${SECRET_URL}${SECRET_KEY}  # EarthCam

# comment when video is done being recorded
# raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | tee /home/pi/$(date +"%Y-%m-%dT%H-%M-%SZ")-babybirds.h264 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv rtmp://video1.earthcam.com/myearthcam/<earthcam-secret-key>  # EarthCam

# use for timelapse with a nother device to connect and send the video
#$(/usr/bin/which mkdir) -p $TIMELAPSE_DIR
#/usr/bin/python $PI_HOME/$APP_NAME/stream_pi_cam.py
