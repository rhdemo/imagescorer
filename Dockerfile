FROM fedora:26

RUN mkdir -p /usr/src/app && mkdir -p /usr/src/app/swagger_server && mkdir -p /usr/src/app/model
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
COPY *.whl /usr/src/app/
COPY swagger_server/* /usr/src/app/swagger_server/
COPY model/* /usr/src/app/model/

RUN cat /usr/src/app/model/yolopb* > /usr/src/app/model/yolo.pb && rm -f /usr/src/model/yolopb*

RUN yum install -y python3-pip && pip3 install --no-cache-dir -r requirements.txt && pip3 install *.whl

EXPOSE 8080

ENTRYPOINT ["python3"]

CMD ["-m", "swagger_server"]