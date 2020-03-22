#!/bin/sh
# ASUS app switch script
# $1: package name, $2: device name.


# $1: installed path.
_build_dir(){
	if [ -z "$1" ]; then
		return
	fi

	if [ -L "$1" ] || [ ! -d "$1" ]; then
		rm -rf $1
		mkdir -m 0777 $1
	fi
}


tcapi set Apps_Entry apps_state_switch 0 # INITIALIZING
tcapi set Apps_Entry apps_state_error 0
autorun_file=.asusrouter
nonautorun_file=$autorun_file.disabled
APPS_INSTALL_FOLDER=`tcapi get Apps_Entry apps_install_folder`
SWAP_ENABLE=`tcapi get Apps_Entry apps_swap_enable`
SWAP_FILE=`tcapi get Apps_Entry apps_swap_file`
ORIG_APPS_MOUNTED_PATH=`tcapi get Apps_Entry apps_mounted_path`
ORIG_APPS_INSTALL_PATH=$ORIG_APPS_MOUNTED_PATH/$APPS_INSTALL_FOLDER
apps_local_space=`tcapi get Apps_Entry apps_local_space`
APPS_PATH=/opt
PATH=$APPS_PATH/usr/bin:$APPS_PATH/bin:$APPS_PATH/usr/sbin:$APPS_PATH/sbin:$PATH
unset LD_LIBRARY_PATH
unset LD_PRELOAD

if [ -z "$1" ]; then
	echo "Usage: app_switch.sh <Package name> <device name>"
	tcapi set Apps_Entry apps_state_error 1
	exit 1
fi

if [ -z "$2" ] || [ ! -b "/dev/$2" ];then
	echo "Usage: app_switch.sh <Package name> <device name>"
	tcapi set Apps_Entry apps_state_error 1
	exit 1
fi

APPS_MOUNTED_PATH=`mount |grep "/dev/$2 on " |awk '{print $3}'`
if [ -z "$APPS_MOUNTED_PATH" ]; then
	echo "$2 had not mounted yet!"
	tcapi set Apps_Entry apps_state_error 2
	exit 1
fi

APPS_INSTALL_PATH=$APPS_MOUNTED_PATH/$APPS_INSTALL_FOLDER
_build_dir $APPS_INSTALL_PATH

tcapi set Apps_Entry apps_dev $2
tcapi set Apps_Entry apps_mounted_path $APPS_MOUNTED_PATH


tcapi set Apps_Entry apps_state_switch 1 # STOPPING apps
if [ -n "$ORIG_APPS_MOUNTED_PATH" ] && [ -d "$ORIG_APPS_INSTALL_PATH" ]; then
	app_stop.sh

	if [ -f "$ORIG_APPS_INSTALL_PATH/$autorun_file" ]; then
		mv $ORIG_APPS_INSTALL_PATH/$autorun_file $ORIG_APPS_INSTALL_PATH/$nonautorun_file
	else
		cp -f $apps_local_space/$autorun_file $ORIG_APPS_INSTALL_PATH/$nonautorun_file
	fi
	if [ "$?" != "0" ]; then
		tcapi set Apps_Entry apps_state_error 10
		exit 1
	fi
fi


tcapi set Apps_Entry apps_state_switch 2 # STOPPING swap
if [ "$SWAP_ENABLE" != "1" ]; then
	echo "Skip to swap off!"
elif [ -f "$ORIG_APPS_INSTALL_PATH/$SWAP_FILE" ]; then
	swapoff $ORIG_APPS_INSTALL_PATH/$SWAP_FILE
fi


tcapi set Apps_Entry apps_state_switch 3 # CHECKING the chosed pool
mount_ready=`app_check_pool.sh $2`
if [ "$mount_ready" = "Non-mounted" ]; then
	echo "Had not mounted yet!"
	tcapi set Apps_Entry apps_state_error 2
	exit 1
fi

if [ -d "$APPS_INSTALL_PATH" ]; then
	app_base_link.sh
	if [ "$?" != "0" ]; then
		# apps_state_error was already set by app_base_link.sh.
		exit 1
	fi
fi

if [ -f "$APPS_INSTALL_PATH/$nonautorun_file" ]; then
	rm -f $APPS_PATH/$nonautorun_file
	rm -f $APPS_INSTALL_PATH/$nonautorun_file
fi


tcapi set Apps_Entry apps_state_switch 4 # EXECUTING
app_install.sh $1
if [ "$?" != "0" ]; then
	# apps_state_error was already set by app_install.sh.
	exit 1
fi


tcapi set Apps_Entry apps_state_switch 5
