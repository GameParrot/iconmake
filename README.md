# iconmake
Converts PNG images into macOS icon files (iconset folders or ICNS images).
# Installation
A zipped binary can be found in the Releases. See Building if you would like to build iconmake from sources.
# Usage
To convert an image to an iconset folder, use ```iconmake input.png output.iconset```
To convert a PNG image to an ICNS icon, use ```iconmake input.png output.icns --icns```
# Building
1. Clone this repo (```git clone https://github.com/GameParrot/iconmake.git; cd iconmake```)__
To build the default target, use ```make```__
To build for Intel Macs, use ```make intel```__
To build for Apple Silicon Macs, use ```make arm```__
To build universal, use ```make universal```__
