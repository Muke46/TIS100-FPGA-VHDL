# Define program paths
$ghdlPath = "D:\Programs\GHDL\bin\ghdl.exe"
$GTKwavePath = "D:\Programs\gtkwave64\bin\gtkwave.exe"

# Define program arguments
$modulesFiles = 
"ACC/ACC.vhd " +
"ADDR_DEC/ADDR_DEC.vhd " +
"ALU/ALU.vhd " +
"BKP/BKP.vhd " +
"IOPORT/IOPORT.vhd " +
"MEM/MEM.vhd " +
"PC/PC.vhd "

$testbenchFile = "TOP_tb.vhd"
$topModuleName = "testbench"

# Run GHDL commands
#$ghdlCmd0 = "$ghdlPath -a --std=08 $modulesFiles $testbenchFile"
$ghdlCmd1 = "$ghdlPath -i --std=08 $modulesFiles $testbenchFile"
$ghdlCmd2 = "$ghdlPath -m --std=08 $topModuleName"
$ghdlCmd3 = "$ghdlPath -r --std=08 $topModuleName --vcd=dump.vcd"

#Invoke-Expression $ghdlCmd0
Invoke-Expression $ghdlCmd1
Invoke-Expression $ghdlCmd2
Invoke-Expression $ghdlCmd3

# Call the second program with arguments
#Start-Process -FilePath $GTKwavePath dump.vcd
