NAME =		ocs-app-docker
VERSION =	vivid
IS_LATEST =	1
TITLE =		Docker
DESCRIPTION =	Docker 1.3.2 + fig + nsenter + pipework + gosu
SOURCE_URL =	https://github.com/online-labs/image-builder/tree/master/app-docker

include ../docker-rules.mk

update_fig:
	docker run --rm armbuild/docker-fig bash -c 'cat /code/dist/fig-*-py2.7.egg' > sources/fig.egg

update_nsenter:
	docker run --rm -v $(PWD)/patches/usr/bin:/target armbuild/jpetazzo-nsenter
