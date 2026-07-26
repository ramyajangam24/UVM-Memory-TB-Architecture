# UVM-Memory-TB-Architecture
This repository contains a structured Universal Verification Methodology (UVM) testbench designed to verify a configurable synchronous Memory Core (`memory.v`).
## 🏗️ Testbench Architecture

The verification environment follows the standard UVM hierarchy:

```text
├── tb.sv (Top-level HDL Wrapper & Clock/Reset Generation)
└── test.sv (UVM Test Layer)
    └── mem_env.sv (Environment Container)
        ├── mem_sbd.sv (Scoreboard / Mirror Memory Checker)
        └── mem_agent.sv (Agent Container)
            ├── mem_cov.sv (Functional Coverage Monitor)
            ├── mem_mon.sv (Monitor)
            ├── mem_driver.sv (Driver pin-wiggling)
            └── mem_sqr.sv (Sequencer)
```

### File Compilation Order
Files are included and compiled in this exact sequence to handle standard UVM compilation dependencies:
1. **Packages & Data:** Macros, shared configurations (`mem_common.sv`), transactions (`mem_tx.sv`), and interfaces (`mem_intrf.sv`).
2. **DUT:** Memory hardware design (`memory.v`).
3. **Sequences:** Transaction generation scenarios (`mem_sequence.sv`).
4. **Components:** Sequencer, Driver, Monitor, and Coverage modules.
5. **Containers:** Agent, Scoreboard, and Environment wrappers.
6. **Top Modules:** UVM Test definitions (`test.sv`) and the Top-level testbench module (`tb.sv`).

---

## 🧠 Design Under Test (DUT) Specifications

The `memory` module is a parameterized synchronous memory with a handshaking interface:
* **Control Signals:** `clk`, `res` (Active-High Reset), `valid`, `ready`, `wr_rd` (1 = Write, 0 = Read).
* **Buses:** `addr` (Address), `wdata` (Write Data), `rdata` (Read Data).
* **Parameters:** Configured globally via macros (`ADDR_WIDTH`, `WIDTH`, `DEPTH`).

### Protocol Behavior
* **Reset:** When `res == 1`, the memory array, `rdata`, and `ready` outputs are synchronously cleared to `0`.
* **Handshaking:** Transactions occur when the testbench asserts `valid == 1`. The DUT acknowledges by driving `ready = 1` on the same clock cycle.
* **Operations:** 
  * If `wr_rd == 1`, data on `wdata` is written to `mem[addr]`.
  * If `wr_rd == 0`, data from `mem[addr]` is driven onto `rdata`.

---

## 🧪 Supported Test Sequences

The `mem_sequence.sv` file implements an advanced hierarchy utilizing **Sequence Layering** and the `uvm_config_db` infrastructure:

* **`seq_1wr` / `seq_1rd`:** Executes a single random write or read transaction to a targeted address (`addr_t1`).
* **`seq_1wr_1rd`:** Layered sequence that calls `seq_1wr` and `seq_1rd` back-to-back on a matching address (`addr_t`).
* **`seq_5wr`:** Loops exactly 5 times to execute back-to-back write transactions.
* **`seq_5wr_5rd`:** Writes to 5 addresses, stores the history inside a queue (`txQ`), and pops them sequentially to read back and verify the identical locations.
* **`seq_nwr` / `seq_nrd`:** Parameterized atomic components that pull a dynamic iteration count variable via `uvm_config_db` to run `N` matching consecutive writes or reads.
* **`seq_nwr_nrd` (Advanced Layering):** A complex sequence layer that pulls a global `count_l` variable loop limit. Inside its loop, it randomizes a target address, dynamically overrides its child context count fields to `1` using `uvm_config_db#(int)::set(null, "*", "count", 1)`, and executes the `seq_nwr` and `seq_nrd` sequences back-to-back for dynamic write-read pair coverage.

---

## 🧪 Available UVM Tests

All tests inherit from a base `mem_test` class, which prints the **UVM Factory** topology during `end_of_elaboration()` and configures a default transaction loop limit of `3` via `uvm_config_db`.

Pass any of the following classes to your simulator's `+UVM_TESTNAME` switch:

* **`test_1wr`:** Executes a single random memory write transaction.
* **`test_5wr`:** Executes 5 consecutive back-to-back memory write loops.
* **`test_1wr_1rd`:** Executes a write operation immediately followed by a read to the exact same randomized address location using sequence layering.
* **`test_5wr_5rd`:** Drives 5 consecutive memory writes, queues the target histories, and pops them cleanly to read and verify all 5 locations.
* **`test_nwr_nrd`:** Drives dynamic layered transactions defined by the `"count"` configuration variable.
* **`test_nwr_nrd_err`:** Inherits from `test_nwr_nrd` and utilizes a **UVM Factory Type Override** (`set_type_override("mem_tx", "mem_err_tx")`) to substitute transactions with error-injected variants.

---

## 🛠️ Verification Features

* **Advanced Sequence Layering:** Showcases clean verification reusability by driving independent flat sub-sequences (`seq_nwr`/`seq_nrd`) natively inside higher-level verification layers.
* **UVM Factory Printing & Overrides:** Demonstrates clean OOP capabilities by printing full architecture hierarchies and handling error injection configurations without editing basic sequence blocks.
* **Handshake Synchronization:** Driver tracks the `ready` signal from the DUT to ensure transactions are completed only when `valid` and `ready` align.
* **Scoreboard Verification:** Automatic data integrity checks tracking `wr_rd` transactions using an associative array to mirror the DUT memory internal array.
* **Functional Coverage:** Coverage metrics implemented inside `mem_cov.sv` monitoring cross-coverage of memory addresses (`addr`), operation types (`wr_rd`), and back-to-back operations.
