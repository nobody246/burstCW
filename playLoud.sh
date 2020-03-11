#!/bin/sh
csi wavrx.scm file burstCW.wav o burstCWSlowed.wav slow $1;
mplayer -volume 200 burstCWSlowed.wav;
