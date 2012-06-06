Author: Joshua Abraham



Requirements:

1) Matlab + Image Processing toolkit.
2) FVC2002 database (can download from fvc2002 competition site: http://bias.csr.unibo.it/fvc2002/).


How to Run:

Firstly, extract the zip file and add the resulting
folder (sc_minutia) to your matlab folder path.

Secondly, the templates for each fingerprint have to be
created. The path of the directory must be set to the
correct location in 'main.m' and 'extract_db.m'.


The templates can now be created with the following commands:

    START=1; FINISH=800; extract_db

START and FINISH variables are used to define which
fingerprints of the 800 in the FVC2002 DB1_A database
get their features extracted into template files. These
template files are required for matching to occur (next step).

NOTE: this is a long process (up to 5 hours on a notebook).


Once this is done, matching can be performed with:

    BASE_IMG=''; main

This again is a long process. Genuine results are stored in
an array called RES_G, whereas imposters are stored in 
array called RES_B.

You can stop this process anytime (Ctrl-C) to plot the ROC curve.
The ROC curve can then be plotted with 

    roc(RES_B, RES_G)

You can then continue the process simply with

    main


Please contact me for any more information at
algorithm007@hotmail.com.




