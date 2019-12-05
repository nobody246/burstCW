#!/bin/sh
play burstCW.wav speed $1 #tempo $1 10 10 10
sox -t wav burstCW.wav -t wav burstCWSlowed$1.wav speed $1 #tempo $1 10 10 10
