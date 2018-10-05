#!/bin/sh
#
# Mattermost Backup Script
# By Fabien CRESPEL <fabien@crespel.net>
#

SOURCE_DIR="@{package.data}/"
TARGET_DIR="@{package.backup}/"

if [ -d "$SOURCE_DIR" -a -d "$TARGET_DIR" ]; then
	rsync -rthvzl --delete "$SOURCE_DIR" "$TARGET_DIR"
fi
