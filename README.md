# SW_AES

Verilog implementation of the symmetric block cipher AES (Advanced Encryption Standard) as specified in NIST FIPS 197. This implementation supports 128 and 256 bit keys. The AES rtl is based on [this repo](https://github.com/secworks/aes/tree/master) 

## The wrapped IP


 APB, AHBL, and Wishbone wrappers, generated by the [BusWrap](https://github.com/efabless/BusWrap/tree/main) `bus_wrap.py` utility, are provided. All wrappers provide the same programmer's interface as outlined in the following sections.

### Wrapped IP System Integration

Based on your use case, use one of the provided wrappers or create a wrapper for your system bus type. For an example of how to integrate the APB wrapper:
```verilog
SW_AES_APB INST (
        `TB_APB_SLAVE_CONN
);
```
> **_NOTE:_** `TB_APB_SLAVE_CONN is a convenient macro provided by [BusWrap](https://github.com/efabless/BusWrap/tree/main).

## Implementation example  

The following table is the result for implementing the SW_AES IP with different wrappers using Sky130 PDK and [OpenLane2](https://github.com/efabless/openlane2) flow.
|Module | Number of cells | Max. freq |
|---|---|---|
|SW_AES|TBD| TBD |
|SW_AES_APB|TBD|TBD|
|SW_AES_AHBL|TBD|TBD|
|SW_AES_WB|TBD|TBD|
## The Programmer's Interface


### Registers

|Name|Offset|Reset Value|Access Mode|Description|
|---|---|---|---|---|
|STATUS|0000|0x00000000|r|Status register bit 6: ready , bit 7: valid|
|CTRL|0004|0x00000000|w|Control register bit 0: Initial bit (init), bit 1: Next bit , bit 2: Encipher/Decipher control, bit 3: Key length control|
|KEY0|0008|0x00000000|w|Contains the bits 31-0 of the input key value|
|KEY1|000c|0x00000000|w|Contains the bits 63-32 of the input key value|
|KEY2|0010|0x00000000|w|Contains the bits 95-64 of the input key value|
|KEY3|0014|0x00000000|w|Contains the bits 127-96 of the input key value|
|KEY4|0018|0x00000000|w|Contains the bits 159-128 of the input key value|
|KEY5|001c|0x00000000|w|Contains the bits 191-160 of the input key value|
|KEY6|0020|0x00000000|w|Contains the bits 223-192 of the input key value|
|KEY7|0024|0x00000000|w|Contains the bits 255-224 of the input key value|
|BLOCK0|0028|0x00000000|w|Contains the bits 31-0 of the input block value|
|BLOCK1|002c|0x00000000|w|Contains the bits 63-32 of the input block value|
|BLOCK2|0030|0x00000000|w|Contains the bits 95-64 of the input block value|
|BLOCK3|0034|0x00000000|w|Contains the bits 127-96 of the input block value|
|RESULT0|0038|0x00000000|w|Contains the bits 31-0 of the input result value|
|RESULT1|003c|0x00000000|w|Contains the bits 63-32 of the input result value|
|RESULT2|0040|0x00000000|w|Contains the bits 95-64 of the input result value|
|RESULT3|0044|0x00000000|w|Contains the bits 127-96 of the input result value|
|IM|ff00|0x00000000|w|Interrupt Mask Register; write 1/0 to enable/disable interrupts; check the interrupt flags table for more details|
|RIS|ff08|0x00000000|w|Raw Interrupt Status; reflects the current interrupts status;check the interrupt flags table for more details|
|MIS|ff04|0x00000000|w|Masked Interrupt Status; On a read, this register gives the current masked status value of the corresponding interrupt. A write has no effect; check the interrupt flags table for more details|
|IC|ff0c|0x00000000|w|Interrupt Clear Register; On a write of 1, the corresponding interrupt (both raw interrupt and masked interrupt, if enabled) is cleared; check the interrupt flags table for more details|

### STATUS Register [Offset: 0x0, mode: r]

Status register bit 6: ready , bit 7: valid
<img src="https://svg.wavedrom.com/{reg:[{bits: 6},{name:'ready_reg', bits:1},{name:'valid_reg', bits:1},{bits: 24}], config: {lanes: 2, hflip: true}} "/>

|bit|field name|width|description|
|---|---|---|---|
|6|ready_reg|1|Ready to start|
|7|valid_reg|1|Result is valid|


### CTRL Register [Offset: 0x4, mode: w]

Control register bit 0: Initial bit (init), bit 1: Next bit , bit 2: Encipher/Decipher control, bit 3: Key length control
<img src="https://svg.wavedrom.com/{reg:[{name:'init_reg', bits:1},{name:'next_reg', bits:1},{name:'encdec_reg', bits:1},{name:'keylen_reg', bits:1},{bits: 28}], config: {lanes: 2, hflip: true}} "/>

|bit|field name|width|description|
|---|---|---|---|
|0|init_reg|1|Initial bit|
|1|next_reg|1|Next bit|
|2|encdec_reg|1|Encipher/Decipher control (“0” means Decipher “1” means Encipher)|
|3|keylen_reg|1|Key length control (“0” means 128 bit key length “1” means 256 bit key length")|


### KEY0 Register [Offset: 0x8, mode: w]

Contains the bits 31-0 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY0', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY1 Register [Offset: 0xc, mode: w]

Contains the bits 63-32 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY1', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY2 Register [Offset: 0x10, mode: w]

Contains the bits 95-64 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY2', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY3 Register [Offset: 0x14, mode: w]

Contains the bits 127-96 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY3', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY4 Register [Offset: 0x18, mode: w]

Contains the bits 159-128 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY4', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY5 Register [Offset: 0x1c, mode: w]

Contains the bits 191-160 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY5', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY6 Register [Offset: 0x20, mode: w]

Contains the bits 223-192 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY6', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### KEY7 Register [Offset: 0x24, mode: w]

Contains the bits 255-224 of the input key value
<img src="https://svg.wavedrom.com/{reg:[{name:'KEY7', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### BLOCK0 Register [Offset: 0x28, mode: w]

Contains the bits 31-0 of the input block value
<img src="https://svg.wavedrom.com/{reg:[{name:'BLOCK0', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### BLOCK1 Register [Offset: 0x2c, mode: w]

Contains the bits 63-32 of the input block value
<img src="https://svg.wavedrom.com/{reg:[{name:'BLOCK1', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### BLOCK2 Register [Offset: 0x30, mode: w]

Contains the bits 95-64 of the input block value
<img src="https://svg.wavedrom.com/{reg:[{name:'BLOCK2', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### BLOCK3 Register [Offset: 0x34, mode: w]

Contains the bits 127-96 of the input block value
<img src="https://svg.wavedrom.com/{reg:[{name:'BLOCK3', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### RESULT0 Register [Offset: 0x38, mode: w]

Contains the bits 31-0 of the input result value
<img src="https://svg.wavedrom.com/{reg:[{name:'RESULT0', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### RESULT1 Register [Offset: 0x3c, mode: w]

Contains the bits 63-32 of the input result value
<img src="https://svg.wavedrom.com/{reg:[{name:'RESULT1', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### RESULT2 Register [Offset: 0x40, mode: w]

Contains the bits 95-64 of the input result value
<img src="https://svg.wavedrom.com/{reg:[{name:'RESULT2', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### RESULT3 Register [Offset: 0x44, mode: w]

Contains the bits 127-96 of the input result value
<img src="https://svg.wavedrom.com/{reg:[{name:'RESULT3', bits:32},{bits: 0}], config: {lanes: 2, hflip: true}} "/>


### Interrupt Flags

The wrapped IP provides four registers to deal with interrupts: IM, RIS, MIS and IC. These registers exist for all wrapper types generated by the [BusWrap](https://github.com/efabless/BusWrap/tree/main) `bus_wrap.py` utility. 

Each register has a group of bits for the interrupt sources/flags.
- `IM`: is used to enable/disable interrupt sources.

- `RIS`: has the current interrupt status (interrupt flags) whether they are enabled or disabled.

- `MIS`: is the result of masking (ANDing) RIS by IM.

- `IC`: is used to clear an interrupt flag.


The following are the bit definitions for the interrupt registers:

|Bit|Flag|Width|Description|
|---|---|---|---|
|0|VALID|1|Result is valid|
|1|READY|1|Ready to start|

### The Interface 

<img src="docs/aes_core.svg" width="600"/>


#### Ports 

|Port|Direction|Width|Description|
|---|---|---|---|
|encdec|input|1|Encipher/Decipher control|
|init|input|1|Initial bit|
|next|input|1|Next bit|
|ready|input|1|ready to start|
|key|input|256|key value|
|keylen|input|1|key length 128 or 256|
|block|input|128|block value|
|result|output|128|result value|
|result_valid|output|1|result is valid|
## F/W Usage Guidelines:
TBD
## Installation:
You can either clone repo or use [IPM](https://github.com/efabless/IPM) which is an open-source IPs Package Manager
* To clone repo:
```git clone https://github.com/efabless/SW_AES```
* To download via IPM , follow installation guides [here](https://github.com/efabless/IPM/blob/main/README.md) then run 
```ipm install SW_AES```
### Run cocotb UVM Testbench:
TBD