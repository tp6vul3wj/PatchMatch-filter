Global and Efficient Self-Similarity for Object Classification and Detection
============================================================================

Thomas Deselaers and Vittorio Ferrari
{deselaers, ferrari}@vision.ee.ethz.ch

This software was developed under Linux with Matlab 7.10 on a 64 bit machine.
There is no guarantee that it will run on other operating systems or Matlab versions
(though it probably will) 

As a sub-component, this software uses a k-means implementation from the 
Visual Geometry Group of the University of Oxford 
http://www.robots.ox.ac.uk/~vgg/
We thank its authors for permission to redistribute their code as part
of this release.


Introduction
------------

Welcome to this release of the global selfsimilarity [1]. 

From the methods in [1] this code allows to compute self-similarity
hypercubes (SSHs). These SSHs can be obtained from a prototype
assignment map M in two ways:

The first method extracts an SSH from a full image.

The second method extracts multiple SSHs from a single image jointly. 



Quick start
-----------

Let <dir> be the directory where you uncompressed the release archive.

Start matlab and go to <dir>

1. run make to compile the necessary MEX files
2. run td_selfim_demo to extract SSHs from the delivered example image

td_selfsim_demo does the following:
 - set the path to include the support functions
 - load the example image
 - setup the self-similarity object which encapsulates most self-similarity functionality
 - create an image-specific codebook (if multiple images are provided a dataset specific codebook is computed)
 - create the prototype assignment map M (and display it)
 - compute a single SSH for the full image and display it
 - generate some random windows in that image
 - compute the SSHs corresponding to these windows



Documentation
-------------

Most matlab functions should offer a help when asking for it. 

Nonetheless, a small description of what the files contain

* td_fastSelfSim.m
  An object that encapsulates most self-similarity functions and settings.

  - td_fastSelfSim()
    * standard constructor

  - getClustersFromPixels()
    * given a cell array of images, compute a prototype codebook

  - quantise
    * compute the prototype assignment map for an image. 
 
  - getOneSSH
    * compute a single SSH for an image given its prototype assignment map

  - getManySSH
    * compute a bunch of SSHs for an image given its prototype assignment map
     
    NOTE: this routine is much faster than getOneSSH if many SSHs are
    extracted. However, it needs a lot of memory and requires some
    time for preparation. This routine is the basis for a sliding
    window object detector.


 * td_visualizeSSH
   show an SSH as a matlab figure
  
 * all the other files contain functions that are used within td_fastSelfSim 
   and are not meant to be user serviceable


Support 
-------

For any query/suggestion/complaint or simply to say you like/use this
software, just drop us an email:

deselaers@vision.ee.ethz.ch (please contact this address first)
ferrari@vision.ee.ethz.ch

We wish you a good time using this software

Thomas Deselaers and Vittorio Ferrari

