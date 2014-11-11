NAME=armbuild/ocs-ubuntu
VERSION=trusty
DISK=/dev/nbd1
S3_URL=s3://test-images/$(NAME)

.PHONY: build release install_on_disk publish_on_s3 clean shell re all

all: build

re: clean all

build: rootfs.tar


release:
	# docker tag $(NAME):$(VERSION) $(NAME):latest
	docker tag $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	docker push $(NAME):$(VERSION)


install_on_disk: /mnt/$(DISK) rootfs.tar
	tar xf rootfs.tar /mnt/$(DISK)


publish_on_s3: rootfs.tar
	s3cmd put --acl-public $< $(S3_URL)/$(NAME)-$(VERSION).tar.gz


clean:
	docker rmi $(NAME):$(VERSION) $(NAME)-flatten:$(VERSION) || true
	rm -f rootfs.tar .??*.built || true


shell:  .docker-container.built
	docker run --rm -it $(NAME):$(VERSION) /bin/bash


.docker-container.built: Dockerfile
	docker build -t $(NAME):$(VERSION) .		
	docker inspect -f '{{.Id}}' $(NAME):$(VERSION) > .docker-container.built


rootfs-flatten.tar: .docker-container.built
	docker run --entrypoint /dontexists $(NAME):$(VERSION) 2>/dev/null || true
	docker export $(shell docker ps -lq) > rootfs-flatten.tar


.docker-container-flatten.built: | rootfs-flatten.tar
	cat rootfs-flatten.tar | docker import - flatten
	docker inspect flatten > .docker-container-flatten.built


rootfs.tar: | .docker-container-flatten.built
	docker save flatten | tar --wildcards -Oxvf - '*/layer.tar' > $@
	tar --delete -f rootfs.tar .dockerenv .dockerinit


/mnt/$(DISK):
	umount $(DISK) || true
	mkfs.ext4 $(DISK)
	mkdir -p /mnt/$(DISK)
	mount $(DISK) /mnt/$(DISK)
