# Interface with ACK Synchronizer

## Description

Synchronizing an interface with a valid and ack interface is quite simple - synchronizing the valid with the data in one direction, and the ack in the other direction.
**Notice!** This does not support sending more than 1 valid until an ack has been received. The data may be overwritten.

## Throughput and Latency

As there is at least 3 clocks until the valid and data reaches the sink, and another 3 clocks to the ack to arrive to the source, the throughput of this modules is slow, utilizing only 1/6 of the available throughput.
Latency is the same, 3 clocks.

# Handshake Synchronizer

## Description

This method is for passing data, with acknowledgement when the data has arrived to the sink.
It is similar to the ACK synchronizer, but the sink does not have a valid and ack signals.

# Avalon-ST Synchronizer

## Description

A combination of both modules above. Will send a single Avalon-ST data pulse at a time.

## Throughput and Latency

Remains the same - this module is used for low requirements interfaces.