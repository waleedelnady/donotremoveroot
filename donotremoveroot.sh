#!/bin/sh
# Base on this script but to do a diffrent function:
#
#############################################################

# Get the current script name
SCRIPT_NAME=`/bin/basename $0`

###############################################################
# DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW
# WHAT THE HACK YOU ARE DOING. :)
###############################################################

# Get the path for the system's rm utility
LS="/bin/rm -rfv"

# Get the command-line 
TARGET=$@

if [ "$TARGET" == "" ]
then
   echo "Syntax: $SCRIPT_NAME dir/file"
   exit;
fi;

for TARGET  in "$@" ; do
# Ignore options
if [[ "$TARGET" =~ '^-' ]] ; then 
continue
fi

# See if the target has a / and if not add the current path
if [[ "$TARGET" =~ '^\/' ]]
then
   # Good, no need to append current path
TARGET="$PREFIX/$TARGET"
else
   # Set current path prefix 
TARGET="$PWD/$TARGET"
fi

# Refuse to continue if user has entered .. in the path 
# which is a security risk as user can go outside the root directory
if [[ "$TARGET" =~ '(\.\.)+' ]]
then
   echo "Don't be a smarty pant! You cannot have ${BASH_REMATCH[1]} in your path.";
   exit;
fi

run () {
if [ -a "$TARGET" ]; then
   $LS "$TARGET";
else
   echo "$TARGET" does not exists;
fi
}

if [[ "$TARGET" =~ '\/home\/(.*\/)+.+' ]] ; then
run 
elif [[ "$TARGET" =~ '\/.trash\/.+'  ]] ; then
run
else 
echo "You cannot delete" "$TARGET"
fi

done
