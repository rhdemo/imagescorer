FROM fedora:26

RUN yum --setopt=tsflags=nodocs install -y python3-pip python3-devel gcc \
        libxslt-devel libxml2-devel libstdc++ libSM libXrender libXext file \
        redhat-rpm-config \
  && yum clean all \
  && rm -rf /var/cache/yum

ENV FLASK_PROXY_PORT 8080

ARG OPENWHISK_RUNTIME_DOCKER_VERSION="dockerskeleton@1.1.0"
ARG OPENWHISK_RUNTIME_PYTHON_VERSION="3@1.0.0"

ADD https://raw.githubusercontent.com/apache/incubator-openwhisk-runtime-docker/$OPENWHISK_RUNTIME_DOCKER_VERSION/core/actionProxy/actionproxy.py /actionProxy/actionproxy.py
# ADD https://raw.githubusercontent.com/apache/incubator-openwhisk-runtime-python/$OPENWHISK_RUNTIME_PYTHON_VERSION/core/pythonAction/pythonrunner.py /pythonAction/pythonrunner.py

COPY requirements.txt .
COPY *.whl ./
COPY model/* /pythonAction/model/

RUN pip3 install --no-cache-dir -r requirements.txt \
  && pip3 install *.whl \
  && cat /pythonAction/model/yolopb* > /pythonAction/model/yolo.pb \
  && rm -f /pythonAction/model/yolopb* \
  && mkdir /action

COPY yolorunner.py /pythonAction/yolorunner.py

# OpenShift compatibility
RUN for d in /action /pythonAction /actionProxy; do chown root:root -R $d; chmod -R g+rwX $d; done

CMD ["/bin/bash", "-c", "cd /pythonAction && python3 -u yolorunner.py"]
