#!/bin/bash

echo "Do OCR using tesseract V4..."
for img in $@; do
	echo -n "$img processing... "
	AIMG=$(python -c "import os;print(os.path.abspath(\"${img}\"))")
	#docker run -it --rm -v ${AIMG}:/tmp/ocr.img mcchae/tesseract tesseract /tmp/ocr.img stdout -l kor > ${AIMG}.txt
	#docker run -it --rm -v ${AIMG}:/tmp/ocr.img mcchae/tesseract tesseract /tmp/ocr.img stdout -l kor+eng -c preserve_interword_spaces=1 > ${AIMG}.txt
	time docker run -it --rm -v ${AIMG}:/tmp/ocr.img mcchae/tesseract tesseract /tmp/ocr.img stdout -l chi_tra+kor > ${AIMG}.txt
done

