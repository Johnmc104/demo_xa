# demo_xa

## how to use
```shell
cd sim
make all AMS_EN=1  //xa spice file
make all AMS_EN=3  //xa spice + veriloga file
```

if use cadence spectre netlist file,
edit xa.init at sim_cfg, use `choose xa -nspectre xxxx`


## other
a2d signal type must be wire type
