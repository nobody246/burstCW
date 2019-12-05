#!/bin/sh
sox -t wav burstCW.wav -t wav /tmp/burstCW1.wav speed .11
sox -t wav /tmp/burstCW1.wav -t wav burstCWSlowed$1.wav speed .11 #tempo $1 10 10 10
