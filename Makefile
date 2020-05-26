ARTIFACT_BASE=target/artemis-image
ARTEMIS_HOME=$(ARTIFACT_BASE)/opt/apache-artemis
ARTEMIS_VERSION=2.13.0

all: build_docker

metrics:
	cd metrics-plugin; mvn package -Dartemis.version=$(ARTEMIS_VERSION)
	mkdir -p $(ARTEMIS_HOME)/web
	mkdir -p $(ARTEMIS_HOME)/lib
	cp -f metrics-plugin/artemis-prometheus-metrics-plugin/target/artemis-prometheus-metrics-plugin-*.jar $(ARTEMIS_HOME)/lib
	cp -f metrics-plugin/artemis-prometheus-metrics-plugin-servlet/target/metrics.war $(ARTEMIS_HOME)/web

tcnative:
	cd tcnative-plugin; mvn package -Dartemis.version=$(ARTEMIS_VERSION)
	mkdir -p $(ARTEMIS_HOME)/lib
	cp -f tcnative-plugin/target/tcnative-plugin.jar $(ARTEMIS_HOME)/lib

target/apache-artemis-bin.tar.gz:
	cd artemis-dist; mvn package -Dartemis.version=$(ARTEMIS_VERSION)

clean_modules:
	cd artemis-dist; mvn clean
	cd metrics-plugin; mvn clean
	cd tcnative-plugin; mvn clean


clean: clean_modules

target/artemis-image.tar.gz: metrics tcnative
	mkdir -p $(ARTEMIS_HOME)/bin
	mkdir -p $(ARTEMIS_HOME)/lib
	mkdir -p $(ARTIFACT_BASE)/opt

	cp -r utils/bin $(ARTEMIS_HOME)

	tar -czf target/artemis-image.tar.gz -C $(ARTIFACT_BASE) .


build_docker: build
	docker build --build-arg version=$(ARTEMIS_VERSION) -t enmasse-builder:latest .

build:  target/artemis-image.tar.gz target/apache-artemis-bin.tar.gz

.PHONY: build_tar clean_modules metrics tcnative
