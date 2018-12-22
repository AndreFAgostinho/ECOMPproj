# README #

## What is this repository for? ##

The repository contains the EComp project for André Agostinho and Micaela
Serôdio.

The repository was started from the repository in https://bitbucket.org/jjts/picoversat/

## Repository organization

The _Code/_ directory contains all the HDL code and assembly code for the PicoVersat
FPGA implementation.

In _Code/rtl_ resides all HDL code written in Verilog. Also contains _xtop_tb.v_
which is a testbench for the calculator that simulates a multiplication. The
simulation must run for at least 25 ms.

In _Code/tests/calculator_ resides the final code for the calculator.

The remaining directories in the tests/ directory were used to test single features
of the calculator. It is most likely that they do not work with the current
version of the HDL.

In _ISE/_ resides a Xilinx ISE project file. It is __not recommend__ to be used as
there are hardcoded paths which created warning during synthesis and
implementation. It is __recommended__ that a blank ISE project is created and all
the files in _Code/rtl_ and _Code/xilinx/14.7/picoversat/_ are added to the project.


## How do I get set up? ##

* Install Python (tested in 2.7)
* Install Icarus Verilog (download a stable version from http://iverilog.icarus.com)
* Install the picoVersat assembler

```
    cd tools
    make [install]
```

* How to run tests

``` bash
cd tests
cd {testname}
make
```
