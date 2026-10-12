# AXI4-Lite Master-Slave Interface Using Verilog HDL

**RTL Design | FSM-Based Control | Functional Verification | Xilinx Vivado**

##  Project Overview

This project implements a memory-mapped master-slave interface inspired by the AXI4-Lite protocol using Verilog HDL.

The design consists of a master, a slave, and a top-level module. Separate finite state machines (FSMs) control read and write transactions, while the slave contains a 32 × 32-bit register array for storing and retrieving data.

A Verilog testbench is used to exercise basic read and write transactions.

##  Key Features

- Master and slave RTL implementation using Verilog HDL.
- Independent read and write FSMs.
- Five-channel interface: AW, W, B, AR, and R.
- VALID-READY handshaking.
- 32-bit address and data interfaces.
- Memory-mapped register array with 32 registers.
- Read and write completion status signals.
- Testbench for basic read-after-write verification.
- Behavioral simulation using Xilinx Vivado.

##  System Architecture

```text
             AXI4-Lite Master
          +----------------------+
          |                      |
          |     Write FSM        |
          |     Read FSM         |
          |                      |
          +----------+-----------+
                     |
          AW, W, B, AR, R Channels
                     |
          +----------v-----------+
          |                      |
          |    AXI4-Lite Slave   |
          |                      |
          |  32 x 32-bit         |
          |  Register Array      |
          |                      |
          +----------------------+
```

### 1. Master Module

The master initiates read and write transactions.

**Write FSM states:**
- `W_IDLE`: Waits for a write request.
- `W_AW`: Handles the write-address channel.
- `W_W`: Handles the write-data channel.
- `W_B`: Waits for the write response.

**Read FSM states:**
- `R_IDLE`: Waits for a read request.
- `R_AR`: Handles the read-address channel.
- `R_R`: Receives read data and completes the transaction.

### 2. Slave Module

The slave contains a memory-mapped register array with 32 registers, each 32 bits wide.

It captures transaction addresses, accesses the selected register, and generates read and write responses.

### 3. Top-Level Module

The top-level module connects the master and slave and routes the address, data, control, and response signals.

##  AXI Channel Description

| Channel | Purpose |
|---|---|
| AW - Write Address | Transfers the write address |
| W - Write Data | Transfers the write data |
| B - Write Response | Returns the write response |
| AR - Read Address | Transfers the read address |
| R - Read Data | Returns read data and response |

A channel transfer occurs when VALID and READY are both asserted at a rising clock edge.

##  Address Mapping

The slave uses address bits `[6:2]` to select one of 32 registers.

| Address | Register Index |
|---|---:|
| `0x00000000` | 0 |
| `0x00000004` | 1 |
| `0x00000008` | 2 |
| `0x0000000C` | 3 |
| ... | ... |
| `0x0000007C` | 31 |

Each register stores 32 bits of data.

##  Project Structure

```text
AXI4-Lite-Master-Slave-Verilog/
├── Master.v
├── slave.v
├── top.v
├── tb_top.v
└── README.md
```

| File | Description |
|---|---|
| `Master.v` | Master-side read and write FSMs |
| `slave.v` | Slave register array and response logic |
| `top.v` | Interconnection between master and slave |
| `tb_top.v` | Testbench for read and write transactions |
| `README.md` | Project documentation |

##  Verification

The testbench exercises a basic read-after-write scenario.

**Test sequence:**

1. Apply reset.
2. Write data to address `0x00000004`.
3. Use `0xA5A51234` as the write data.
4. Wait for write completion.
5. Read from the same address.
6. Compare the returned data with the expected value.

**Expected result:**

| Parameter | Value |
|---|---|
| Write Address | `0x00000004` |
| Write Data | `0xA5A51234` |
| Read Address | `0x00000004` |
| Expected Read Data | `0xA5A51234` |

The test passes when the returned data matches the expected value. Confirm the actual simulation result before reporting successful verification.

##  Tools and Technologies

- **HDL:** Verilog
- **Design:** RTL Design and FSM-Based Control
- **Protocol:** AXI4-Lite-style Memory-Mapped Interface
- **Simulation:** Xilinx Vivado
- **Verification:** Verilog Testbench

##  Future Improvements

- Improve and verify VALID-READY handshake behavior.
- Test independent AW and W channel timing.
- Add back-to-back transaction testing.
- Test reset during active transactions.
- Add SystemVerilog assertions and functional coverage.
- Introduce randomized read and write testing.
- Verify protocol compliance against the AXI4-Lite specification.

##  Author

**Sivakumar**

M.Tech in VLSI & Embedded Systems  
SVNIT Surat

[GitHub Profile](https://github.com/sivakumarchakarapalli)
