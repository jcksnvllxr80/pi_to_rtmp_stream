#!/usr/bin/python

#######################
# run the python and then the ffmpeg
import socket
from io import BytesIO
import time
import picamera
from threading import Thread
import subprocess

timelapse_dir = './timelapse'


def stream_video_to_network(cam):
    server_socket = socket.socket()
    server_socket.bind(('0.0.0.0', 9090))
    server_socket.listen(0)
    while True:
        connection = server_socket.accept()[0].makefile('wb')
        cam.start_recording(connection, format='h264', resize=(1024, 768), inline_headers=True)


def stream_video_to_memory(cam):
    stream = BytesIO()
    cam.start_recording(stream, format='mjpeg', quality=23)


def do_timelapse(cam):
  while True:
    time.sleep(10)
    cam.capture('{}/{}-timelapse.jpg'.format(timelapse_dir, time.strftime("%Y%m%dT%H%M%SZ")), use_video_port=True)


camera = picamera.PiCamera()
camera.resolution = (1024, 768)
camera.framerate = 24
Thread(target=stream_video_to_network, args=(camera,)).start()
Thread(target=do_timelapse, args=(camera,)).start()

# ffmpeg -i 'tcp://localhost:9090?fifo_size=6000000&overrun_nonfatal=1' -crf 30 -preset ultrafast -acodec aac -ar 44100 -ac 2 -b:a 96k -vcodec libx264 -r 25 -b:v 500k -f flv 'rtmp://mia05.contribute.live-video.net/app/<secret_key>'
cmdline = [
  'ffmpeg',
  '-i',
  'tcp://localhost:9090?fifo_size=6000000&overrun_nonfatal=1',
  '-crf',
  '30',
  '-preset',
  'ultrafast',
  '-acodec',
  'aac',
  '-ar',
  '44100',
  '-ac',
  '2',
  '-b:a',
  '96k',
  '-vcodec',
  'libx264',
  '-r',
  '25',
  '-b:v',
  '500k',
  '-f',
  'flv',
  'rtmp://mia05.contribute.live-video.net/app/<secret_key>'
]
player = subprocess.Popen(cmdline, stdin=subprocess.PIPE)