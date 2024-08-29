This is an implementation of a programmable stopwatch timer in verilog on a Basys 3 board.
There are 4 multiplexed modes corresponding to switches V16 and V17
V16 V17
0    0: Count up from 0
0    1: Count up from external value
1    0: Count down from 99.99 seconds
1    1: Count down from external value

The external value is obtained from switches [T3,V2,W13,W14] (tens of seconds) and [V15, W15, W17, W16] (ones of seconds) converted from binary to decimal.

Buttons T18 and T17 are for starting and resetting the timer respectively.

DEMONSTRATION: https://drive.google.com/file/d/1KuSB5cLLws3f8RGiZuGE9DHFhun7v2Ss/view?usp=sharing
