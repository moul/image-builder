DISK ?= /dev/nbd1
S3_URL ?= s3://test-images
IS_LATEST ?= 0
BUILDDIR ?= /tmp/build/$(NAME)/


.PHONY: build release install_on_disk publish_on_s3 clean shell re all
.PHONY: publish_on_s3.tar publish_on_s3.sqsh


all: build


re: clean all


build: .docker-container.built


run: build
	docker run -it --rm $(NAME):$(VERSION) /bin/bash


release:
	docker tag  $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	docker push $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	if [ "x$(IS_LATEST)" = "x1" ]; then               \
	    docker tag $(NAME):$(VERSION) $(NAME):latest; \
	    docker push $(NAME):latest;                   \
	fi


install_on_disk: $(BUILDDIR)rootfs.tar /mnt/$(DISK)
	tar -C /mnt/$(DISK) -xf $(BUILDDIR)rootfs.tar


publish_on_s3: publish_on_s3.tar publish_on_s3.sqsh


publish_on_s3.tar: $(BUILDDIR)rootfs.tar
	s3cmd put --acl-public $(BUILDDIR)rootfs.tar $(S3_URL)/$(NAME)-$(VERSION).tar


publish_on_s3.sqsh: $(BUILDDIR)rootfs.sqsh
	s3cmd put --acl-public $(BUILDDIR)rootfs.sqsh $(S3_URL)/$(NAME)-$(VERSION).sqsh


clean:
	-docker rmi $(NAME):$(VERSION)
	-rm -f $(BUILDDIR)rootfs.tar .??*.built
	-rm -rf $(BUILDDIR)rootfs


shell:  .docker-container.built
	docker run --rm -it $(NAME):$(VERSION) /bin/bash


.docker-container.built: Dockerfile
	-find patches -name '*~' -delete
	docker build -t $(NAME):$(VERSION) .
	docker inspect -f '{{.Id}}' $(NAME):$(VERSION) > .docker-container.built


$(BUILDDIR)rootfs: $(BUILDDIR)export.tar
	rm -rf $(BUILDDIR)rootfs.tmp
	mkdir $(BUILDDIR)rootfs.tmp
	tar -C $(BUILDDIR)rootfs.tmp -xf $(BUILDDIR)export.tar
	rm -f $(BUILDDIR)rootfs.tmp/.dockerenv $(BUILDDIR)rootfs.tmp/.dockerinit
	rm -rf $(BUILDDIR)rootfs
	mv $(BUILDDIR)rootfs.tmp $(BUILDDIR)rootfs


$(BUILDDIR)rootfs.tar: $(BUILDDIR)rootfs
	tar --format=gnu -C $(BUILDDIR)rootfs -cf $(BUILDDIR)rootfs.tar.tmp .
	mv $(BUILDDIR)rootfs.tar.tmp $(BUILDDIR)rootfs.tar


$(BUILDDIR)rootfs.sqsh: $(BUILDDIR)rootfs
	mksquashfs $(BUILDDIR)rootfs $(BUILDDIR)rootfs.sqsh -noI -noD -noF -noX


$(BUILDDIR)export.tar: .docker-container.built
	-mkdir -p $(BUILDDIR)
	docker run --entrypoint /dontexists $(NAME):$(VERSION) 2>/dev/null || true
	docker export $(shell docker ps -lq) > $(BUILDDIR)export.tar.tmp
	mv $(BUILDDIR)export.tar.tmp $(BUILDDIR)export.tar


/mnt/$(DISK):
	umount $(DISK) || true
	mkfs.ext4 $(DISK)
	mkdir -p /mnt/$(DISK)
	mount $(DISK) /mnt/$(DISK)
