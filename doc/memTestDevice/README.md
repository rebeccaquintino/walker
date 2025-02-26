<h1 align="center">
    WALKER MEM TEST DEVICE
    <br>
</h1>

<h4 align="center">Walker memTestDevice flowchart, fsm and block diagram.</h4>

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

