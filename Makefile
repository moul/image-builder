IMAGES ?=	ubuntu-trusty ubuntu-utopic debian-wheezy      \
		rescue docker                                  \
		builder tryit-docker                           \
		app-pydio app-owncloud app-wordpress app-ghost


all:    build


build:
	for image in $(IMAGES); do \
		$(MAKE) -C $$image; \
	done


publish_on_s3:
	for image in $(IMAGES); do \
		$(MAKE) -C $$image publish_on_s3; \
	done


publish_on_s3.tar:
	for image in $(IMAGES); do \
		$(MAKE) -C $$image publish_on_s3.tar; \
	done


release:
	for image in $(IMAGES); do \
		$(MAKE) -C $$image release; \
	done


clean:
	for image in $(IMAGES); do \
		$(MAKE) -C $$image clean; \
	done
