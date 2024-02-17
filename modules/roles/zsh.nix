{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.eza
    pkgs.fzf
    pkgs.grc
    pkgs.mtr
    pkgs.neofetch
    pkgs.pydf
    pkgs.rsync
  ];

  programs.zsh = { 
    enable = true;
    histSize = 999999;
    interactiveShellInit = ''


export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_AUTOSTART_ONCE=true
export ZSH_TMUX_AUTOCONNECT=true
export ZSH_TMUX_AUTOQUIT=true

OSNAME=`uname`
EDPREF="nano" # preferred editor binary
BAR20="--------------------"
BAR80="--------------------------------------------------------------------------------"

#-- Block: chassis-drive-info()
#-- Purpose: generate an info report about all connected disks
#--------------------------------------------------------------------------------------------------#
function chassis-drive-info() {
    if [ "$OSNAME" = "Linux" ]; then
        ## This method will index ONLY physical based drives
        TMPFILE=`mktemp`
        for each in `ls /dev/disk/by-path/ | grep -v part | grep phy | sort`; do readlink /dev/disk/by-path/$each | awk -F\/ '{print $3}' >> $TMPFILE; done
        DEVLIST=`cat $TMPFILE | sort`

        echo $DEVLIST

        for DEV in $DEVLIST; do
            WWN="wwn-`udevadm info -n /dev/$DEV | grep -w ID_WWN | awk -F\= '{print $2}'`"
            DEVPATH=`udevadm info -n /dev/$DEV | grep -w DEVPATH | awk -F\= '{print $2}'`
            MODEL=`udevadm info -n /dev/$DEV | grep -w ID_MODEL | grep -v ENC | awk -F\= '{print $2}'`
            SERIAL=`udevadm info -n /dev/$DEV | grep -i serial_short | awk -F\= '{print $2}'`
            LUN=`udevadm info -n /dev/$DEV | grep -w ID_SAS_PATH | awk -F\= '{print $2}'`
            CONTROLLER=`udevadm info -n /dev/$DEV | grep -w ID_SAS_PATH | awk -F\= '{print $2}' | awk -F- '{print $2}'`
            BAY=`udevadm info -n /dev/$DEV | grep -w ID_SAS_PATH | awk -F\= '{print $2}' | awk -F: '{print $3}' | awk -F- '{print $3}' | sed 's/phy//'`
            let BAY=$BAY+1
            SIZE=`fdisk -l -l 2>&1 | grep "^Disk" | cut -f 1 -d ',' | cut -f 3- -d '/' | grep $DEV | awk '{print $2}' | awk -F. '{print $1}'`
            LOCATION="$CONTROLLER:$BAY"
            echo "#-----------------------------------------------------------------------------------------------------------------------#"
            echo " DEVPATH: $DEVPATH"
            echo " WWN: $WWN"
            echo " DEV: $DEV"
            echo " MODEL: $MODEL"
            echo " SIZE: $SIZE"
            echo " SERIAL: $SERIAL"
            echo " LUN: $LUN"
            echo " LOCATION: $CONTROLLER, BAY: $BAY"
            printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $DEVPATH $WWN $DEV $MODEL $SIZE $SERIAL $LUN $LOCATION >> $TMPFILE.csv
        done

        echo -e "#-----------------------------------------------------------------------------------------------------------------------#\n\n"
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" DEVPATH WWN DEV MODEL SIZE SERIAL LUN LOCATION
        cat $TMPFILE.csv
        rm -f $TMPFILE $TMPFILE.csv

    else
        echo "This function is only available on Linux systems."
    fi
}

#-- Block: connections.byIP
#-- Purpose: Connection summary report from netstat, sorted by IP
#--------------------------------------------------------------------------------------------------#
function connections.byIP() {
    echo "Active Connections by IP"
    echo "------------------------"
    printf "%s\t%s\n" "Count" "Address"
    netstat -an | awk '{print $5}' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" | egrep -v "(`for i in \`ip addr | grep inet | cut -d/ -f1 | awk '{print $2}'\`;do echo -n "$i|"| sed 's/\./\\\./g;';done`127\.|0\.0\.0)" | sort -n | uniq -c | sort -n | awk '{print $1 "\t" $2}'
}

#-- Block: connections.byPort
#-- Purpose: Connection summary report from netstat, sorted by desired port
#--------------------------------------------------------------------------------------------------#
function connections.byPort() {
    echo -n "Show connections per which port#: "
    read PORT
    echo $PORT
    re='^[0-9]+$'
    if ! [[ $PORT =~ $re ]] ; then
        echo "Error: Not a number" >&2
    else
        echo "Active Connections by Port"
        echo "--------------------------"
        printf "%s\t%s\n" "Count" "Address"
        ss -tan "sport = :$PORT" | awk '{print $(NF)" "$(NF-1)}' | sed 's/:[^ ]*//g' | sort | uniq -c
    fi
}

#-- Block: copy_ssh_key()
#-- Purpose: copy SSH key to server, create .ssh directory if not exist
#--------------------------------------------------------------------------------------------------#
function copy_ssh_key() {
    if test -z $1; then
        echo "ARG1 missing, please specify a hostname or ip address for ARG1."
    else
        sshhost=$1
        if test -z $2;	then
            echo "ARG2 missing, please specifiy a user for ARG2"
        else
            sshuser=$2
            key=`cat $HOME/.ssh/id_dsa.pub`
            ssh $sshuser@$sshhost "mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh && echo \"$key\" >> $HOME/.ssh/authorized_keys && chmod 644 $HOME/.ssh/authorized_keys"
            if [ $? = "0" ]; then
                echo "Key copy successful"
                echo "Process completed!"
            else
                echo "Key copy failed."
                echo "Process failure."
            fi
        fi
    fi
}

function crontab_all_list() { for user in $(cut -f1 -d: /etc/passwd); do sudo crontab -u $user -l; done }

##- Block: netinfo-nic-ident()
##-- Purpose: Physically identify a NIC by flashing its LEDs
#--------------------------------------------------------------------------------------------------#
function netinfo-nic-ident() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 NIC";
    else
        ethtool --identify $1
    fi
}

#-- Block: system_info()
#-- Purpose: prints a bunch of system info
#--------------------------------------------------------------------------------------------------#
function system_info() {
    TASK="[system_info]"

    echo "$TASK kernel info"
    echo $BAR80
    uname -a
    echo 

    if [ "$OSNAME" = "Darwin" ]; then system_profiler; fi
    if [ "$OSNAME" = "Linux" ]; then
        echo "$TASK hardware summary"
        echo $BAR80
        sudo lshw -class system -class processor -class memory -class network -class storage 2>/dev/null
        echo 

        echo "$TASK storage details"
        echo $BAR80
        lsblk -a
        lsblk -t
        echo 

        echo "$TASK memory usage info"
        echo $BAR80
        memusage.all
        echo $BAR80
        memusage.user
        echo 
        meminfo
        echo 
    fi
}

neofetch
    '';
    shellAliases = {
      "400" = "chmod 400";
      "600" = "chmod 600";
      "644" = "chmod 644";
      "700" = "chmod 700";
      "750" = "chmod 750";
      "755" = "chmod 755";
      "777" = "chmod 777";
      "chrony-stats" = "chronyc tracking; chronyc sources; chronyc sourcestats -v";
      "kk" = "ll";
      "ll" = "eza --no-permissions --octal-permissions -1a@lFhg --color-scale --color=always --sort name";
      "ls" = "eza --no-permissions --octal-permissions -1a@lFhg --color-scale --color=always --sort name";
      "mtr" = "mtr -bezo LDRSNBAJMX";
      "scp" = "scp -rp";
      "screen" = "screen -L";
      "su" = "su -m -s";
      "wget" = "wget --server-response --progress=bar";
      "update" = "doas nixos-rebuild switch";

      "blkid" = "grc -es --colour=auto blkid";
      "configure" = "grc -es --colour=auto ./configure";
      "diff" = "grc -es --colour=auto diff";
      "dig" = "grc -es --colour=auto dig";
      "du" = "grc -es --colour=auto du";
      "env" = "env | sort | grcat conf.env";
      "free" = "grc -es --colour=auto free";
      "fdisk" = "grc -es --colour=auto fdisk";
      "findmnt" = "grc -es --colour=auto findmnt";
      "head" = "grc -es --colour=auto head";
      "make" = "grc -es --colour=auto make";
      "mount" = "grc -es --colour=auto mount";
      "id" = "grc -es --colour=auto id";
      "ifconfig" = "grc -es --colour=auto ifconfig";
      "ip" = "grc -es --colour=auto ip";
      "iptables" = "grc -es --colour=auto iptables";
      "ld" = "grc -es --colour=auto ld";
      "lsof" = "grc -es --colour=auto lsof";
      "lsblk" = "grc -es --colour=auto lsblk";
      "lsmod" = "grc -es --colour=auto lsmod";
      "lspci" = "grc -es --colour=auto lspci";
      "lsusb" = "grc -es --colour=auto lsusb";
      "netstat" = "grc -es --colour=auto netstat";
      "ping" = "grc -es --colour=auto ping";
      "ps" = "grc -es --colour=auto ps";
      "tail" = "grc -es --colour=auto tail";
      "traceroute" = "grc -es --colour=auto traceroute";
      "traceroute6" = "grc -es --colour=auto traceroute6";

      "df" = "pydf";
      "egrep" = "egrep --color=auto";
      "fgrep" = "fgrep --color=auto";
      "grep" = "grep --color=auto";
      "iostat-ext" = "iostat -d 2 -ckNhx";
      "iostat-tps" = "iostat -d 2 -ckNh";
      "listening" = "netstat -luntpx";
      "monitor.iops" = "iostat -cdmtNh -d 2";
      "monitor.sys" = "while true; do date && vmstat 1 60 && sleep 1; done";
      "mv" = "mv -i";
      "openports" = "netstat -nape --inet";
      "rm" = "rm -i";
      "rmdir" = "rm -rfi";
      "rsync" = "rsync --partial --progress";
    };
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "command-not-found" "common-aliases" "cp" "dirhistory" "encode64" "git" "gitignore" "git-extras" "history" "jsontools" "per-directory-history" "pip" "poetry" "poetry-env" "profiles" "pylint" "python" "redis-cli" "screen" "sudo" "systemd" "themes" "tmux" "urltools" "wd" "zsh-interactive-cd" ];
    theme = "candy";
  };

  users.defaultUserShell = pkgs.zsh;
}
