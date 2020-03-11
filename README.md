# burstCW

Same idea as seen here https://cryptomuseum.com/burst/index.htm

csi bcw.scm "MSG IN CAPS" - writes over burstCW.wav with encoded CW message.

play.sh #SLOWDOWN burstCWSlowed.wav given number of times and play it back

i.e, "./play.sh 85" will slow burstCW.wav 85X in burstCWSlowed.wav and then play the resulting audio back.

To reverse a file:
'csi wavrx.scm file "in.wav" o "out.wav" reverse'



