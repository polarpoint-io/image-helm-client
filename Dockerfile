FROM ubuntu:22.04 

# install helm
ARG HELM_RELEASE_PLUGIN_VERSION="0.3.3"
ARG HELM_RELEASE_VERSION="v3.10.2"

ENV HELM_RELEASE_TAR="helm-${HELM_RELEASE_VERSION}-linux-amd64.tar.gz"
ENV HELM_RELEASE_URL="https://get.helm.sh/${HELM_RELEASE_TAR}"

# helm-docs
ARG HELM_DOCS_VERSION="1.11.0"
ENV HELM_DOCS_TAR="helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz"
ENV HELM_DOCS_URL="https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/${HELM_DOCS_TAR}"


RUN  apt-get update \
    && apt-get install -y gnupg git bash curl jq
RUN curl -SL ${HELM_RELEASE_URL}  | tar -zxC /usr/bin --strip-components 1
RUN curl -SL ${HELM_DOCS_URL}  | tar -zxC /usr/bin


# install node version manager and node
RUN mkdir -p /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ARG NODE_VERSION_MANAGER_VERSION="v0.39.2"
ARG NODE_VERSION="v16.13.0"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NODE_VERSION_MANAGER_VERSION}/install.sh | bash 
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
# add node and npm to the PATH
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/bin
ENV PATH $NODE_PATH:$PATH
RUN npm -v
RUN node -v
RUN npm install --global yarn

RUN helm version
RUN helm-docs --version
RUN mkdir --parents /root/.local/share/helm/plugins/helm-release 
RUN helm plugin install https://github.com/chartmuseum/helm-push
RUN curl -SL ${HELM_RELEASE_URL}  | tar -zxC /root/.local/share/helm/plugins/helm-release
RUN helm plugin list

CMD ["/bin/helm"]
