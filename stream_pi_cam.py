#!/usr/bin/python

import socket
import time
import yaml
import logging
import picamera
import yaml
from threading import Thread

APP_DIR = "/home/pi/pi_to_rtmp_stream
CONF_RELATIVE_DIR = "conf/stream.yaml"
CONFIG_FILE = "{}/{}".format(APP_DIR, CONF_RELATIVE_DIR)
timelapse_settings = {}
video_settings = {}
conn_settings = {}

def init_logging():
  logging_logger = logging.getLogger(__name__)
  logging_logger.setLevel(logging.DEBUG)
  logging_logger.propagate = False
  # create console handler and set level to info
  handler = logging.StreamHandler()
  handler.setLevel(logging.DEBUG)
  formatter = logging.Formatter("%(asctime)s [stream_pi_cam] [%(levelname)-5.5s]  %(message)s")
  handler.setFormatter(formatter)
  logging_logger.addHandler(handler)
  logging_logger.info("Logger initialized.")
  return logging_logger


def init_config():
  global timelapse_settings, video_settings, conn_settings
  config_file = read_config_file()
  timelapse_settings = {k: v for k, v in config_file['timelapse'].items()}
  video_settings = {k: v for k, v in config_file['video'].items()}
  conn_settings = {k: v for k, v in config_file['connection'].items()}


def read_config_file():
  logger.info("Reading config yaml file, {},  into dictionaries.".format(CONFIG_FILE))
  config = None
  with open(CONFIG_FILE, 'r') as yaml_config_file:
    config = yaml.full_load(yaml_config_file)
  return config


def stop_recording(cam):
  logger.info("Stopping video stream/recording from previous connection.")
  try:
    cam.stop_recording()
  except Exception as e:
    pass


def get_param(dict, key, default=None):
  return dict.get(key, default)


def camera_setup():
  camera = picamera.PiCamera()
  camera.resolution = get_param(video_settings, 'resolution', (1024, 768))
  camera.framerate = get_param(video_settings, 'framerate', 24)
  return camera


def open_socket():
  socket_port = get_param(conn_settings, 'listen_port', 8080)
  logger.info("Opening listener on localhost, port: {}.".format(socket_port))
  server_socket = socket.socket()
  server_socket.bind(('0.0.0.0', ))
  server_socket.listen(0)
  return server_socket


def close_socket(server_socket):
  try:
    server_socket.close()
  except Exception as e:
    logger.error("Error occurred closing socket: {}".format(e))


def do_timelapse(cam):
  logger.info("Starting timelapse thread.")
  sleep_time = get_param(timelapse_settings, 'interval', 3600)
  timelapse_dir = '{}/{}'.format(APP_DIR, get_param(timelapse_settings, 'relative_dir', 'timelapse'))
  img_timestamp = get_param(timelapse_settings, 'label_fmt', '%Y%m%dT%H%M%SZ')
  while get_param(timelapse_settings, 'state'):
    time.sleep(sleep_time)
    image_name = '{}/{}-timelapse.jpg'.format(timelapse_dir, time.strftime(img_timestamp))
    logger.info("Capturing timelapse image: {}".format(image_name))
    cam.capture(image_name, use_video_port=True)


def stream(server_socket, cam):
  logger.info("Waiting for incoming connection on socket, {}.".format(server_socket.getsockname()))
  connection = server_socket.accept()[0].makefile('wb')
  if cam.recording:
    stop_recording(cam)
  logger.info("Socket connected. Starting video stream.")
  cam.start_recording(connection, format='h264', resize=video_settings.resolution, inline_headers=True)


def stream_video_to_network(cam):
  logger.info("Starting network video stream thread.")
  server_socket = open_socket()
  while True:
    try:
      stream(server_socket, cam)
    except Exception as e:
      logger.error("An error occurred: {}. Will try to close server socket.".format(e))
      close_socket(server_socket)


def main(camera):
  Thread(target=stream_video_to_network, args=(camera,)).start()
  Thread(target=do_timelapse, args=(camera,)).start()


if __name__ == "__main__":
  global logger
  logger = init_logging()
  init_config()
  main(camera_setup())
