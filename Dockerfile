FROM python:2.7.14-alpine3.7

ENV RTD_HOME="/opt/rtd" \
RTD_VERSION="2.3.0"

COPY includes/init /startup

RUN chmod ug+x /startup/* && \
	apk --update add --no-cache --virtual .rtd-build-deps  \
		make \
		py-setuptools && \
	apk --update add --no-cache --virtual .rtd-deps \
		bash \
		py-lxml \
		postgresql-dev \
		libxslt-dev \
		nmap \
		nmap-nselibs \
		nmap-scripts \
		openssh \
		gcc \
		linux-headers \
		libc-dev \
		libxml2-dev \
        libjpeg-turbo-dev \
        jpeg-dev \
        zlib-dev \
        freetype-dev \
        lcms2-dev \
        openjpeg-dev \
        tiff-dev \
        tk-dev \
        tcl-dev \
        harfbuzz-dev \
        fribidi-dev \
        python-dev \
        gfortran \
		git && \
	mkdir -p $RTD_HOME && \
	wget --quiet https://github.com/rtfd/readthedocs.org/archive/${RTD_VERSION}.zip -O readthedocs.org-${RTD_VERSION}.zip && \
	mkdir -p /tmp/rtd && \
	unzip readthedocs.org-${RTD_VERSION}.zip -d /tmp/rtd && \
	rm -f readthedocs.org-${RTD_VERSION}.zip && \
	cp -r /tmp/rtd/readthedocs.org-${RTD_VERSION}/* $RTD_HOME && \
	rm -rf /tmp/rtd && \
	cd $RTD_HOME && \
	pip install psycopg2 && \
	pip install -r requirements.txt && \
	apk del .rtd-build-deps && \
	python manage.py collectstatic --noinput


CMD ["./startup/S01startup.sh"]

LABEL description="Read the Docs Image" \
	vendor="maxirus" \
	maintainer="Dan <dan@maxirus.com>"
