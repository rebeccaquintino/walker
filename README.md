<h1 align="center">
    WALKER - FAST ACCURATE MEMORY TEST CODE FOR FPGAs
    <br>
</h1>

<h4 align="center">A implementation on FPGA of an efficient SRAM memory test algorithm for embedded systems.</h4>

<p align="center">
    <a href="#overview">Overview</a> •
    <a href="#development">Development</a> •
    <a href="#releases">Releases</a> •
    <a href="#license">License</a> 
</p>

## Overview
This project implements a memory test in Verilog and VHDL, based on a C-language algorithm available at [Barr Group](https://barrgroup.com/blog/fast-accurate-memory-test-code-c). The original C implementation is an efficient solution for diagnosing failures in embedded systems and ensuring RAM integrity. The VHDL and Verilog adaptation follows the same principles and consists of three main functions, each designed to verify specific aspects of memory operation.


## Development
The project repository is structured into t he following directories:
- `doc/` - Contains project documentation, including diagrams and flowcharts.
- `hdl/` - Contains the HDL source files for implementation.

## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).

## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.




