# Camera Enclosure

This model is to print an enclosure for a IMX415 camera (<https://www.aliexpress.com/item/1005005897258405.html>). I wanted to use this camera in particularly as it supports USB3 output, with both h264 encoded output and YUV output at full resolution, which is not possible over a USB2 interface like most other cameras.

# Gotchas

* There appears to be multiple versions of this camera, which have slightly different lengths + heatsinks.
* The camera appears to be based on a dashcam chipset, and takes a while to 'boot'. So there is some hidden firmware running on this camera...
* It doesn't appear to be possible to vary the bitrate of the encoded output.
* The lens attachment on my version, doesn't align with previously seen m12 lens mounts, and I haven't figured a way to replace this with a C/CS lens mount yet.
* I very rarely write OpenSCAD, this is why it may not be optimal or nice to look at.

# License

I am using a parameterized clip from Daniel Perry.
The camera enclosure is licensed as MIT.
