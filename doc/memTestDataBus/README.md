<h1 align="center">
    WALKER MEM TEST DATA BUS
    <br>
</h1>

<h4 align="center">Walker memTestDataBus flowchart, fsm and block diagram.</h4>


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

## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).

## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.

