# imagescorer

Build this image with `docker build -t imagescorer .` and run it with `docker run -p 8080:8080 imagescorer`.

If you have [HTTPie](http://httpie.org) installed, you can use the included `payload.py` script to test, e.g.,

`./payload.py some_file.jpg | http -j localhost:8080/run`

The first score will be slower than subsequent ones.

Currently there's not really any error checking.  In particular, malformed images are likely to just result in a straight-up 500 error.

This server extends from the generic OpenWhisk ActionRunner at https://github.com/apache/incubator-openwhisk-runtime-docker/blob/be67fe9fdb474eaba5387c28961d96a44c7eaf54/core/actionProxy/actionproxy.py . It's designed to be invoked as an OpenWhisk action, such as:

```bash
wsk action update imagescorer --docker somedockerrepo/imagescorer --memory 2048
wsk action invoke imagescorer --param-file payload.json -b
```

# credits

This uses Darkflow's implementation of YOLO and extend Apache
OpenWhisk's implementation of the Python ActionRunner.


## Running directly

### Requirements
Python 3.5.2+

### Usage
To run the server, please execute the following from the root directory:

```
pip3 install -r requirements.txt
python3 -u yolorunner.py
```

## Running with Docker

To run the server on a Docker container, please execute the following from the root directory:

```bash
# building the image
docker build -t imagescorer .

# starting up a container
docker run -p 8080:8080 imagescorer
```
