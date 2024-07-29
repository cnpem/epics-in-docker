#!/bin/sh
#
# Configure container filesystem so that single UID restriction is satisfied,
# making ignore_chown_errors=True storage configuration work properly.

echo "APT::Sandbox::User \"root\";" > /etc/apt/apt.conf.d/90-disable-sandbox.conf
