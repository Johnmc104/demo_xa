# demo_xa

## how to use
```shell
cd sim
make all AMS_EN=1  //xa spice file
make all AMS_EN=3  //xa spice + veriloga file
```

if use cadence spectre netlist file,
edit xa.init at sim_cfg, use `choose xa -nspectre xxxx`
or
edit finesim.init at sim_cfg, use `choose finesim -spectre xxxx`


## other
a2d signal type must be wire type, or set `port_dir` with logic type

### dir
```
port_dir -cell xxx (output xxx);
```
