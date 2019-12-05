#!/bin/sh
sox -t wav burstCW.wav -t wav /tmp/burstCW1.wav speed .1
sox -t wav /tmp/burstCW1.wav -t wav /tmp/burstCW2.wav speed .1 #tempo $1 10 10 10
sox -t wav /tmp/burstCW2.wav -t wav burstCWSlowed0.1.wav speed .75
rm /tmp/burstCW*wav
