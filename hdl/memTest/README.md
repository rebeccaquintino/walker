<h1 align="center">
    WALKER MEM TEST
    <br>
</h1>

<h4 align="center">Walker memTest source files.</h4>

<p align="center">
    <a href="#memory-test-functions">Memory Test Functions</a> •
    <a href="#releases">Releases</a> •
    <a href="#license">License</a> 
</p>

## Memory Test Functions

### `memTestDataBus()`
This function tests the integrity of the memory data bus by checking for bit failures in the data lines. The procedure involves:
- Writing a series of test patterns (e.g., `0x01`, `0x02`, `0x04`, etc.) to a fixed memory location.
- Reading back the value and verifying it against the expected pattern.
- Identifying stuck-at or shorted data lines if mismatches occur.

This test detects faults such as shorted or open data lines in the memory system.

<p align="center">
    <img width="50%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDataBus/memTestDataBus_flowchart.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDataBus/memTestDataBus_fsm.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDataBus/memTestDataBus_blockdiagram.drawio.png">
</p>

### `memTestAddressBus()`
This function verifies the address bus integrity by ensuring each memory address is uniquely accessible. The test follows these steps:
- Writing a unique pattern to each address within the test range.
- Reading back the stored values to confirm that each location retains its assigned data.
- Checking for address aliasing or mirroring, which indicates faulty address decoding.

Failures in this test suggest potential defects in address routing or decoder logic.

### `memTestDevice()`
This function performs an exhaustive test of the memory cells to verify their ability to reliably store data. The process includes:
- Writing a `0x00` pattern to all memory locations.
- Reading back and confirming all bits are zero.
- Writing a `0xFF` pattern (all ones) to the same locations.
- Reading back to ensure all bits correctly store ones.
- Repeating the process with alternating bit patterns (`0xAA`, `0x55`) to test different configurations.

This comprehensive test detects memory cells that fail to retain stored values over time.

<p align="center">
    <img width="70%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDevice/memTestDevice_flowchart.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDevice/memTestDevice_fsm.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDevice/memTestDevice_blockdiagram.drawio.png">
</p>

## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).

## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.

