#! /bin/bash

awk '{ if ($7 < 0) $1 = -$7; print }' polar.dat > polar_modulo.dat
