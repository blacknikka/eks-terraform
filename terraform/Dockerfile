FROM amazon/aws-cli:2.0.14

RUN yum install -y \
    unzip \
    jq

WORKDIR /terraform

# terraform
ARG tf_version=terraform_0.12.25_linux_amd64.zip
RUN curl https://releases.hashicorp.com/terraform/0.12.25/"${tf_version}" -o "${tf_version}" && \
    unzip "${tf_version}" && \
    mv ./terraform /usr/local/bin/terraform && \
    rm -rf "${tf_version}"

ENTRYPOINT [ "/bin/bash" ]
