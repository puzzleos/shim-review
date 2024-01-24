From ubuntu:jammy

# install dependencies
RUN apt update -y && \
	DEBIAN_FRONTEND=noninteractive apt install -y wget gcc make bzip2 efitools

# get shim-15.8.tar.bz2
RUN wget https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2 || exit 1
RUN tar -xjf shim-15.8.tar.bz2 -C /

# copy build configuration and certs
COPY config/* /shim-15.8/
COPY config/certs /shim-15.8/certs

# generate the vendor_db.esl file from certs
RUN cd shim-15.8/certs; \
	for i in *.pem; do \
		sha1sum $i; \
		openssl x509 -text -noout -in $i; \
		cert=`echo $i | sed 's/\..*//'`; \
		certguid=`cat $cert.guid`; \
		cert-to-efi-sig-list -g $certguid $i $cert.esl; \
	done; \
	cat *.esl > /shim-15.8/vendor_db.esl; \
	ls -l *.esl /shim-15.8/vendor_db.esl

# append sbat data to the upstream data/sbat.csv
RUN cd shim-15.8; cat sbat.csv >> data/sbat.csv && cat data/sbat.csv

# do the build
RUN cd shim-15.8; make

# output the sha256 checksums of the *.efi binaries
RUN cd shim-15.8; sha256sum *.efi
