#!/bin/sh
play burstCW.wav tempo $1 10 10 10
sox -t wav burstCW.wav -t wav burstCWSlowed$1.wav tempo $1 10 10 10
