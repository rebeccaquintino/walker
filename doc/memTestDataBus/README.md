<h1 align="center">
    WALKER MEM TEST DATA BUS
    <br>
</h1>

<h4 align="center">Walker memTestDataBus flowchart, FSM, and block diagram.</h4>

## `memTestDataBus()`
This function tests the integrity of the memory data bus by verifying the proper functionality of individual data lines. The procedure involves:
- Writing a series of test patterns (`0x01`, `0x02`, `0x04`, etc.) to a fixed memory location.
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

### Function Operation

The function receives one parameter:
- `address`: Pointer to the memory location to be tested.

It returns:
- `0` if all tests pass.
- A non-zero value representing the first failing test pattern if an error is detected.

### Test Procedure

#### 1️⃣ Walking 1's Test
- Iterates through bit patterns where a single bit is set (`0x01`, `0x02`, `0x04`, etc.).
- Writes each pattern to the specified memory location.
- Reads it back and compares it to the expected value.
- If a mismatch occurs, returns the failing pattern, indicating a stuck or shorted data line.

## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).

## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.

