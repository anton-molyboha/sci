# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/tophat/tophat-2.0.9.ebuild,v 1.1 2014/03/06 09:46:50 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-single-r1

DESCRIPTION="A fast splice junction mapper for RNA-Seq reads"
HOMEPAGE="http://ccb.jhu.edu/software/tophat"
# https://github.com/infphilo/tophat
# http://ccb.jhu.edu/software/tophat/downloads/tophat-2.0.14.tar.gz
SRC_URI="http://ccb.jhu.edu/software/tophat/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/boost"
# sci-biology/seqan provides binaries and headers but there are no *.so files so no need for a runtime dependency
RDEPEND="${DEPEND}
	<=sci-biology/bowtie-2.2.3"

# PATCHES=( "${FILESDIR}"/${P}-flags.patch )

src_prepare() {
	sed -e "s#./samtools-0.1.18#"${S}"/src/samtools-0.1.18#g" -i configure* Makefile* src/Makefile* || die
	sed -e "s#./SeqAn-1.3#"${S}"/src/SeqAn-1.3#g" -i configure* || die
	#rm -rf src/SeqAn* || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-optim
		$(use_enable debug)
	)
	autotools-utils_src_configure
	sed -e "s#./samtools-0.1.18#"${S}"/src/samtools-0.1.18#g" -i Makefile* src/Makefile* || die
}

src_install() {
	autotools-utils_src_install
	python_fix_shebang "${ED}"/usr/bin/tophat
}
