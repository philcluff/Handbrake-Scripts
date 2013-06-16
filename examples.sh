HandBrakeCLI -v -i /dev/sr0 -t 0
HandBrakeCLI -v -i /dev/sr0 -t 1 -o "out/2.mkv"  -4 -m -e x264 -x "b-adapt=2:rc-lookahead=50:ref=6:bframes=8:subme=8:deblock=-1,-1:psy-rd=1|0.15" -q 19 --keep-display-aspect --loose-anamorphic --deinterlace="2:-1:-1:0:1"
