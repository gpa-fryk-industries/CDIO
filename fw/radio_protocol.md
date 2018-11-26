# Radio protocol

## Data packets

All packages must begin with 8 bit packet id describing the packets function.


Packet format:
`[packet-id:8](payload:N*8)`

Syntax explanation; `[name:len]` denotes required data and `(name:len)` denotes optional data.

These id's are listed below:

### 0x00 - Nop | p2p, broadcast
No payload. Does nothing.

### 0x01 - Ping | p2p
No payload. Returns a Pong (0x02) to sender.

### 0x02 - Pong | p2p
No payload. Acts as a response tp Ping (0x01)

### 0xF0 - Message | p2p, broadcast
Payload contains message text formatted as a null terminated string. 

`[message:\n]`

### 0xF1 - Data | p2p, broadcast

`[channel:4][options:4][index:8][sample:16][adpcm_stream:4*128]`