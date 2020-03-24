# burstCW

Same idea as seen here https://cryptomuseum.com/burst/index.htm

csi bcw.scm "AlPhAnUmErIc test StRiNg 012345678" - writes over burstCW.wav with encoded CW message.

play.sh # OF TIMES TO SLOWDOWN 

slows down burstCWSlowed.wav given number of times and plays it back

i.e, "./play.sh 85" will slow burstCW.wav 85X in burstCWSlowed.wav and then play the resulting audio back.

To reverse a file:
'csi wavrx.scm file "in.wav" o "out.wav" reverse'



wavrx.scm file in.wav o out.wav [slow (# of times to slow sound)] [reverse]
