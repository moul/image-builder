NAME=armbuild/ocs-ubuntu
VERSION=trusty
DISK=/dev/nbd1
S3_URL=s3://test-images

.PHONY: build release install_on_disk publish_on_s3 clean shell re all

all: build

re: clean all

build: rootfs.tar


release:
	# docker tag $(NAME):$(VERSION) $(NAME):latest
	docker tag $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	docker push $(NAME):$(VERSION)


install_on_disk: rootfs.tar /mnt/$(DISK)
	tar xf rootfs.tar /mnt/$(DISK)


publish_on_s3: rootfs.tar
	s3cmd put --acl-public $< $(S3_URL)/$(NAME)-$(VERSION).tar


clean:
	docker rmi $(NAME):$(VERSION) || true
	rm -f rootfs.tar .??*.built || true


shell:  .docker-container.built
	docker run --rm -it $(NAME):$(VERSION) /bin/bash


.docker-container.built: Dockerfile
	find patches -name '*~' -delete
	docker build -t $(NAME):$(VERSION) .		
	docker inspect -f '{{.Id}}' $(NAME):$(VERSION) > .docker-container.built


rootfs: export.tar
	rm -rf rootfs
	mkdir rootfs.tmp
	tar -C rootfs.tmp -xf export.tar
	rm -f rootfs.tmp/.dockerenv rootfs.tmp/.dockerinit
	mv rootfs.tmp rootfs


rootfs.tar: rootfs
	tar --format=gnu -C rootfs -cf rootfs.tar.tmp .
	mv rootfs.tar.tmp rootfs.tar


export.tar: .docker-container.built
	docker run --entrypoint /dontexists $(NAME):$(VERSION) 2>/dev/null || true
	docker export $(shell docker ps -lq) > export.tar.tmp
	mv export.tar.tmp export.tar


/mnt/$(DISK):
	umount $(DISK) || true
	mkfs.ext4 $(DISK)
	mkdir -p /mnt/$(DISK)
	mount $(DISK) /mnt/$(DISK)
