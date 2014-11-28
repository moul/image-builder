DISTRIB_IMAGES ?= \
	distrib-ubuntu-trusty distrib-ubuntu-utopic \
	distrib-debian-wheezy

APP_IMAGES ?= \
	app-docker app-rescue app-builder app-tryit \
	app-pydio app-owncloud app-wordpress app-ghost

IMAGES ?=	$(DISTRIB_IMAGES) $(APP_IMAGES)


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

# FIXME: add a templated rule
