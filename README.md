
# **djmount**

djmount - mount MediaServers content as a Linux filesystem.
Created 23/04/2005, R�mi Turboult <r3mi@users.sourceforge.net>


djmount is a UPnP AV client. It mounts as a Linux filesystem (using FUSE)
the media content of compatible UPnP AV devices (see "Known Compatible Devices"
paragraph below).

djmount discovers automatically all UPnP AV Media Servers on the network,
and make the content available in a directory tree. All shared files 
(e.g. Audio or Video files) are directly visible and can be played using 
your favorite media player.


djmount is free software, licensed under the terms of the GNU General Public
License (GNU GPL : see "COPYING" file) : see details in "Copyright and 
Licenses" paragraph below.


## **Example 1 : browsing**

(the actual files listed depend on your AV files collection ! Also, the 
directory structure is different for each kind of Media Server)

$ djmount /mnt/av

$ cd /mnt/av

$ ls -l
dr-xr-xr-x  3 root root 512 jan  1  2000 SomeMediaServerDeviceName/
dr-xr-xr-x  3 root root 512 jan  1  2000 AnotherMediaServerDeviceName/
-r--r--r--  1 root root 114 jan  1  2000 devices

$ cd SomeMediaServerDeviceName

$ ls -l 
dr-xr-xr-x  14 root root 512 jan  1  2000 Music/
dr-xr-xr-x   5 root root 512 jan  1  2000 Pictures/
dr-xr-xr-x   4 root root 512 jan  1  2000 Videos/

$ ls -l Music/Artists/Tinariwen/
-r--r--r--  1 root root 5407087 jan  1  2000 Chatma.mp3
-r--r--r--  1 root root 3751143 jan  1  2000 Chet Boghassa.mp3

$ xmms Music/Artists/Tinariwen/

$ fusermount -u /mnt/av


Note: the FUSE  kernel module shall be loaded before running djmount 
(otherwise you will get the error: 
"fusermount: fuse device not found, try 'modprobe fuse' first").


## **Example 2 : searching**

(again, the actual content listed depends on your AV files collection !)

$ djmount /mnt/av

$ cd /mnt/av

$ ls -l
dr-xr-xr-x  3 root root 512 jan  1  2000 SomeMediaServerSupportingSearch/
dr-xr-xr-x  3 root root 512 jan  1  2000 AnotherMediaServerDeviceName/
-r--r--r--  1 root root 114 jan  1  2000 devices

$ cd SomeMediaServerSupportingSearch

$ ls -l 
dr-xr-xr-x  14 root root 512 jan  1  2000 Music/
dr-xr-xr-x   5 root root 512 jan  1  2000 Pictures/
dr-xr-xr-x   4 root root 512 jan  1  2000 Videos/
dr-xr-xr-x   2 root root 512 Jan  1  2000 _search/

$ ls -l Music/_search
-r--r--r--  1 root root   126 Jan  1  2000 search_capabilities
-r--r--r--  1 root root 12640 Jan  1  2000 search_help.txt

$ ls -l Music/_search/brel
-r--r--r--  1 root root 3151929 jan  1  2000 Amsterdam.mp3
dr-xr-xr-x  4 root root     512 jan  1  2000 Jacques Brel/
-r--r--r--  1 root root 3246781 jan  1  2000 Ne me quitte pas.mp3
dr-xr-xr-x  2 root root     512 Jan  1  2000 _and/
dr-xr-xr-x  2 root root     512 Jan  1  2000 _or/

$ xmms Music/_search/brel/Amsterdam.mp3

$ fusermount -u /mnt/av


Note: full help for searching is available in the "search_help.txt" file,
included in the djmount package. This file is also available at run-time 
in the "_search" directory, if the connected UPnP device supports searching.


## **Building and Installation**

djmount has been built and tested on various Linux distro (MandrakeLinux 10.1,
GeeXboX, Debian sarge or sid, Ubuntu 5.10, Mandriva 2006.0 ...), which include
various Linux kernels (e.g. 2.6.14), gcc (e.g. 3.4.1, 4.0.3) and libc
(e.g. glibc-2.3.5, uClibc 0.9.28).
Different versions of FUSE are also supported (e.g. 2.2.1, 2.4, 2.5)


A) Basic build instruction:

    1) Prerequisites for compilation:

    * the FUSE package : http://fuse.sourceforge.net/ 

    2.1) Use 'configure' and 'make' in the top directory to compile if using the release package.
        Example :
	        ./configure
	        make
    2.2) Use 'bootstrap', 'configure' and 'make' in the top directory to compile if using the source code: 
        Example :
            ./bootstrap
            ./configure
            make
    
    3) if you want to install djmount on your system, run :
	    sudo make install

    or to strip the resulting executable :
	    make install-strip


B) Advanced build instruction:

    "configure" as a few options to customise djmount: see --help option.
    In particular,
	
    --disable-debug             extra debugging code [default=enabled]
    --with-fuse-prefix=DIR      search for fuse in DIR/include and DIR/lib
    --with-libiconv-prefix=DIR  search for libiconv in DIR/include and DIR/lib
    --with-external-talloc      use external talloc library (not recommended)
                              [default = use internal bundled library]
    --with-talloc-prefix=DIR    search for talloc in DIR/include and DIR/lib
    --with-external-libupnp     use external libupnp library (at least 1.3.1)
    [default = use internal bundled library]
    --with-libupnp-prefix=DIR   search for libupnp in DIR/include and DIR/lib

    configure with also checks the following environment variables in
    case there is a custom installation (see also configure --help):
	    FUSE_CFLAGS, FUSE_LIBS, 
	TALLOC_CFLAGS, TALLOC_LIBS, 
	LIBUPNP_CFLAGS, LIBUPNP_LIBS.

    Examples:
	    ./configure --with-external-talloc --with-talloc-prefix=/opt/local
	TALLOC_CFLAGS='-I/opt/include' ./configure --with-external-talloc

    Note: djmount requires the patches included in the bundled libupnp library :
    version 1.2.1a alone is not sufficient. If using an external libupnp 
    installation, it must be version 1.3.1. Version 1.4 (as available from 
    http://www.libupnp.org/ or http://sf.net/projects/pupnp/ ) has *not* 
    been tested with djmount.


## **Usage** 

1) as root : load the FUSE kernel module

	modprobe fuse

2) To run, simply use the 'djmount' executable
   (no extra file is needed).
   The FUSE mountpoint is a required argument. For example:

	djmount /mnt/upnp

3) when finished, unmount the mountpoint (see details in FUSE documentation):

	fusermount -u /mnt/upnp

4) Options :
   see "djmount --help" for the complete list of options.
   A useful option is "-o" which can set mount options, in particular:
 
   "-o iocharset=<charset>" for proper encoding of filenames, in case djmount 
   has not autodetected your settings (which should be the default).
   Example :
	djmount -o iocharset=iso-8859-15 /mnt/upnp

   "-o playlists" to render all Audio or Video files as playlists (.m3u or 
   .ram), which contains an URL for the file. In this mode, only the address 
   of the file is exported through djmount ; the actual content is streamed 
   through HTTP when the playlist is accessed by your favorite media player.
   This mode was the only mode possible for djmount before version 0.50.

   "-o search_history=<size>" to set the maximum number of remembered searches
   (see "djmount --help" for the default number). Set to 0 to disable searching
   completely (no "_search" directory will be displayed, even if supported by 
   the connected device).


## **Known Compatible Devices**

djmount has been tested successfully with the following UPnP AV 
Devices / Media Servers. Although djmount should work with other 
UPnP AV compliant devices, help is needed to test on additional devices.


* TwonkyVision UPnP Music Server ( http://www.twonkyvision.de )
  versions 2.7.2, 2.9.1, 3.0 and 3.1 for Linux are ok

* GMediaServer on Linux ( http://www.gnu.org/software/gmediaserver/ )
  versions 0.7.0 and 0.9.0 (version 0.8.0 not ok)

* Ahead Nero MediaHome Server ( http://www.nero.com/en/Nero_MediaHome.html )
  included in Nero ultra 6.6

* Microsoft Windows Media Connect 
  ( http://www.microsoft.com/windows/windowsmedia/devices/wmconnect/ )
  requires Windows XP Service Pack 2 (SP2) and .NET FrameWork 1.1. 

* GeeXboX uShare on Linux ( http://ushare.geexbox.org/ )
  versions 0.9.3 to 0.9.7

* AV Media Server in Intel Tools for UPnP Technologies (.NET), 
  ( http://www.intel.com/cd/ids/developer/asmo-na/eng/downloads/upnp/tools/index.htm )
  version 1.0.1768.24080 (Build 1768)

* Nokia N93 phone


This page describes how to share A/V content with some of the above servers :
 http://www.geexbox.org/wiki/index.php/Accessing_to_UPnP_Contents


## **Troubleshooting**

* if djmount refuses to start, make sure that the FUSE kernel module has
  been loaded before running djmount (try 'modprobe fuse' as root).

* if djmount refuses to start, in particular with UPnP error -208 (socket 
  error), make sure that there is a multicast route set for the default
  network interface. This should be done automatically on recent distributions,
  else issue this command (where 'eth0' is the default interface) :
	route add -net 239.0.0.0 netmask 255.0.0.0 dev eth0
  or	route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0

* if your UPnP Media Server is behind a closed firewall, it won't be 
  visible in djmount. Therefore, if there is a firewall on the machine
  where you are running your media server, you have to open the necessary
  ports in this firewall. Some media servers can do it automatically 
  (e.g. Windows Media Connect on Windows XP), most of them don't do it 
  (e.g. AV Media Server in Intel Tools).

* currently, files larger than 2 Gb can not be displayed correctly : as a 
  workaround, they are always listed inside "playlists".

* in some distributions (e.g. Debian Sarge), djmount (and more generally, 
  FUSE-based file systems) work fine from the command line, but is unbrowsable
  by Nautilus (Gnome) or Konqueror (KDE) : clicking on a directory causes 
  the new browser window to open momentarily, then immediately close, and 
  the directory then disappears from the GUI altogether. 
  The problem is caused by the distro using the older "famd" daemon for file 
  update notification : by default, FUSE doesn't allow root to look at a 
  mounted filesystem (see FUSE documentation). You'll need to add the line :
	 user_allow_other
  to the file "/etc/fuse.conf". Then, you'll need to add the option 
  "-o allow_root" to your mounts.
  Recent distributions (Ubuntu, Mandriva, Fedora, ...) normally don't have 
  this problem : they use the newer "inotify", and doesn't rely on "famd".

* for general problems, try also the FUSE documentation http://fuse.sf.net/ .

* finally, if you still have problems, please report on the djmount forums :
  http://sourceforge.net/forum/?group_id=142039


## **Implementation**

This project uses the following main libraries :

* the FUSE package ( http://fuse.sourceforge.net/ ), 

* the Linux SDK for UPnP Devices (libupnp), initially created by Intel:
  http://upnp.sourceforge.net/ .
  "djmount" is bundled with a copy of this library (in the "libupnp" 
  directory), with some mandatory patches.

* the "talloc" library : http://talloc.samba.org/
  "djmount" is bundled with a copy of this library, for convenience.

* for testing only (test_upnp executable) : "readline" library (optionnal)


The UPnP AV Architecture is described here : 
http://www.upnp.org/standardizeddcps/mediaserver.asp


## **Copyright and Licenses**

djmount is free software :


* "djmount" is (C) Copyright 2005-2006 R�mi Turboult.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


* The "libupnp" directory contains the Linux SDK for UPnP Devices :
  Copyright (c) 2000-2003 Intel Corporation

This software is licensed under the terms of a modified BSD license,
compatible with the GNU GPL : see libupnp/LICENSE file.


* The "talloc" library is Copyright (C) Andrew Tridgell 2004-2005

This software is licensed under the terms of the GNU General Public License.


* The source code of this project may contain files from other projects, 
  and files generated by other projects, including:
  - The GNU Portability Library (C) 2004 Free Software Foundation 
    ( http://www.gnu.org/software/gnulib/ )

Such files are licensed under the terms of the GNU General Public License
or a license compatible with the GNU GPL : see each file for copyright.
