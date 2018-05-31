FROM ubuntu:16.04
MAINTAINER MoonChang Chae <mcchae@gmail.com>

RUN echo "deb http://ppa.launchpad.net/alex-p/tesseract-ocr/ubuntu xenial main\ndeb-src http://ppa.launchpad.net/alex-p/tesseract-ocr/ubuntu xenial main " >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CEF9E52D \
    && apt-get update \
    && apt-get install tesseract-ocr -y \
    && apt-get install tesseract-ocr-kor -y \
    && apt-get install tesseract-ocr-jpn -y \
    && apt-get install tesseract-ocr-chi-tra -y

CMD ["tesseract"]
