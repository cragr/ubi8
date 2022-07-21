FROM registry.stage.redhat.io/ubi8/ubi AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN yum install --installroot /mnt/rootfs coreutils-single glibc-minimal-langpack --releasever 8 --setopt install_weak_deps=false --nodocs -y; yum --installroot /mnt/rootfs clean all
RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*

FROM scratch
LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="ubi8-micro-container"
LABEL name="ubi8/ubi-micro"
LABEL version="8.6"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="ubi8 micro image"
LABEL description="Very small image which doesn't install the package manager."
LABEL io.k8s.display-name="Ubi8-micro"
LABEL io.openshift.expose-services=""

COPY --from=ubi-micro-build /mnt/rootfs/ /
COPY --from=ubi-micro-build /etc/yum.repos.d/ubi.repo /etc/yum.repos.d/ubi.repo
CMD /bin/sh
