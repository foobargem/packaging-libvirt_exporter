image = libvirt_exporter:latest
cwd = $(shell pwd)

image:
	docker build -t $(image) .

rpm:
	mkdir -p $(cwd)/output
	docker run --rm --mount src=$(cwd)/output,target=/output,type=bind $(image) \
		cp -arp /libvirt_exporter /output/

clean:
	rm -rf output
	docker image prune
