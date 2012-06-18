% Copy all files in Matlab current directory and type "palmrec" on
% Matlab command window.
%
%
%PALMPRINT RECOGNITION SYSTEM
%
% Palmprint recognition system based on EigenPalms Method.
% The system functions by projecting palmprint images onto a feature space
% that spans the significant variations among known images. The
% significant features are known as "eigenpalms" because they are the
% eigenvectors (principal components) of the set of palmprints.
%
% Palmprint images must be collected into sets: every set (called "class") should
% include a number of images for each person, with some variations in
% positions and in the lighting. When a new input image is read and added
% to the training database, the number of class is required. Otherwise, a new
% input image can be processed and confronted with all classes present in database.
% We choose a number of eigenvectors M' equal to the number of classes (see
% algorithmic details in the cited references). Before start image
% processing first select input image. This image can be succesively added to
% database (training) or, if a database is already present, matched with
% known faces.
%
% The images included are taken from CASIA Palmprint Database, available at
% http://www.cbsr.ia.ac.cn/PalmDatabase.htm
% See the cited references for more informations.
%
% 
% First, select an input image clicking on "Select image".
% Then you can
%   - add this image to database (click on "Add selected image to database"
%   - perform face recognition (click on "Palmprint Recognition" button)
%     Note: If you want to perform palmprint recognition database has to include 
%     at least one image.
%  If you choose to add image to database, a positive integer (palmprint ID) is
%  required. This posivive integer is a progressive number which identifies
%  a palmprint (each palmprint corresponds to a class).
% For example:
%  - run the GUI (type "palmrec" on Matlab command window)
%  - delete database (click on "Delete Database")
%  - add "mike_left_hand_1.jpg" to database ---> the ID has to be 1 since Mike'left hand
%    is the first palmprint you are adding to database
%  - add "mike_left_hand_2.jpg" to database ---> the ID has to be 1 since you have already
%    added a Mike's left palmprint to database
%  - add "paul_left_hand_1.jpg" to database ---> the ID has to be 2 since
%    Paul's left hand is the second palmprint you are adding to database
%  - add "cindy_left_hand_1.jpg" to database ---> the ID has to be 3 since Cindy's hand is
%    the third left palmprint you are adding to database
%  - add "paul_left_hand_2.jpg" to database ---> the ID has to be 2 once again since
%    you have already added Paul's left palmprint to database
%   
% ... and so on! Very simple, isnt't? :)
% 
% The recognition gives as results the ID of nearest person present in
% database. For example if you select image "paul_left_hand_3.jpg" the ID given SHOULD
% be 2: "it should be" because errors are possible.
%
%
% 
% 
% FUNCTIONS
%
% Select image:                                  read the input image
%
% Add selected image to database:                the input image is added to database and will be used for training
%
% Database Info:                                 show informations about the images present in database. Images must
%                                                have the same size. If this is not true you have to resize them.
%
% Palmprint Recognition:                         palprint matching. The selected input image is processed
%
% Delete Database:                               remove database from the current directory
%
% Info:                                          show informations about this software
%
%
% Source code for Palmprint Recognition System:  how to obtain the complete source code
%
% Exit:                                          quit program
%
%
%  References:
%  "Eigenfaces for Recognition", Matthew Turk and Alex Pentlad
%  Journal of Cognitive Neuroscience pp.71-86, March 1991
%  Vision and Modeling Group, The Media Laboratory
%  Massachusetts Institute of Technology.
%  This paper is available at http://www.cs.ucsb.edu/~mturk/Papers/jcn.pdf
%  See also Matthew Turk's homepage http://www.cs.ucsb.edu/~mturk/research.htm
% 
%  "Online Palmprint Identification", David Zhang, Senior Member, IEEE, Wai-Kin Kong, 
%  Member, IEEE, Jane You, Member, IEEE, and Michael Wong, 
%  IEEE TRANSACTIONS ON PATTERN ANALYSIS AND MACHINE INTELLIGENCE, VOL. 25,
%  NO. 9, SEPTEMBER 2003
%
%  CASIA Palmprint Database is available at
%  http://www.cbsr.ia.ac.cn/PalmDatabase.htm
%
%
%
%
%
%
% Luigi Rosa
% Via Centrale 35
% 67042 Civita di Bagno
% L'Aquila - ITALY 
% email  luigi.rosa@tiscali.it
% mobile +39 3207214179
% web site http://www.advancedsourcecode.com
%
%
%