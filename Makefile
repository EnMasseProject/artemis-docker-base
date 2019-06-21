ARTIFACT_BASE=target/artemis-image
ARTEMIS_HOME=$(ARTIFACT_BASE)/opt/apache-artemis
ARTEMIS_VERSION=2.9.0

all: build_docker

target/apache-artemis-bin.tar.gz:
	mvn package -Dartemis.version=$(ARTEMIS_VERSION)

clean_modules:
	mvn clean

clean: clean_modules

target/artemis-image.tar.gz:
	mkdir -p $(ARTEMIS_HOME)/bin
	mkdir -p $(ARTEMIS_HOME)/lib
	mkdir -p $(ARTIFACT_BASE)/opt

	cp -r utils/bin $(ARTEMIS_HOME)

	tar -czf target/artemis-image.tar.gz -C $(ARTIFACT_BASE) .


build_docker: build
	docker build --build-arg version=$(ARTEMIS_VERSION) -t enmasse-builder:latest .

build:  target/artemis-image.tar.gz target/apache-artemis-bin.tar.gz

.PHONY: build_tar clean_modules
