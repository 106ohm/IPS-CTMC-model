# IPS rates for different architectures
module rate_IPS_archs

using DataFrames
using PrettyTables
using Printf
using Gnuplot

@enum LoadT begin
           DC = 1
           AC = 2
end

# CR
function rnm_CR(n, m, loadtype) 
    if loadtype == DC::LoadT
        scale_factor= (log(n+m)+log(2+n+m))/log(6)
    else # AC load
        scale_factor= (log(2)+log(n+m)+log(1+n+m))/log(8)
    end
end

# IR
function rnm_IR(n, m, loadtype) 
    if loadtype == DC::LoadT
        scale_factor= (log(3)+log(n+m))/log(6)
    else # AC load
        scale_factor= (log(4)+log(n+m))/log(8)
    end
end

# MR
function rnm_MR(n, m, loadtype) 
    if loadtype == DC::LoadT
        scale_factor= log(2*(n+m)+1)/log(6)
    else # AC load
        scale_factor= (log(4)+log(n+m))/log(8)
    end
end

# redundancy
n=10
m=3
r=17

print("n: ", n,"\n")
print("m: ", m,"\n")
print("r: ", r,"\n")

# rates (1/h)
failure_rate_rectifier_SR=16.6e−6 
failure_rate_battery_SR=11.76e−6
failure_rate_inverter_SR=16.6e−6

# DC load
failure_rate_R_CR_DC=rnm_CR(n, m, DC::LoadT)*r*failure_rate_rectifier_SR
failure_rate_B_CR_DC=rnm_CR(n, m, DC::LoadT)*r*failure_rate_battery_SR
# rate for IR
failure_rate_R_IR_DC=rnm_IR(n, m, DC::LoadT)*r*failure_rate_rectifier_SR
failure_rate_B_IR_DC=rnm_IR(n, m, DC::LoadT)*r*failure_rate_battery_SR
# rate for MR
failure_rate_R_MR_DC=rnm_MR(n, m, DC::LoadT)*r*failure_rate_rectifier_SR
failure_rate_B_MR_DC=rnm_MR(n, m, DC::LoadT)*r*failure_rate_battery_SR

# AC load
# rate for CR
failure_rate_R_CR_AC=rnm_CR(n, m, AC::LoadT)*r*failure_rate_rectifier_SR
failure_rate_B_CR_AC=rnm_CR(n, m, AC::LoadT)*r*failure_rate_battery_SR
failure_rate_I_CR_AC=rnm_CR(n, m, AC::LoadT)*r*failure_rate_inverter_SR
# rate for IR
failure_rate_R_IR_AC=rnm_IR(n, m, AC::LoadT)*r*failure_rate_rectifier_SR
failure_rate_B_IR_AC=rnm_IR(n, m, AC::LoadT)*r*failure_rate_battery_SR
failure_rate_I_IR_AC=rnm_IR(n, m, AC::LoadT)*r*failure_rate_inverter_SR
# rate for MR
failure_rate_R_MR_AC=rnm_MR(n, m, AC::LoadT)*r*failure_rate_rectifier_SR
failure_rate_B_MR_AC=rnm_MR(n, m, AC::LoadT)*r*failure_rate_battery_SR
failure_rate_I_MR_AC=rnm_MR(n, m, AC::LoadT)*r*failure_rate_inverter_SR


# DC load
print("rnm_CR_DC: ", rnm_CR(n, m, DC::LoadT),"\n")
# rectifier
print("rectifier, DC load:\n")
print("failure_rate_R_CR_DC: ", failure_rate_R_CR_DC,"\n")
print("failure_rate_R_IR_DC: ", failure_rate_R_IR_DC,"\n")
print("failure_rate_R_MR_DC: ", failure_rate_R_MR_DC,"\n")
print("failure_rate_R_SR_DC: ", failure_rate_rectifier_SR,"\n")
# battery
print("battery, DC load:\n")
print("failure_rate_B_CR_DC: ", failure_rate_B_CR_DC,"\n")
print("failure_rate_B_IR_DC: ", failure_rate_B_IR_DC,"\n")
print("failure_rate_B_MR_DC: ", failure_rate_B_MR_DC,"\n")
print("failure_rate_B_SR_DC: ", failure_rate_battery_SR,"\n")

# CR
# AC load
print("rnm_CR_AC: ", rnm_CR(n, m, AC::LoadT),"\n")
# rectifier
print("rectifier, AC load:\n")
print("failure_rate_R_CR_AC: ", failure_rate_R_CR_AC,"\n")
print("failure_rate_R_IR_AC: ", failure_rate_R_IR_AC,"\n")
print("failure_rate_R_MR_AC: ", failure_rate_R_MR_AC,"\n")
print("failure_rate_R_SR_AC: ", failure_rate_rectifier_SR,"\n")
# battery
print("battery, AC load:\n")
print("failure_rate_B_CR_AC: ", failure_rate_B_CR_AC,"\n")
print("failure_rate_B_IR_AC: ", failure_rate_B_IR_AC,"\n")
print("failure_rate_B_MR_AC: ", failure_rate_B_MR_AC,"\n")
print("failure_rate_B_SR_AC: ", failure_rate_battery_SR,"\n")
# inverter
print("inverter, AC load:\n")
print("failure_rate_I_CR_AC: ", failure_rate_I_CR_AC,"\n")
print("failure_rate_I_IR_AC: ", failure_rate_I_IR_AC,"\n")
print("failure_rate_I_MR_AC: ", failure_rate_I_MR_AC,"\n")
print("failure_rate_I_SR_AC: ", failure_rate_inverter_SR,"\n")

# DC
# Figure: 10-ips-failure-rate-varying-r.pdf
# failure rates

xs = 1:50:500
ys_rate_R_CR_DC=similar(xs, Float64); # pre-allocate output array
ys_rate_R_IR_DC=similar(xs, Float64); # pre-allocate output array
ys_rate_R_MR_DC=similar(xs, Float64); # pre-allocate output array
ys_rate_R_SR_DC=similar(xs, Float64); # pre-allocate output array

# rectifier failure rate
@. ys_rate_R_CR_DC = rnm_CR(n, m, DC::LoadT)*xs*failure_rate_rectifier_SR 
@. ys_rate_R_IR_DC = rnm_IR(n, m, DC::LoadT)*xs*failure_rate_rectifier_SR 
@. ys_rate_R_MR_DC = rnm_MR(n, m, DC::LoadT)*xs*failure_rate_rectifier_SR 
   ys_rate_R_SR_DC .= failure_rate_rectifier_SR 

data_rate_R_DC = DataFrame(CR=ys_rate_R_CR_DC, IR=ys_rate_R_IR_DC, MR=ys_rate_R_MR_DC, SR=ys_rate_R_SR_DC)
println(data_rate_R_DC)
pretty_table(data_rate_R_DC, title="\$\\lambda_R\$")
        
@gp "set xtics nomirror" "set ytics nomirror" "set border 3" "set xlabel 'r'" "set ylabel '{/Symbol l}_R'" "set yrange [*:*]" "set key at graph 1.0, graph 0.3"
@gp :- "set logscale y" "set format y '10^{%L}'"
@gp :- "set title 'n=10, m=3, DC load'"
@gp :- xs ys_rate_R_CR_DC "with linespoints lt 4 dt 1 title 'CR'"
@gp :- xs ys_rate_R_IR_DC "with linespoints lt 8 dt 1 title 'IR'"
@gp :- xs ys_rate_R_MR_DC "with linespoints lt 3 dt 1 title 'MR'"
@gp :- xs ys_rate_R_SR_DC "with linespoints lt 6 dt 1 title 'SR'"
Gnuplot.save("10-ips-failure-rate-varying-r.pdf", term="pdfcairo")
Gnuplot.savescript("10-ips-failure-rate-varying-r.gp")

 # DC
# Figure: 15-ips-scale-factor-varying-r.pdf
# r(n,m)*r

xs = 1:50:500
ys_R_CR_DC=similar(xs, Float64); # pre-allocate output array
ys_R_IR_DC=similar(xs, Float64); # pre-allocate output array
ys_R_MR_DC=similar(xs, Float64); # pre-allocate output array
ys_R_SR_DC=similar(xs, Float64); # pre-allocate output array

# rectifier failure rate
@. ys_R_CR_DC = rnm_CR(n, m, DC::LoadT)*xs
@. ys_R_IR_DC = rnm_IR(n, m, DC::LoadT)*xs
@. ys_R_MR_DC = rnm_MR(n, m, DC::LoadT)*xs
ys_R_SR_DC .= 1

data_rnm_R_DC = DataFrame(CR=ys_R_CR_DC, IR=ys_R_IR_DC, MR=ys_R_MR_DC, SR=ys_R_SR_DC)
println(data_rnm_R_DC)
pretty_table(data_rnm_R_DC, title="r(n,m)")

@gp "set xtics nomirror" "set ytics nomirror" "set border 3" "set xlabel 'm'" "set ylabel 'r(n,m) * r'" "set yrange [*:*]" "set key at graph 1.0, graph 0.3"
@gp :- "set title 'n=10, m=3, DC load'"
@gp :- xs ys_R_CR_DC "with linespoints lt 4 dt 1 title 'CR'"
@gp :- xs ys_R_IR_DC "with linespoints lt 8 dt 1 title 'IR'"
@gp :- xs ys_R_MR_DC "with linespoints lt 3 dt 1 title 'MR'"
@gp :- xs ys_R_SR_DC "with linespoints lt 6 dt 1 title 'SR'"

Gnuplot.save("15-ips-scale-factor-varying-r.pdf", term="pdfcairo")
Gnuplot.savescript("15-ips-scale-factor-varying-r.gp")

# rate and r(n,m)
data_rate_rnm_R_DC = DataFrame(CR_rate=ys_rate_R_CR_DC, CR_rnm=ys_R_CR_DC, IR=ys_rate_R_IR_DC, IR_rnm=ys_R_IR_DC, MR=ys_rate_R_MR_DC, MR_rnm=ys_R_MR_DC, SR=ys_rate_R_SR_DC, SR_rnm=ys_R_SR_DC)
colnames=["CR, \\lambda_R", "CR, r(n,m)","IR, \\lambda_R", "IR, r(n,m)","MR, \\lambda_R", "MR, r(n,m)","SR, \\lambda_R", "SR, r(n,m)"]
rename!(data_rate_rnm_R_DC, colnames)
println(data_rate_rnm_R_DC)
pretty_table(data_rate_rnm_R_DC, title="\\lambda_R, r(n,m)", display_size=(100, 1000))

end # rate_IPS_archs
