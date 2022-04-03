ffmpeg -i 'udp://localhost:12345?fifo_size=6000000&overrun_nonfatal=1' -crf 30 -preset ultrafast -acodec aac -ar 44100 -ac 2 -b:a 96k -vcodec libx264 -r 25 -b:v 500k -f flv 'rtmp://video1.earthcam.com/myearthcam/<secret_key>'

raspivid -o localhost:12345 -t 0 -fps 30 -ih -n -b 6000000 -w 1640 -h 1232

ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i 'tcp://localhost:12345?fifo_size=1000000&overrun_nonfatal=1' 
  -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv rtmp://video1.earthcam.com/myearthcam/<secret_key> 

####################################################################################################
# working
raspivid -o 'udp://0.0.0.0:12345' -t 0 -fps 30 -ih -n -b 6000000 -w 1640 -h 1232  # stream cam to socket

ffmpeg -re -ar 44100 -ac 1 -acodec pcm_s16le -f s16le -ac 1 -i /dev/zero -f h264 -i 'udp://localhost:12345?fifo_size=6000000&overrun_nonfatal=1' -vcodec copy -acodec aac -ab 128k -g 50 -strict normal -f flv rtmp://video1.earthcam.com/myearthcam/<secret_key>  # read from socket and stream to earthcam

####################################################################################################
# testing
raspivid -o 'udp://0.0.0.0:12345' -t 0 -fps 30 -ih -n -b 6000000 -w 2028 -h 1520  # stream cam to socket

ffmpeg -i 'udp://localhost:12345?fifo_size=6000000&overrun_nonfatal=1' -crf 30 -preset ultrafast -acodec aac -ar 44100 \
-ac 2 -b:a 96k -vcodec libx264 -r 25 -b:v 500k -f flv 'rtmp://video1.earthcam.com/myearthcam/<secret_key>'
