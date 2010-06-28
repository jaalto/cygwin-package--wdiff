#!/bin/sh
#
# /etc/postinstall/<package>.sh -- Custom installation steps
#
# -- NOTE: This script will be run under /bin/sh

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11R6/bin:$PATH

set -e

Environment()
{
    #  Define variables to the rest of the script

    [ "$1" ] && dest="$1"        # install destination

    if [ "$dest" ]; then
        #  Delete trailing slash
        dest=$(echo $dest | sed -e 's,/$,,' )
    fi

    package="wdiff"

    #   This file will be installed as
    #   /etc/postinstall/<package>.sh so derive <package>
    #   But if this file is run from CYGIN-PATCHES/postinstall.sh
    #   then we do not know the package name

    name=$(echo $0 | sed -e 's,.*/,,' -e 's,\.sh,,' )

    if [ "$name" != "postinstall" ]; then
        package="$name"
    fi

    bindir="$dest/usr/bin"
    libdir="$dest/usr/lib"
    libdirx11="$dest/usr/lib/X11"
    includedir="$dest/usr/include"

    sharedir="$dest/usr/share"
    infodir="$sharedir/info"
    docdir="$sharedir/doc"
    etcdir="$dest/etc"

    #   1) list of files to be copied to /etc
    #   2) Source locations

    conffiles_to="$etcdir/preremove/$package-manifest.lst"
    conffiles_from="$etcdir/preremove/$package-manifest-from.lst"
}

Warn ()
{
    echo "$@" >&2
}

Run ()
{
    ${test+echo} "$@"
}

InstalInfo()
{
    cd $infodir || return $?

    central=$infodir/dir

    for file in $(ls $infodir/$package*.info)
    do
        [ ! -f $file ] && continue      # ls failed, no info files

        Run install-info --dir-file=$central $file
    done
}

Main()
{
    Environment "$@"    &&
    InstalInfo
}

Main "$@"

# End of file
#:info
(
    cd /usr/share/info &&
    for i in  wdiff.info
    do
	install-info --dir-file=./dir --info-file=$i
    done
)
