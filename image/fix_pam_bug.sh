#!/bin/bash
set -e
source /bd_build/buildconfig
set -x

# Fixes https://github.com/docker/docker/issues/6345
# The Github is closed, but some apps such as pbuilder still triggers it.

export CONFIGURE_OPTS=--disable-audit
cd /tmp

$minimal_apt_get_install gdebi-core
apt-get build-dep -y --no-install-recommends pam
apt-get source -y -b pam
gdebi -n libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb
rm -rf *.deb *.gz *.dsc *.changes pam-*

# Unfortunately there is no way to automatically remove build deps, so we do this manually.
apt-get remove -y gdebi-core autoconf automake autopoint autotools-dev binutils bsdmainutils \
	build-essential bzip2 cpp debhelper dh-autoreconf \
	diffstat docbook-xml docbook-xsl dpkg-dev flex g++  gcc  gettext gettext-base \
	groff-base intltool-debian libarchive-zip-perl libatomic1 \
	libaudit-dev libc-dev-bin libc6-dev libcrack2 libcrack2-dev libcroco3 \
	libdb-dev libdb5.3-dev libdpkg-perl libfl-dev libgc1c2 \
	libgdbm3 libgomp1 libgpm2 \
	libmpfr4 libpcre3-dev \
	libpipeline1 libquadmath0 libselinux1-dev libsepol1-dev libsigsegv2 \
	libtimedate-perl libtool libtsan0 libunistring0 libxml2 libxml2-utils \
	libxslt1.1 linux-libc-dev m4 make man-db patch perl pkg-config \
	po-debconf quilt sgml-base sgml-data w3m xml-core xsltproc xz-utils
# dh-strip-nondeterminism g++-5 gcc-5 cpp-5 perl-modules-5.22 libubsan0 libstdc++-5-dev  libasan2 libasprintf0v5
# libcc1-0 libcilkrts5 libgcc-5-dev libfile-stripnondeterminism-perl  libperl5.22
# libpcre16-3 libpcre32-3 libpcrecpp0v5 libmpx0  liblsan0  libicu55 libisl15 
# libitm1libmpc3

# apt-get remove -y gdebi-core
apt-get autoremove -y
