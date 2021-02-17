FROM quay.io/enmasse/java-base:11-6

RUN yum -y install which libaio python hostname iputils openssl apr && yum clean all -y && mkdir -p /var/run/artemis/

ARG version
ARG commit

ENV ARTEMIS_HOME=/opt/apache-artemis HOME=/run/artemis/split-1/ PATH=$ARTEMIS_HOME/bin:$PATH VERSION=${version} COMMIT=${commit}

ADD ./artemis-dist/target/apache-artemis-bin.tar.gz /opt
RUN mv /opt/apache-artemis-${version} $ARTEMIS_HOME
ADD ./target/artemis-image.tar.gz /

RUN chgrp -R 0 $ARTEMIS_HOME && \
    chmod -R g=u $ARTEMIS_HOME
RUN mkdir -p $HOME && \
    chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

CMD ["/opt/apache-artemis/bin/launch.sh"]
