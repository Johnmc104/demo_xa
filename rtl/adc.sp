.hdl adc.va 
.options post=1

.subckt Xadc vin clock d0 d1 d2 d3


  adc0 vin clock d0 d1 d2 d3 ideal_adc trise=1n 
  + tfall=1n clk_vth=0.5 fullscale=1.0

.ends Xadc

.end