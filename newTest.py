#!/usr/bin/python3

from math import floor, log
from sys import stdout
from time import sleep
import sys
import time
import lRegDef as r
import fpgaLathe as b

import spidev
bus = 0
device = 0
spi = spidev.SpiDev()
spi.open(bus, device)
spi.max_speed_hz = 500000
spi.mode = 0

base = r.F_ZAxis_Base
bSyn = base + r.F_Sync_Base
bLoc = base + r.F_Loc_Base
bDist = base + r.F_Dist_Base
    
def ld(cmd, data, size):
    data &= 0xffffffff
    val = list(data.to_bytes(size, byteorder='big'))
    msg = [cmd] + val
    spi.xfer2(msg)

def rd(cmd, size):
    msg = [cmd]
    spi.xfer2(msg)
    val = spi.readbytes(size)
    result = int.from_bytes(val, byteorder='big')
    if result & 0x80000000:
        result |= -1 & ~0xffffffff
    return(result)

def readData(index=None, prt=True):
    global xPos, yPos, zSum, zAclSum, aclCtr, curLoc, curDist
    xPos = rd(bSyn + r.F_Rd_XPos, 4)
    yPos = rd(bSyn + r.F_Rd_YPos, 4)
    zSum = rd(bSyn + r.F_Rd_Sum, 4)
    zAclSum = rd(bSyn + r.F_Rd_Accel_Sum, 4)
    aclCtr = rd(bSyn + r.F_Rd_Accel_Ctr, 4)
    if prt:
        if index is None:
            print("    ", end=" ")
        else:
            print("%4d" % (index), end=" ")
            
        print("xPos %6d yPos %6d zSum %12d" % (xPos, yPos, zSum), end=" ")
        print("aclSum %8d aclCtr %8d" % (zAclSum, aclCtr), end=" ")

    curDist = rd(bDist + r.F_Rd_Dist, 4) # read z location
    curAcl = rd(bDist + r.F_Rd_Acl_Steps, 4) # read accel steps
    curLoc = rd(bLoc + r.F_Rd_Loc, 4)  # read z location

    if prt:
        print("dist %6d aclStp %6d loc %5d" % (curDist, curAcl, curLoc))

def test3(runClocks=100, stepClocks=0, dist=20, loc= 0, dbgprint=True, \
          dbg=False, pData=False):
    global xPos, yPos, zSum, zAclSum, aclCtr, curLoc, curDist
    if pData:
        from pylab import plot, grid, show
        from array import array
        time = array('f')
        data = array('f')
        time.append(0)
        data.append(0)

    cFreq = 50000000            # clock frequency
    mult = 64                   # freq gen multiplier
    stepsRev = 1600             # steps per revolution
    pitch = .1                  # leadscrew pitch
    scale = 8                   # scale factor

    minFeed = 10                # min feed ipm
    maxFeed = 40                # max feed ipm
    accelRate = 20              # acceleration rate in per sec^2

    stepsInch = stepsRev / pitch      # steps per inch
    stepsMinMax = maxFeed * stepsInch # max steps per min
    stepsSecMax = stepsMinMax / 60.0  # max steps per second
    freqGenMax = int(stepsSecMax) * mult # frequency generator maximum
    print("stepsSecMax %6.0f freqGenMax %7.0f" % (stepsSecMax, freqGenMax))

    stepsMinMin = minFeed * stepsInch # max steps per min
    stepsSecMin = stepsMinMin / 60.0  # max steps per second
    freqGenMin = stepsSecMin * mult   # frequency generator maximum
    print("stepsSecMin %6.0f freqGenMin %7.0f" % (stepsSecMin, freqGenMin))

    freqDivider = int(floor(cFreq / freqGenMax - 1)) # calc divider
    print("freqDivider %3.0f" % freqDivider)

    accelTime = (maxFeed - minFeed) / (60.0 * accelRate) # acceleration time
    accelClocks = int(accelTime * freqGenMax)
    print("accelTime %8.6f clocks %d" % (accelTime, accelClocks))

    scalePrt = False
    for scale in range(0, 10):
        dyMin = int(stepsSecMin) << scale
        dyMax = int(stepsSecMax) << scale
        dx = int(freqGenMax) << scale
        dyDelta = dyMax - dyMin
        if scalePrt:
            print("\ndx %d dyMin %d dyMax %d dyDelta %d" % \
                  (dx, dyMin, dyMax, dyDelta))

        incPerClock = dyDelta / float(accelClocks)
        intIncPerClock = int(incPerClock)
        dyDeltaC = intIncPerClock * accelClocks
        dyIni = dyMax - dyDeltaC
        err = int(dyDelta - dyDeltaC) >> scale
        bits = int(floor(log(2*dx, 2))) + 1
        if scalePrt:
            print(("dyIni %d dyMax %d dyDelta %d incPerClock %4.2f "\
                   "err %d bits %d" %
                   (dyIni, dyMax, dyDeltaC, incPerClock, err, bits)))
        if (err == 0):
            break

    # incr1 = 2 * dyMax
    # incr2 = incr1 - 2 * dx
    # d = incr1 - dx
    # bits = int(floor(log(abs(incr2), 2))) + 1
    # print(("incr1 %d incr2 %d d %d bits %d" %
    #        (incr1,incr2, d, bits)))

    print("")
    clocks = 0
    lastT = 0
    lastC = 0
    x = 0
    y = 0
    incr1 = 2 * dyIni
    incr2 = incr1 - 2 * dx
    d = incr1 - dx

    bits = int(floor(log(abs(incr2), 2))) + 1
    print(("dx %d dy %d incr1 %d incr2 %d d %d bits %d" %
           (dx, dyIni, incr1, incr2, d, bits)))

    zSynAccel = 2 * intIncPerClock
    zSynAclCnt = accelClocks
    
    totalSum = (accelClocks * incr1) + d
    totalInc = (accelClocks * (accelClocks - 1) * zSynAccel) / 2
    accelSteps = ((totalSum + totalInc) / (2 * dx))

    print(("accelClocks %d totalSum %d totalInc %d accelSteps %d" % 
           (accelClocks, totalSum, totalInc, accelSteps)))

    f = open('accel.txt', 'w')
    sum = d
    inc = 2 * intIncPerClock
    incAccum = 0
    print(("\n%17s incr1 %8d incr2 %10d inc %4d" % \
           ("", incr1, incr2, intIncPerClock)))
    stdout.flush()
    while (clocks < (accelClocks * 1.2)):
        x += 1
        if (sum < 0):
            sum += incr1
        else:
            deltaC = clocks - lastC
            f.write(("(%6d %5d) dC %5d sum %8d iAcum %8d " +
                     "i1 %8d i2 %11d\n") % \
                    (x, y, deltaC, sum, incAccum,
                     incr1 + incAccum, incr2 + incAccum))
            y += 1
            sum += incr2
            curT = clocks / freqGenMax
            deltaT = curT - lastT
            if pData:
                if (lastT != 0):
                    time.append(curT);
                    data.append(1.0 / deltaT)
            lastT = curT
            lastC = clocks
        sum += incAccum
        if (clocks < accelClocks):
            incAccum += inc
        clocks += 1
    f.close()

    print(("y %4d clks %5d incr1 %8d incr2 %10d sum %12d incAccum %8d" %
           (y, clocks, incr1 + incAccum, incr2 + incAccum, sum, incAccum)))

    print("\n")

    clkReg = 0
    ld(r.F_Ld_Clk_Ctl, clkReg, 1);

    axisCtl = b.ctlInit
    ld(base + r.F_Ld_Axis_Ctl, axisCtl, 1);

    axisCtl = 0
    ld(base + r.F_Ld_Axis_Ctl, axisCtl, 1);

    syncCtl = 0
    ld(r.F_Ld_Sync_Ctl, axisCtl, 1);

    cfgCtl = 0
    ld(r.F_Ld_Cfg_Ctl, cfgCtl, 1);

    ld(bSyn + r.F_Ld_D, d, 4)		# load d value
    ld(bSyn + r.F_Ld_Incr1, incr1, 4)	# load incr1 value
    ld(bSyn + r.F_Ld_Incr2, incr2, 4)	# load incr2 value

    ld(bSyn + r.F_Ld_Accel_Val, zSynAccel, 4)   # load z accel
    ld(bSyn + r.F_Ld_Accel_Count, zSynAclCnt-1, 4) # load z accel count

    ld(bLoc + r.F_Ld_Loc, 5, 4)       # set z location
    ld(bDist + r.F_Ld_Dist, dist, 4)  # load z distance

    axisCtl = b.ctlInit | b.ctlSetLoc
    ld(base + r.F_Ld_Axis_Ctl, axisCtl, 1);
    
    axisCtl = 0
    ld(base + r.F_Ld_Axis_Ctl, axisCtl, 1);

    readData()

    axisCtl = b.ctlStart | b.ctlDir
    ld(base + r.F_Ld_Axis_Ctl, axisCtl, 1);

    readData()

    if runClocks != 0:
        ld(r.F_Dbg_Freq_Base + r.F_Ld_Dbg_Freq, freqDivider, 2)
        ld(r.F_Dbg_Freq_Base + r.F_Ld_Dbg_Count, runClocks, 4)

        clkReg = b.zClkDbgFreq
        ld(r.F_Ld_Clk_Ctl, clkReg, 1);
        clkReg |= b.clkDbgFreqEna
        ld(r.F_Ld_Clk_Ctl, clkReg, 1);

        if runClocks > 1:
            sleep(.25)
            readData()
            # if dbgprint:
            #     print("\nresults %d clocks %d" % (runClocks, xPos))

        if stepClocks != 0:
            stepData = []
            for i in range(stepClocks):
                if i == 0:
                    print()
                readData(i)
                ld(r.F_Dbg_Freq_Base + r.F_Ld_Dbg_Count, 1, 4)
                stepData.append((zSum, zAclSum))
            print()
    else:
        sync = False
        if sync:
            clkReg = b.zClkCh
        else:
            ld(r.F_Ld_Z_Freq, freqDivider, 2)
            clkReg = b.zClkZFreq
        ld(r.F_Ld_Clk_Ctl, clkReg, 1);
        while True:
            status = rd(r.F_Rd_Status, 4)
            if (status & b.zAxisDone) != 0:
                break
            sleep(0.1)
        readData()

    status = rd(r.F_Rd_Status, 4)
    print("status %d" % (status))

    axisCtl = b.ctlInit
    ld(base + r.F_Ld_Axis_Ctl, axisCtl, 1);

    x = 0
    y = 0
    clocks = 0
    synSum = d
    accelAccum = 0
    distCtr = dist
    l0 = dist
    aclStep = 0
    aclCtr = accelClocks-1
    index = 0
    decel = False
    delayDecel = False
    while (clocks < xPos):
        clocks += 1
        x += 1
        if aclCtr > 0:
            aclCtr -= 1
        if (synSum < 0):
            synSum += incr1
        else:
            y += 1
            synSum += incr2
            distCtr -= 1
            if (not decel) and (aclCtr > 0):
                aclStep += 1
            if aclStep >= distCtr:
                aclCtr = accelClocks-1
                decel = True
            if (distCtr == 0):
                break
        synSum += accelAccum

        if (not delayDecel) and (clocks <= accelClocks):
            accelAccum += zSynAccel

        if delayDecel:
            if (accelAccum > 0):
                accelAccum -= zSynAccel

        # if True:
        if clocks > (xPos-stepClocks):
            print("%4d" % (index), end=" ")
            print("xPos %5d yPos %5d zSum %10d" % (x, y, synSum), end=" ")
            print("aclSum %8d aclCtr %8d" % (accelAccum, aclCtr), end=" ")
            print("dist %5d aclStp %6d" % (distCtr, aclStep), end=" ")
            (zSum, zAclSum) = stepData[index]
            print("sDiff %6d aDiff %6d" % \
                  (synSum - zSum, accelAccum - zAclSum))
            # print()
            index += 1
        delayDecel = decel

    print(("\nx %d y %d sum %d delta %d accelAccum %d delta %d" %
           (x, y, synSum, synSum - zSum, accelAccum, accelAccum - zAclSum)))

    if pData:
        plot(time, data, 'b', aa="true")
        grid(True)
        show()

arg1 = None
arg2 = None
arg3 = None
if len(sys.argv) > 1:
    try:
        arg1 = int(sys.argv[1])
    except ValueError:
        arg1 = sys.argv[1]

if len(sys.argv) > 2:
    try:
        arg2 = int(sys.argv[2])
    except ValueError:
        arg2 = sys.argv[2]

if len(sys.argv) > 3:
    try:
        arg3 = int(sys.argv[3])
    except ValueError:
        arg3 = sys.argv[3]

if arg1 is None:
    test3()
elif arg2 is None:
    test3(runClocks=arg1)
elif arg3 is None:
    test3(runClocks=arg1, dist=arg2)
else:
    test3(runClocks=arg1, dist=arg2, stepClocks=arg3)
