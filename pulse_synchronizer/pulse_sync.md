# Pulse Synchronizer

## Description
When trying to pass a pulse signal, from Clock A to clock B, using the previous example would cause issues.
**Case 1:** clock A is faster than clock B. In this case, the pulse may not register in clock B’s domain, at all. The register in clock A’s domain would change faster than clock B to sample it.
**Case 2:** clock A slower than clock B. In this case, instead of passing as a pulse, the output would be spread, by the length of the speed ratios. This defeats the pulse purpose.

**Solution:** instead of simply sampling the input, there is some logic to add to make sure the pulse acts as intended.
The FF in clock A’s domain is changed to a toggle register. This allows the design to know when a pulse has occurred. In clock B’s domain, the registers are connected to a XOR gate, to discover when there is a change from clock A’s domain.

[add_design](!asgasg)

**Notice!** Like previously, there are some limitations. The pulses must have at least the slower clock time between them. There cannot be 2 consecutive pulses, if clock A is faster than clock B.

## Throughput and Latency

This method does not pass interfaces which consider throughput as a factor.
Latency is `CLK_A + 3 x CLK_B`.
This means, the latency relatively increases if clock B is the slower of the two.
