INSTALLING
************************************************

After downloading the folder, unzip the .zip file.
Within that directory you should see the following files:

ztables  - (executable)
ztables.c -  (source code)
Z-Tables.txt  - (txt file containing Z-Tables)
percent stuff.xlsx  - (used to make graphs in addition to lecture notes)

To run the ztables, do the following on a Mac or Linux system:

Click on the magnifying glass (known as spotlight) in the upper right hand corner -> search for “terminal” and select, then click it.

Move the folder you just unzipped onto your desktop.

Click on the black screen called the terminal and type the following commands pressing return at the end of each of line:

cd ~/Desktop/ztables
make ztables
./ztables

You should have successfully executed the program, however you didn’t get to decide what it computed!

Note* If you run “make” and nothing happens, don’t worry! You can still run the program, just you won’t be able to edit it yourself and personalize the code.




USAGE
***********************************************

/************
-ZTABLES

The usage goes like this:
./ztables <flag> <args>

To compute percentages using ztables with different intervals:
./ztables –zt <START> <END> <MEAN> <STDDEV>

Example: To have the program compute problem #2 and #3 execute the following:

Problem #2:
./ztables -zt 140 170 170 20.4


Problem #3
./ztables -zt 160 195 170 20.4



/*****************
-STANDARD DEVIATION

To compute the standard deviation using the new method execute the following command:

./ztables –sd <P><N>

Example:
./ztables –sd 42 80

Is equivalent to: 