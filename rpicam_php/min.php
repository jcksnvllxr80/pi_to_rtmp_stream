<!DOCTYPE html>
<html>
  <head>
    <title>RPi Cam Preview</title>
    <script src="js/script.js"></script>
    <link rel="stylesheet" href="css/style_minified.css" />
  </head>
  <body onload="setTimeout('init(0,25,1);', 100);" style="background-image: url('bluebird.png')">
    <p><a href="https://myearthcam.com/jcksnvllxr80" style="font-weight:bold; font-size:30px; color:red;">The stream has moved to EarthCam now! Click here to watch live!</a></p>
    <center>
      <iframe width="720" height="435" src="https://www.myearthcam.com/jcksnvllxr80?embed" frameborder="0" scrolling="no" allowfullscreen></iframe>
      <!--<div><img id="mjpeg_dest" onclick="toggle_fullscreen(this);" /></div>-->
    </center>
 </body>
</html>