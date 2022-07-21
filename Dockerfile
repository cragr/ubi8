FROM scratch
CMD /bin/sh && chroot /host && podman image prune -a -f && hostname && exit
