# Android dev
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# other additions to path
export PATH=$PATH:$HOME/scripts

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]];
then
	exec startx
fi
