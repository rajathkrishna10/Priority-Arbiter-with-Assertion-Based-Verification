# Functional Verification of a 4-Input Fixed Priority Arbiter using SystemVerilog

## Overview

This project implements and verifies a **4-input Fixed Priority Arbiter** using **SystemVerilog**. A complete **self-checking verification environment** is developed with **Assertion-Based Verification (ABV)** to automatically validate the functionality of the arbiter.

The verification environment includes a **Generator, Driver, Monitor, Scoreboard, Reference Model**, and **SystemVerilog Assertions (SVA)** to ensure correct functionality under randomized test scenarios.

---

## Project Objectives

- Design a 4-input Fixed Priority Arbiter.
- Develop a reusable SystemVerilog verification environment.
- Generate randomized request patterns.
- Automatically compare DUT outputs with a reference model.
- Verify the design using SystemVerilog Assertions.
- Detect protocol violations without manual waveform inspection.

---

## Project Architecture

```
                +----------------+
                |   Generator    |
                +--------+-------+
                         |
                    Mailbox
                         |
                +--------v-------+
                |     Driver     |
                +--------+-------+
                         |
                  Virtual Interface
                         |
                +--------v-------+
                |      DUT       |
                | Priority Arbiter|
                +--------+-------+
                         |
                  Virtual Interface
                         |
                +--------v-------+
                |    Monitor     |
                +--------+-------+
                         |
                    Mailbox
                         |
                +--------v-------+
                |   Scoreboard   |
                +----------------+

        Assertions execute in parallel with the DUT.
```

---

## Project Structure

```
├── top.sv
├── priority_arbiter.sv
├── arbiter_assertions.sv
├── interface.sv
├── transaction.sv
├── generator.sv
├── driver.sv
├── monitor.sv
├── scoreboard.sv
├── environment.sv
├── test.sv
└── README.md
```

---

## File Description

| File | Description |
|------|-------------|
| top.sv | Top-level testbench |
| priority_arbiter.sv | RTL implementation of the arbiter |
| arbiter_assertions.sv | SystemVerilog Assertions using bind |
| interface.sv | Interface connecting DUT and verification components |
| transaction.sv | Transaction class |
| generator.sv | Generates randomized requests |
| driver.sv | Drives requests to the DUT |
| monitor.sv | Samples DUT inputs and outputs |
| scoreboard.sv | Compares DUT output with reference model |
| environment.sv | Connects all verification components |
| test.sv | Starts the verification environment |

---

## Arbiter Functionality

The arbiter follows **Fixed Priority Arbitration**.

Priority order:

```
Request 0  >  Request 1  >  Request 2  >  Request 3
```

Example:

| Request | Grant |
|----------|-------|
|0001|0001|
|0010|0010|
|0100|0100|
|1000|1000|
|1011|0001|
|0110|0010|
|1111|0001|
|0000|0000|

Only one requester can receive the grant at any clock cycle.

---

## Verification Components

### Generator
- Creates randomized request transactions.
- Sends transactions to the driver through a mailbox.

### Driver
- Receives transactions.
- Drives requests to the DUT through a virtual interface.
- Applies requests on the negative edge to avoid race conditions.

### Monitor
- Samples DUT inputs and outputs.
- Sends observed transactions to the scoreboard.

### Scoreboard
- Implements the golden reference model.
- Computes expected grant.
- Compares expected and actual outputs.
- Reports PASS or FAIL automatically.

---

## SystemVerilog Assertions

The project implements the following assertions:

### 1. One-Hot Grant

Ensures only one grant is active at a time.

```
0001 ✔
0010 ✔
1000 ✔
0000 ✔
0011 ✖
1111 ✖
```

---

### 2. Grant Implies Request

A grant is issued only if the corresponding request was present.

---

### 3. No Request → No Grant

If no requests are active, no grant should be generated.

---

### 4. Reset Verification

After reset, all grant outputs must be zero.

---

## Verification Flow

```
Generator
      │
      ▼
Mailbox
      │
      ▼
Driver
      │
      ▼
Interface
      │
      ▼
Priority Arbiter (DUT)
      │
      ▼
Monitor
      │
      ▼
Mailbox
      │
      ▼
Scoreboard
      │
      ▼
PASS / FAIL

+
Assertions continuously verify protocol correctness.
```

---

## Simulation

The project can be simulated using:

- EDA Playground
- ModelSim / QuestaSim
- Vivado Simulator
- Xcelium

Waveforms are generated using:

```
$dumpfile("arbiter.vcd");
$dumpvars;
```

---

## Key Features

- Fixed Priority Arbitration
- Self-checking Testbench
- Assertion-Based Verification (ABV)
- Randomized Stimulus Generation
- Mailbox-based Communication
- Virtual Interfaces
- Reference Model
- Automatic PASS/FAIL Reporting
- Race Condition Avoidance
- Modular Verification Environment

---

## Technologies Used

- SystemVerilog
- Assertion-Based Verification (ABV)
- Object-Oriented Programming (OOP)
- Mailboxes
- Virtual Interfaces
- EDA Playground

---

## Learning Outcomes

- RTL Design
- Functional Verification
- SystemVerilog Assertions
- Object-Oriented Verification
- Mailbox Communication
- Virtual Interfaces
- Self-Checking Testbenches
- Race Condition Handling
- Modular Verification Environment

---

## Future Scope

- Functional Coverage
- Constrained Random Verification
- Universal Verification Methodology (UVM)
- Parameterized Arbiter
- Round Robin Arbiter
- Coverage-Driven Verification

---

## Author

- **Rajath Krishna**
- **Chethan Kumarr**
- **Chiranthan Poojary**

**Department:** Electronics and Communication Engineering (ECE)

**Project Title:** Functional Verification of a 4-Input Fixed Priority Arbiter using Assertion-Based Verification

---

## License

This project is intended for educational and academic purposes.
