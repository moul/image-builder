IMAGES =	ubuntu-trusty/ ubuntu-utopic/ debian-wheezy    \
		rescue docker                                  \
		builder tryit-docker                           \
		app-pydio app-owncloud app-wordpress app-ghost

all:
	for image in $(IMAGES); do   \
		$(MAKE) -C $$image; \
	done
