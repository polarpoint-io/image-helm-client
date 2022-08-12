FROM ubuntu

ARG HELM_RELEASE_PLUGIN_VERSION="0.3.3"

ENV HELM_RELEASE_TAR="helm-release_${HELM_RELEASE_PLUGIN_VERSION}_linux_amd64.tar.gz"
ENV HELM_RELEASE_URL="https://github.com/sstarcher/helm-release/releases/download/${HELM_RELEASE_PLUGIN_VERSION}/${HELM_RELEASE_TAR}"


RUN  apt-get update \
    && apt-get install -y gnupg git bash curl

#RUN    curl https://baltocdn.com/helm/signing.asc |  apt-key add - 
RUN    apt-get install apt-transport-https --yes && \
    echo "deb [trusted=yes] https://baltocdn.com/helm/stable/debian/ all main" |  tee /etc/apt/sources.list.d/helm-stable-debian.list

RUN apt-get  -o  update \
    && apt-get -o  install -y helm  \
    && apt-get clean \
    && mkdir --parents /root/.local/share/helm/plugins/helm-release 


RUN helm plugin install https://github.com/chartmuseum/helm-push.git
RUN curl -SL ${HELM_RELEASE_URL}  | tar -zxC /root/.local/share/helm/plugins/helm-release
RUN helm plugin list
WORKDIR /apps

ENTRYPOINT ["helm"]
CMD ["--help"]
