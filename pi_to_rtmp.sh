#!/bin/bash
# raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://a.rtmp.youtube.com/live2/<youtube-secret-key>  # Youtube

# this next one is what works without also saving to file
# raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv rtmp://video1.earthcam.com/myearthcam/4257=<earthcam-secret-key>  # EarthCam

# comment when video is done being recorded
raspivid -o - -t 0 -fps 30 -b 6000000 -w 1640 -h 1232 | tee /home/pi/$(date +"%Y-%m-%dT%H-%M-%SZ")-babybirds.h264 | ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv rtmp://video1.earthcam.com/myearthcam/4257=<earthcam-secret-key>  # EarthCam