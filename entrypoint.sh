#!/bin/bash
to_add="$(cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg)bin"
export PATH=$PATH:$to_add
exec $@
