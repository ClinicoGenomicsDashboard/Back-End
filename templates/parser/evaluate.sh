#!/bin/bash

#echo $1 $2
echo $(python evaluate.py "$(java CUIToBoolean $1 $2)")
