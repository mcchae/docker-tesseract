#!/bin/bash

###############################################################################
# build tesseract from source
###############################################################################

# 1) packages for building source
sudo apt-get install -y autoconf automake libtool
sudo apt-get install -y autoconf-archive
sudo apt-get install -y pkg-config
sudo apt-get install -y libpng12-dev
sudo apt-get install -y libjpeg8-dev
sudo apt-get install -y libtiff5-dev
sudo apt-get install -y zlib1g-dev

# if you plan to install the training tools, you also need the following libraries
#sudo apt-get install -y libicu-dev
#sudo apt-get install -y libpango1.0-dev
#sudo apt-get install -y libcairo2-dev

# 2) build Leptonica
if [ ! -e /usr/local/lib/liblept.so ];then
	if [ ! -d leptonica-1.76.0 ];then
		wget http://www.leptonica.org/source/leptonica-1.76.0.tar.gz
		tar xvfz leptonica-1.76.0.tar.gz
	fi
	pushd leptonica-1.76.0
		./configure
		make
		sudo make install
	popd
fi

# 3) build tesseract
which tesseract
if [ $? -ne 0 ];then
	if [ ! -e tesseract ]; then
		git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git
	fi
	pushd tesseract
		./autogen.sh
		./configure --enable-debug
		LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make
		sudo make install
		sudo ldconfig
	popd
fi

# 4) tesseract language data
export TESSDATA_PREFIX=/usr/local/share
if [ ! -d $TESSDATA_PREFIX/tessdata ]; then
	sudo mkdir -p $TESSDATA_PREFIX/tessdata
fi

LANS="eng
kor
jpn
chi_tra
"
LAN_TYPE="best"
#LAN_TYPE="fast"
while read -r LAN; do
	if [ ! -e $TESSDATA_PREFIX/tessdata/$LAN ];then
		wget https://github.com/tesseract-ocr/tessdata_$LAN_TYPE/raw/master/$LAN.traineddata
		sudo mv -f $LAN.traineddata $TESSDATA_PREFIX/tessdata/$LAN.traineddata
	fi
done <<< "$LANS"

