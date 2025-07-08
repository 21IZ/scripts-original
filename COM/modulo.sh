#! /bin/bash

awk '{ if ($1 < 0) $1 = -$1; print }' COM_distance.agr > COM_distance_positivos.agr
