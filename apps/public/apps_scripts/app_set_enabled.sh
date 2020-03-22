#!/bin/sh
# $1: package name, $2: yes or no, $3: 0 (if don't need to restart or stop).


# $1: package name.
# return value. 1: have package. 0: no package.
_check_package(){
	package_ready=`ipkg list_installed | grep "$1 "`
	package_ready2=`app_get_field.sh $1 Enabled 1`

	if [ -z "$package_ready" ] && [ -z "$package_ready2" ]; then
		return 0
	else
		return 1
	fi
}


tcapi set Apps_Entry apps_state_enable 0 # INITIALIZING
if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: app_set_enabled.sh <Package name> <yes|no>"
	tcapi set Apps_Entry apps_state_error 1
	exit 1
fi

if [ "$2" != "yes" ] && [ "$2" != "no" ]; then
	echo "Usage: app_set_enabled.sh <Package name> <yes|no>"
	tcapi set Apps_Entry apps_state_error 1
	exit 1
fi

pkg_control_file=
_check_package $1
if [ "$?" = "0" ]; then
	echo "The \"$1\" is not installed yet!"
	tcapi set Apps_Entry apps_state_error 8
	exit 1
else
	pkg_control_file=/opt/lib/ipkg/info/$1.control
fi


tcapi set Apps_Entry apps_state_enable 1 # SETTING
orig_value=`app_get_field.sh $1 Enabled 1`
if [ "$orig_value" = "$2" ]; then
	echo "The field(Enabled) was set \"$2\" already."
else
	Field_enabled=`grep "Enabled: " "$pkg_control_file"`

	if [ -z "$Field_enabled" ]; then
		sed -i '$a Enabled: '$2 $pkg_control_file
	else
		sed -i 's/Enabled: .*$/Enabled: '$2'/g' $pkg_control_file
	fi
fi

if [ "$3" != "0" ]; then
	if [ "$2" = "yes" ]; then
		echo "Restarting the package..."
		app_init_run.sh $1 restart
	else
		echo "Stop the package..."
		app_init_run.sh $1 stop
	fi
else
	if [ "$2" = "yes" ]; then
		echo "Skip to restart the package!"
	else
		echo "Skip to stop the package!"
	fi
fi


tcapi set Apps_Entry apps_state_enable 2 # FINISHED
