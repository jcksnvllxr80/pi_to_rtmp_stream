#!/bin/bash
STREAM_HOST=localhost
STREAM_PORT=9090
SECRET_URL=rtmp://mia05.contribute.live-video.net/app/  # this just happens to be twitch's east coast USA server
SECRET_KEY=your_stream_service_key  # youtube, twitch, or earthcam stream key

/usr/bin/ffmpeg -i "tcp://${STREAM_HOST}:${STREAM_PORT}?fifo_size=6000000&overrun_nonfatal=1" \
-crf 30 -preset ultrafast -acodec aac -ar 44100 -ac 2 -b:a 96k -vcodec libx264 -r 25 -b:v 500k \
-f flv "${SECRET_URL}${SECRET_KEY}"
