NAME =      ocs-docker
VERSION =   utopic
IS_LATEST = 1

include ../docker-rules.mk

update_fig:
	docker run --rm armbuild/docker-fig bash -c 'cat /code/dist/fig-*-py2.7.egg' > sources/fig.egg

update_nsenter:
	docker run --rm -v $(PWD)/patches/usr/bin:/target armbuild/jpetazzo-nsenter
