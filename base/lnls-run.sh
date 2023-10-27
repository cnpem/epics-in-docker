#!/bin/sh
if [ $# -eq 0 ]; then set ./st.cmd; fi
exec procServ -f -i ^C^D -L - unix:./ioc.sock "$@"
