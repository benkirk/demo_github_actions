#!/usr/bin/env bash

2>/dev/null find /container/ -type -f -name "lib*.a" -print0 |
	xargs -0 rm -fv
