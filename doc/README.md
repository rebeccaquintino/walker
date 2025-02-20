<h1 align="center">
    WALKER DOCUMENTATION
    <br>
</h1>

<h4 align="center">Walker documentation project (flowcharts, FSMs and block diagrams).</h4>

<p align="center">
    <a href="#documentation">Documentation</a> •
    <a href="#releases">Releases</a> •
    <a href="#license">License</a> •
</p>


## Development

The Walker documentation is structured around the following tests:
- `memTest`
- `memTestDevice`
- `memTestAddressBus`
- `memTestDataBus`

Each test is documented with a **flowchart**, a **Finite State Machine (FSM)**, and a **block diagram**.

- The **flowchart** outlines the sequence of operations for each test, serving as the foundation for its implementation.
- The **FSM (Finite State Machine)** represents the step-by-step execution flow, defining different states and transitions based on specific conditions. This ensures that each test runs in an organized and controlled manner.
- The **datapath** consists of the hardware components required for the test, such as registers, multiplexers, and arithmetic units. It defines how these elements interact to perform memory operations.
- The **controller** is responsible for managing the FSM and generating control signals to coordinate actions within the datapath.


## Releases

The latest releases of this project can be found [here](https://github.com/rebeccaquintino/walker/releases).


## License

This project is licensed under the **GNU General Public License v3.0**. For more details, refer to the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file.

