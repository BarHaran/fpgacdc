# Async FIFO

## Description

The best way to pass an interface with maximum throughput, is to use an Async FIFO.
An Async FIFO is a FIFO which uses a SDPRAM, with different clocks for each port.
The pointers of the read and write are in different clock domains, and synchronizes them to calculate the empty and full flags.

## Throughput and Latency

The FIFO's throughput is the maximum throughput available in the slower clock domain.
The latency is the time required to synchronize the pointers, 3 clocks.

## FIFO Depth

Calculating the FIFO depth is dependent on many factors.
Not enough depth, and the FIFO would lower the throughput, and not support the required bursts.

### Required parameters

* Write frequency
* Write max burst - how many write commands are given at a burst
* Write idle cycles - how many idle cycles are between each write command. This could be considered as a sort of duty cycle.
* Read frequency
* Read idle cycles - how many idle cycles are between each read command

### Derivatives

* Synchronization latency = 2 (full and empty calc)
* Effective frequency = frequency * (1 + idle_cycles) - the effective frequency of the port, depending on the idle cycles between commands.
* effective_clk = 1/effective_frequency

### The Algorithm

* time to write a single bus = effective_wr_clk
* time to write all burst = time_to_write_single * write_burst
* time to read a single bus = effective_rd_clk
* amount read during a burst = time_to_write_burst / time_to_read_single_bus
* **FIFO_DEPTH = write_burst - read_amount_during_burst + sync_latency**