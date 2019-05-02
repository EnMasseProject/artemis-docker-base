FROM enmasseproject/java-base:11-0

RUN yum -y install which libaio python hostname iputils && yum clean all -y && mkdir -p /var/run/artemis/

ARG version
ARG maven_version
ARG commit

ENV ARTEMIS_HOME=/opt/apache-artemis HOME=/run/artemis/split-1/ PATH=$ARTEMIS_HOME/bin:$PATH VERSION=${version} COMMIT=${commit} MAVEN_VERSION=${maven_version}

ADD ./target/apache-artemis-bin.tar.gz /opt
RUN mv /opt/apache-artemis-${maven_version} $ARTEMIS_HOME
ADD ./target/artemis-image.tar.gz /

RUN chgrp -R 0 $ARTEMIS_HOME && \
    chmod -R g=u $ARTEMIS_HOME
RUN mkdir -p $HOME && \
    chgrp -R 0 $HOME && \
    chmod -R g=u $HOME

CMD ["/opt/apache-artemis/bin/launch.sh"]
