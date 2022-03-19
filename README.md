# pi_to_rtmp_stream

## About

- To use raspberry pi to stream rtmp to (youtube/earthcam) as well as simultaneously taking pictures for a timelapse. I am using this for the birdhouse in my back yard.
- there are two parts to this apoplication
  1. starts the stream and open a socket for a local device to connect and get the video stream
  2. connect to the network stream and send it to the rtmp endpoint using ffmpeg (usage shown below)

&nbsp;&nbsp;

## Installation 

### (from raspberry pi terminal)

```bash
cd /home/pi
git clone https://github.com/jcksnvllxr80/pi_to_rtmp_stream.git
sudo systemctl enable /home/pi/pi_to_rtmp_stream/rtmp_stream.service
sudo systemctl daemon-reload
```
&nbsp;&nbsp;

## Configuration

### Modify the stream.yaml file in the 'pi_to_rtmp_stream/conf' directory to fit your needs

```yaml
timelapse:
  relative_dir: timelapse
  state: True
  interval: 60
  label_fmt: '%Y%m%d%H%M'
video:
  resolution: (1640, 1232)
  framerate: 24
connection:
  listen_port: 9090
```

### NOTE: if the timelapse relative_dir is changed in the yaml config, make sure to also change it in the pi_to_rtmp.sh where the directory is created if it doesnt already exist.

&nbsp;&nbsp;

## Starting / Stopping / Restarting /Status the Stream

```bash
sudo systemctl start rtmp_stream  # start the stream
sudo systemctl stop rtmp_stream  # stop the stream
sudo systemctl restart rtmp_stream  # restart the stream
sudo systemctl status rtmp_stream  # restart the stream
```

### NOTE: the stream will auttomatically start on boot when enabled as a service (line: 3 under the installation instrucitons)

&nbsp;&nbsp;

## Disabling the Streaming Service

```bash
sudo systemctl disable rtmp_stream
```
&nbsp;&nbsp;

## Running as non-service standalone

!! make sure the service is stopped and disabled before running this command

```bash
/home/pi/pi_to_rtmp_stream/pi_to_rtmp.sh
```

### NOTE: cntl+c quits the running application when ran from terminal manually as desribed in this subsection (i.e. not as a service)

&nbsp;&nbsp;

## Sending the Stream to Youtube/EarthCam

// from command line
```bash
ffmpeg -i 'tcp://localhost:9090?fifo_size=6000000&overrun_nonfatal=1' -crf 30 -preset ultrafast -acodec aac -ar 44100 -ac 2 -b:a 96k -vcodec libx264 -r 25 -b:v 500k -f flv 'rtmp://mia05.contribute.live-video.net/app/<secret_key>'
```

// with python
```python
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
```

// as a service
- i have provided an example service, 'transmit_stream', that can be used in the same manner as the 'rtmp_stream' service described above