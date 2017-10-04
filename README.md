# Dockerfile of ParaView (v5.1.2) with OSMesa
This image has ParaView rendering servers (pvserver, pvrenderserver, pvdataserver, etc.).
- The base image is CentOS (latest).
- The install directory is /usr/local/ParaView_5.1.2
- Dependencies (MPICH, Python and FFmpeg) are also included.
- This image has OSMesa Libraries (you can do offscreen rendering).
