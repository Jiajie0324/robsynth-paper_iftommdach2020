# Dimensional Synthesis of Parallel Robots: Unified Kinematics and Dynamics using Full Kinematic Constraints

Authors:

Moritz Schappler, Prof. Dr.-Ing. Tobias Ortmaier

This code is supplemental material to the following submission to IFToMM D-A-CH Konferenz 2020:

```bib
@Conference{SchapplerOrt2020,
  author    = {Schappler, Moritz and Ortmaier, Tobias},
  title     = {Dimensional Synthesis of Parallel Robots: Unified Kinematics and Dynamics using Full Kinematic Constraints},
  booktitle = {6. IFToMM D-A-CH Konferenz 2020},
  year      = {2019},
  month     = {February},
  doi       = {10.17185/duepublico/71211},
}
```

## Abstract

A variety of different structures for parallel kinematic machines (PKM) have been found by means of systematic structural synthesis.
To find the structure that is suited best for a specific task, an efficient and generic selection method is necessary.
For simple structures with multi-degree-of-freedom joints like the Gough-Stewart robot, methods for modeling and dimensional optimization are well established.
Less methods are available for more complex structures with single-degree-of-freedom joints.
This contribution combines general approaches for the modeling of the kinematics and dynamics of parallel robots to obtain an efficient dimensional synthesis of PKM.

## Contents

This repository contains Matlab scripts and Latex code to reproduce all figures of the paper.

## Useage

1. To reproduce the results, first the dimensional synthesis has to be performed by running the Matlab script `config_dimsynth/cds_example_3T3R_PKM_wiederholbarkeit.m`.
2. The results have to be post-processed by the script `berechnungen/results_repeat_evals.m`, where the table `all_results.csv` is created.
3. The single Figures of the paper based on the newly created data can be generated with the Matlab scripts in `langfassung/Bilder`. The scripts have to be modified according to the chosen name of the optimization.

## Prerequisites

For the optimization and the figure generation to work, the following steps have to be performed:

1. Install Matlab with global optimization toolbox (tested with R2019a)
2. Set up the Matlab mex compiler, if not already done
3. Download Matlab dependencies for the toolchain of dimensional synthesis:
  * https://github.com/SchapplM/robotics-toolbox (tested with rev. bcb2e77; 2020-02-15)
  * https://github.com/SchapplM/robsynth-serroblib (tested with rev. 03793751f; 2020-02-15)
  * https://github.com/SchapplM/robsynth-parroblib (tested with rev. 0bc0de4; 2020-02-15)
  * https://github.com/SchapplM/robsynth-structdimsynth (tested with rev. 65592dc; 2020-02-15)
  * https://github.com/SchapplM/robsynth-modelgen (tested with rev. 0f11fd8; 2020-02-15)
  * https://github.com/SchapplM/matlab_toolbox (tested with rev. 366f149; 2020-02-15)
  * https://github.com/SchapplM/robotics-dep-geometry (tested with rev. 8bbd334; 2020-02-15)
  * https://github.com/SchapplM/robotics-dep-traj (tested with rev. 41ceefd; 2020-02-15)
  * https://github.com/SchapplM/robotics-dep-ext (tested with rev. 0b45dcc; 2020-02-15)
4. Set up the toolboxes to work and modify the following files according to the instructions
  * robsynth-serroblib/maplerepo_path.m.template (has to link to robsynth-modelgen)
  * robsynth-modelgen/robotics_repo_path.template (has to link to robsynth-robotics_toolbox)
5. Run the path initialization scripts (`..._path_init.m`) of all downloaded software repos in Matlab. Put the run commands in the startup.m file of Matlab for easier use.

