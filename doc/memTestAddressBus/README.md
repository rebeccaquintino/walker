<h1 align="center">
    WALKER MEM TEST ADDRESS BUS
    <br>
</h1>

<h4 align="center">Walker memTestAddressBus flowchart, fsm and block diagram.</h4>

### `memTestAddressBus()`
This function tests the integrity of the memory address bus by checking for bit failures in the address lines. The procedure involves:
- Writing a test pattern at various power-of-two offsets.
- Reading back the values to detect aliasing issues.
- Identifying stuck-at or shorted address lines if mismatches occur.

This test detects faults such as shorted or open address lines in the memory system.

<p align="center">
    <img width="50%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestAddressBus/memTestAddressBus_flowchart.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestAddressBus/memTestAddressBus_fsm.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestAddressBus/memTestAddressBus_blockdiagram.drawio.png">
</p>

## Function Operation

The function receives two parameters:
- `baseAddress`: Pointer to the memory region to be tested.
- `nBytes`: Size of the memory region to be tested (in bytes).

It returns:
- `NULL` if all tests pass.
- A pointer to the first problematic address if an error is detected.

## Test Procedure

### 1️⃣ Initial Setup
- The `addressMask` variable is calculated to determine valid addresses within the range.
- `pattern` and `antipattern` are defined as alternating bit patterns (`0xAAAAAAAA` and `0x55555555`), used to detect addressing failures.

### 2️⃣ Testing for Address Bits Stuck HIGH
- Writes `pattern` at memory positions with power-of-two offsets.
- Overwrites the first address (`baseAddress[0]`) with `antipattern`.
- Reads back the previously written addresses:
  - If any address does not contain `pattern`, an aliasing issue is detected (the address was improperly overwritten).
  - Returns the problematic address.

### 3️⃣ Testing for Address Bits Stuck LOW or Shorted
- For each position with a power-of-two offset:
  - Writes `antipattern` and checks if:
    - `baseAddress[0]` changed unexpectedly.
    - Any other address containing `pattern` was incorrectly modified.
  - If an issue is found, returns the faulty address.

## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).

## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.

