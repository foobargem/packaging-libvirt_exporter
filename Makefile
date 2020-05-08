image = libvirt_exporter:latest
cwd = $(shell pwd)

image:
	docker build -t $(image) .

rpm: image
	mkdir -p $(cwd)/output
	docker run --rm --mount src=$(cwd)/output,target=/output,type=bind $(image) \
		cp /root/rpmbuild/RPMS/x86_64/libvirt_exporter-2020.1-1.el7.centos.x86_64.rpm /output/

clean:
	rm -rf output
	docker image prune
