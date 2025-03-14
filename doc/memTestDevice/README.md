<h1 align="center">
    WALKER MEM TEST DEVICE
    <br>
</h1>

<h4 align="center">Walker memTestDevice flowchart, FSM, and block diagram.</h4>

## `memTestDevice()`
This function tests the integrity of a physical memory device by performing an increment/decrement test over the entire region. Every storage bit in the device is tested as both zero and one. The procedure involves:
- Writing an incremental pattern to the memory region.
- Reading back and verifying the written values.
- Inverting the pattern and performing a second verification.
- Detecting faulty memory locations if mismatches occur.

This test helps identify memory corruption, stuck bits, or addressing issues.

<p align="center">
    <img width="50%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDevice/memTestDevice_flowchart.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDevice/memTestDevice_fsm.drawio.png">
</p>

<p align="center">
    <img width="200%" src="https://raw.githubusercontent.com/rebeccaquintino/walker/dev_doc/doc/memTestDevice/memTestDevice_blockdiagram.drawio.png">
</p>

### Function Operation

The function receives two parameters:
- `baseAddress`: Pointer to the start of the memory region to be tested.
- `nBytes`: Size of the memory region in bytes.

It returns:
- `NULL` if all tests pass.
- A pointer to the first failing memory address if an error is detected.

### Test Procedure

#### 1️⃣ Initial Pattern Write
- Writes an incremental pattern (`0x01`, `0x02`, etc.) to each memory location.

#### 2️⃣ First Verification and Inversion
- Reads back each memory location and verifies correctness.
- Inverts the pattern and writes it back.

#### 3️⃣ Second Verification
- Reads back the inverted pattern and verifies correctness.
- If a mismatch occurs at any stage, returns the faulty memory address.

## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).

## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.

