#!/cygdrive/c/Python38/python.exe

import re

pinList = \
( \
    "clock",

    ("R8",  "CLOCK_50", "i", "sysClk"),

    "leds",

    ("A15", "LED[0]", "o", "led[0]"),
    ("A13", "LED[1]", "o", "led[1]"),
    ("B13", "LED[2]", "o", "led[2]"),
    ("A11", "LED[3]", "o", "led[3]"),
    ("D1",  "LED[4]", "o", "led[4]"),
    ("F3",  "LED[5]", "o", "led[5]"),
    ("B1",  "LED[6]", "o", "led[6]"),
    ("L3",  "LED[7]", "o", "led[7]"),

    "keys",

    ("J15", "KEY[0]", "i", ""),
    ("E1",  "KEY[1]", "i", ""),

    "switches",

    ("M1",  "SW[0]", "i", ""),
    ("T8",  "SW[1]", "i", ""),
    ("B9",  "SW[2]", "i", ""),
    ("M15", "SW[3]", "i", ""),

    "gpio 0",

    ("A8",  "GPIO_0_IN-1[0]", "i", "dsel"),
    ("D3",  "GPIO_0-2[0]",    "i", "dclk"),
    ("B8",  "GPIO_0_IN-3[1]", "i", "din"),
    ("C3",  "GPIO_0-4[1]",    "o", "dout"),

    ("A2",  "GPIO_0-5[2]",    "o", "zDoneInt"),
    ("A3",  "GPIO_0-6[3]",    "o", "xDoneInt"),
    ("B3",  "GPIO_0-7[4]",    "i", "~start"),
    ("B4",  "GPIO_0-8[5]",    "o", "~intClk"),

    ("A4",  "GPIO_0-9[6]",    "i", "bIn"),
    ("B5",  "GPIO_0-10[7]",   "i", "aIn"),
    ("A5",  "GPIO_0-13[8]",   "i", "syncIn"),
    ("D5",  "GPIO_0-14[9]",   "i", ""),

    ("B6",  "GPIO_0-15[10]",  "o", "zStep"), # out2
    ("A6",  "GPIO_0-16[11]",  "o", "zDir"),  # out1
    ("B7",  "GPIO_0-17[12]",  "o", "xStep"), # out4
    ("D6",  "GPIO_0-18[13]",  "o", "xDir"),  # out3

    ("A7",  "GPIO_0-19[14]",  "o", "dbg[1]"),
    ("C6",  "GPIO_0-20[15]",  "o", "dbg[0]"),
    ("C8",  "GPIO_0-21[16]",  "o", "dbg[3]"),
    ("E6",  "GPIO_0-22[17]",  "o", "dbg[2]"),

    ("E7",  "GPIO_0-23[18]",  "o", "dbg[5]"),
    ("D8",  "GPIO_0-24[19]",  "o", "dbg[4]"),
    ("E8",  "GPIO_0-25[20]",  "o", "dbg[7]"),
    ("F8",  "GPIO_0-26[21]",  "o", "dbg[6]"),

    ("F9",  "GPIO_0-27[22]",  "o", "seg[2]"), # seg e
    ("E9",  "GPIO_0-28[23]",  "o", "~dp"),
    ("C9",  "GPIO_0-31[24]",  "o", "seg[1]"), # seg f
    ("D9",  "GPIO_0-32[25]",  "o", "seg[3]"), # seg d
    ("E11", "GPIO_0-33[26]",  "o", "seg[6]"), # seg a
    ("E10", "GPIO_0-34[27]",  "o", "seg[4]"), # seg c
    ("C11", "GPIO_0-35[28]",  "o", "seg[5]"), # seg b
    ("B11", "GPIO_0-36[29]",  "o", "seg[0]"), # seg g
  
    ("A12", "GPIO_0-37[30]",  "o", "anode[3]"),
    ("D11", "GPIO_0-38[31]",  "o", "anode[0]"),
    ("D12", "GPIO_0-39[32]",  "o", "anode[2]"),
    ("B12", "GPIO_0-40[33]",  "o", "anode[1]"),

    "gpio 1",

    ("T9",  "GPIO_1_IN[0]", "i", ""),
    ("F13", "GPIO_1[0]",    "i", ""),
    ("R9",  "GPIO_1_IN[1]", "i", ""),
    ("T15", "GPIO_1[1]",  "i", ""),
    ("T14", "GPIO_1[2]",  "i", ""),
    ("T13", "GPIO_1[3]",  "i", ""),
    ("R13", "GPIO_1[4]",  "i", ""),
    ("T12", "GPIO_1[5]",  "i", ""),
    ("R12", "GPIO_1[6]",  "i", ""),
    ("T11", "GPIO_1[7]",  "i", ""),
    ("T10", "GPIO_1[8]",  "i", ""),
    ("R11", "GPIO_1[9]",  "i", ""),
    ("P11", "GPIO_1[10]", "i", ""),
    ("R10", "GPIO_1[11]", "i", ""),
    ("N12", "GPIO_1[12]", "i", ""),
    ("P9",  "GPIO_1[13]", "i", ""),
    ("N9",  "GPIO_1[14]", "i", ""),
    ("N11", "GPIO_1[15]", "i", ""),
    ("L16", "GPIO_1[16]", "i", ""),
    ("K16", "GPIO_1[17]", "i", ""),
    ("R16", "GPIO_1[18]", "i", ""),
    ("L15", "GPIO_1[19]", "i", ""),
    ("P15", "GPIO_1[20]", "i", ""),
    ("P16", "GPIO_1[21]", "i", ""),
    ("R14", "GPIO_1[22]", "i", ""),
    ("N16", "GPIO_1[23]", "i", ""),
    ("N15", "GPIO_1[24]", "i", ""),
    ("P14", "GPIO_1[25]", "i", ""),
    ("L14", "GPIO_1[26]", "i", ""),
    ("N14", "GPIO_1[27]", "i", ""),
    ("M10", "GPIO_1[28]", "i", ""),
    ("L13", "GPIO_1[29]", "i", ""),
    ("J16", "GPIO_1[30]", "i", ""),
    ("K15", "GPIO_1[31]", "i", ""),
    ("J13", "GPIO_1[32]", "i", ""),
    ("J14", "GPIO_1[33]", "i", ""),

    "gpio 2 2x13 gpio header",

    ("E15", "GPIO_2_IN-2[0]", "i", ""),
    ("E16", "GPIO_2_IN-3[1]", "i", ""),
    ("M16", "GPIO_2_IN-4[2]", "i", ""),

    ("A14", "GPIO_2-5[0]",   "i", ""),
    ("B16", "GPIO_2-6[1]",   "i", ""),
    ("C14", "GPIO_2-7[2]",   "i", ""),
    ("C16", "GPIO_2-8[3]",   "i", ""),
    ("C15", "GPIO_2-9[4]",   "i", ""),
    ("D16", "GPIO_2-10[5]",  "i", ""),
    ("D15", "GPIO_2-11[6]",  "i", ""),
    ("D14", "GPIO_2-12[7]",  "i", ""),
    ("F15", "GPIO_2-13[8]",  "i", ""),
    ("F16", "GPIO_2-14[9]",  "i", ""),
    ("F14", "GPIO_2-15[10]", "i", ""),
    ("G16", "GPIO_2-16[11]", "i", ""),
    ("G15", "GPIO_2-17[12]", "i", ""),

    "sdram",

    ("M7", "DRAM_BA[0]",    "", ""),
    ("M6", "DRAM_BA[1]",    "", ""),
    ("R6", "DRAM_DQM[0]",   "", ""),
    ("T5", "DRAM_DQM[1]",   "", ""),
    ("L2", "DRAM_RAS_N",    "", ""),
    ("L1", "DRAM_CAS_N",    "", ""),
    ("L7", "DRAM_CKE",      "", ""),
    ("R4", "DRAM_CLK",      "", ""),
    ("C2", "DRAM_WE_N",     "", ""),
    ("P6", "DRAM_CS_N",     "", ""),
    ("G2", "DRAM_DQ[0]",    "", ""),
    ("G1", "DRAM_DQ[1]",    "", ""),
    ("L8", "DRAM_DQ[2]",    "", ""),
    ("K5", "DRAM_DQ[3]",    "", ""),
    ("K2", "DRAM_DQ[4]",    "", ""),
    ("J2", "DRAM_DQ[5]",    "", ""),
    ("J1", "DRAM_DQ[6]",    "", ""),
    ("R7", "DRAM_DQ[7]",    "", ""),
    ("T4", "DRAM_DQ[8]",    "", ""),
    ("T2", "DRAM_DQ[9]",    "", ""),
    ("T3", "DRAM_DQ[10]",   "", ""),
    ("R3", "DRAM_DQ[11]",   "", ""),
    ("R5", "DRAM_DQ[12]",   "", ""),
    ("P3", "DRAM_DQ[13]",   "", ""),
    ("N3", "DRAM_DQ[14]",   "", ""),
    ("K1", "DRAM_DQ[15]",   "", ""),
    ("P2", "DRAM_ADDR[0]",  "", ""),
    ("N5", "DRAM_ADDR[1]",  "", ""),
    ("N6", "DRAM_ADDR[2]",  "", ""),
    ("M8", "DRAM_ADDR[3]",  "", ""),
    ("P8", "DRAM_ADDR[4]",  "", ""),
    ("T7", "DRAM_ADDR[5]",  "", ""),
    ("N8", "DRAM_ADDR[6]",  "", ""),
    ("T6", "DRAM_ADDR[7]",  "", ""),
    ("R1", "DRAM_ADDR[8]",  "", ""),
    ("P1", "DRAM_ADDR[9]",  "", ""),
    ("N2", "DRAM_ADDR[10]", "", ""),
    ("N1", "DRAM_ADDR[11]", "", ""),
    ("L4", "DRAM_ADDR[12]", "", ""),

    "epcs",

    ("H2", "EPCS_DATA0", "", ""),
    ("H1", "EPCS_DCLK",  "", ""),
    ("D2", "EPCS_NCSO",  "", ""),
    ("C1", "EPCS_ASDO",  "", ""),

    "accelerometer and eeprom",

    ("F2", "I2C_SCLK", "", ""),
    ("F1", "I2C_SDAT", "", ""),
    ("G5", "G_SENSOR_CS_N", "", ""),
    ("M2", "G_SENSOR_INT",  "", ""),

    "adc",

    ("A10", "ADC_CS_N",  "", ""),
    ("B10", "ADC_SADDR", "", ""),
    ("B14", "ADC_SCLK",  "", ""),
    ("A9",  "ADC_SDAT",  "", ""),
)

def fWrite(f, txt):
    f.write(txt.encode())

directory = "LatheNew"
proj = "LatheCtl"

f = open(proj + ".qsf", "wb")

fIn = open("../" + directory + "/Proj/" + proj + ".qsf", "r")

out = True
lastblank = True
for line in fIn:
    line = line.strip()
    if line.startswith("#++ pins"):
        out = False
        continue
    elif line.startswith("#-- pins"):
        out = True
        continue
    elif line.startswith("set_instance_assignment"):
        continue
    elif line.startswith("set_location_assignment"):
        continue
    elif line.startswith("#set"):
        continue
    if out:
        blank = len(line) == 0
        if blank and lastBlank:
            continue
        print(line)
        fWrite(f, line)
        fWrite(f, "\n")
        lastBlank = blank
        
if not lastBlank:
    fWrite(f, "\n")
fWrite(f, "#++ pins\n\n")
for pinData in pinList:
    if isinstance(pinData, str):
        fWrite(f, "# %s\n\n" % (pinData))
    else:
        (pin, conn, direction, name) = pinData
        if len(name) == 0 or name.startswith("~"):
            n = "reserved_" + conn
            fWrite(f, "#set_location_assignment PIN_%s -to %s\n" % \
                   (pin, n))
            fWrite(f, "#set_instance_assignment -name IO_STANDARD " \
                   "\"3.3-V LVTTL\" -to %s\n" % (n))
            fWrite(f, "#set_instance_assignment -name RESERVE_PIN " \
                   "AS_INPUT_TRI_STATED -to %s\n" % (n))
        else:
            fWrite(f, "set_location_assignment PIN_%s -to %s\n" % \
                   (pin, name))
            fWrite(f, "set_instance_assignment -name IO_STANDARD " \
                   "\"3.3-V LVTTL\" -to %s\n" % (name))
            if direction == "o":
                   fWrite(f, "set_instance_assignment " \
                          "-name CURRENT_STRENGTH_NEW 8MA -to %s\n" % (name))
        fWrite(f, "\n");
fWrite(f, "#-- pins\n")
f.close()
