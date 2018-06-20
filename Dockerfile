#FROM mcchae/sshd-x
FROM alpine
MAINTAINER MoonChang Chae mcchae@gmail.com
LABEL Description="alpine tesseract 4.x"

ADD autogen.sh configure /tmp/

ENV TESSDATA_PREFIX /usr/local/share
ENV LAN_TYPE best
#ENV LAN_TYPE fast
WORKDIR /tmp
RUN apk --update add --virtual build-dependencies alpine-sdk automake autoconf libtool \
		libpng-dev libjpeg-turbo-dev tiff-dev zlib-dev wget git \
# for Leptonica
	&& wget -q http://www.leptonica.org/source/leptonica-1.76.0.tar.gz \
	&& tar xvfz leptonica-1.76.0.tar.gz \
	&& cd leptonica-1.76.0 \
	&& ./configure \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf leptonica* \
# for tesseract
	&& git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git \
	&& cd tesseract \
	&& mv /tmp/autogen.sh . && chown root:root autogen.sh \
	&& ./autogen.sh \
	&& cp /tmp/configure . && chown root:root configure \
	&& ./configure --enable-debug \
	&& LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make \
	&& make install \
#	&& ldconfig \
	&& cd .. \
	&& rm -rf tesseract*  \
#	&& apk del build-dependencies
# for shared libs
#RUN apk --update add libpng-dev libjpeg-turbo-dev tiff-dev zlib-dev
# for tesseract data
#WORKDIR /
#RUN mkdir -p $TESSDATA_PREFIX/tessdata \
#	&& wget -q -P $TESSDATA_PREFIX/tessdata/ https://github.com/tesseract-ocr/tessdata_$LAN_TYPE/raw/master/eng.traineddata \
#	&& wget -q -P $TESSDATA_PREFIX/tessdata/ https://github.com/tesseract-ocr/tessdata_$LAN_TYPE/raw/master/kor.traineddata \
#	&& wget -q -P $TESSDATA_PREFIX/tessdata/ https://github.com/tesseract-ocr/tessdata_$LAN_TYPE/raw/master/jpn.traineddata \
#	&& wget -q -P $TESSDATA_PREFIX/tessdata/ https://github.com/tesseract-ocr/tessdata_$LAN_TYPE/raw/master/chi_tra.traineddata \

CMD ["tesseract"]
