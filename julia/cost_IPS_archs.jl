# IPS costs for different architectures
# get costs from octave MTBF results 
module cost_IPS_archs

using CSV
# https://dataframes.juliadata.org/stable/man/working_with_dataframes/
using DataFrames

using Printf
using Gnuplot

@enum LoadT begin
           DC = 1
           AC = 2
end

function cost_ips_CR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F, MTBF, loadtype) 

    # costs per year basis

    # R: rectifier
    cost_single_rectifier_SR=cost_rectifier_SR/2
    cost_rectifier_module=k_scale_rectifier_mod*cost_single_rectifier_SR/n
    cost_total_rectifier=(n+m)*cost_rectifier_module + log((n+m)+(n+m)*(n+m))*cost_rectifier_complexity

    # B: battery
    cost_single_battery_SR=cost_battery_SR/2
    cost_battery_module=k_scale_battery_mod*cost_single_battery_SR/n
    if loadtype == DC::LoadT
        cost_total_battery=(n+m)*cost_battery_module + log((n+m)+(n+m)*(n+m))* cost_battery_complexity
    else # AC load
        cost_total_battery=(n+m)*cost_battery_module + log(2*(n+m)*(n+m))* cost_battery_complexity
    end

    # I: inverter (only for AC)
    cost_total_inverter=0
    if loadtype == AC::LoadT
        cost_single_inverter_SR=cost_inverter_SR/2
        cost_inverter_module=k_scale_inverter_mod*cost_single_inverter_SR/n
        cost_total_inverter=(n+m)*cost_inverter_module + log((n+m)+(n+m)*(n+m))* cost_inverter_complexity
    end

    n_failures_peryear=8760/MTBF
    cost_failure=n_failures_peryear * cost_F
    cost_ips=cost_total_rectifier + cost_total_battery + cost_total_inverter + cost_failure
end


function cost_ips_IR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F, MTBF, loadtype) 

    # costs per year basis

    # R: rectifier
    cost_single_rectifier_SR=cost_rectifier_SR/2
    cost_rectifier_module=k_scale_rectifier_mod*cost_single_rectifier_SR/n
    cost_total_rectifier=(n+m)*cost_rectifier_module + log((n+m)+(n+m))*cost_rectifier_complexity

    # B: battery
    cost_single_battery_SR=cost_battery_SR/2
    cost_battery_module=k_scale_battery_mod*cost_single_battery_SR/n
    cost_total_battery=(n+m)*cost_battery_module + log((n+m)+(n+m))* cost_battery_complexity
    
    # I: inverter (only for AC)
    cost_total_inverter=0
    if loadtype == AC::LoadT
        cost_single_inverter_SR=cost_inverter_SR/2
        cost_inverter_module=k_scale_inverter_mod*cost_single_inverter_SR/n
        cost_total_inverter=(n+m)*cost_inverter_module + log((n+m)+(n+m))* cost_inverter_complexity
    end
    
    n_failures_peryear=8760/MTBF
    cost_failure=n_failures_peryear * cost_F
    cost_ips=cost_total_rectifier + cost_total_battery + cost_total_inverter + cost_failure
end

function cost_ips_MR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F, MTBF, loadtype) 

    # costs per year basis
    
    # R: rectifier
    cost_single_rectifier_SR=cost_rectifier_SR/2
    cost_rectifier_module=k_scale_rectifier_mod*cost_single_rectifier_SR/n
    cost_total_rectifier=(n+m)*cost_rectifier_module + log((n+m)+(n+m))*cost_rectifier_complexity

    # B: battery
    cost_single_battery_SR=cost_battery_SR/2
    if loadtype == DC::LoadT
        cost_total_battery=2*cost_single_battery_SR + log((n+m)+1)* cost_battery_complexity
    else # AC load
        cost_total_battery=2*cost_single_battery_SR + log((n+m)*(n+m))* cost_battery_complexity
    end
    
    # I: inverter (only for AC)
    cost_total_inverter=0
    if loadtype == AC::LoadT
        cost_single_inverter_SR=cost_inverter_SR/2
        cost_inverter_module=k_scale_inverter_mod*cost_single_inverter_SR/n
        cost_total_inverter=(n+m)*cost_inverter_module + log((n+m)+(n+m))* cost_inverter_complexity
    end
    
    n_failures_peryear=8760/MTBF
    cost_failure=n_failures_peryear * cost_F
    cost_ips=cost_total_rectifier + cost_total_battery + cost_total_inverter + cost_failure
end

function cost_ips_SR(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F, MTBF, loadtype) 

    # costs per year basis

    # R: rectifier
    cost_total_rectifier=cost_rectifier_SR

    # B: battery
    cost_total_battery=cost_battery_SR
    
    # I: inverter (only for AC)
    cost_total_inverter=0
    if loadtype == AC::LoadT
        cost_total_inverter=cost_inverter_SR
    end
    
    n_failures_peryear=8760/MTBF
    cost_failure=n_failures_peryear * cost_F

    cost_ips=cost_total_rectifier + cost_total_battery + cost_total_inverter + cost_failure
end

# csv file, from octave
csvpath1="./csv/results-r17-muU2-lambdaD0.125-varying-m.csv"
csvpath2="./csv/results-AC-r17-muU2-lambdaD0.125-varying-m.csv"
csvbasename1=basename(csvpath1)
csvbasename2=basename(csvpath2)
csvname1=split(csvbasename1, ".")[1]
csvname2=split(csvbasename2, ".")[1]

println("csvpath: ", csvpath1)
println("csvpath: ", csvpath2)
println("csvbasename: ", csvbasename1)
println("csvbasename: ", csvbasename2)
println("csvname: ", csvname1)
println("csvname: ", csvname2)

# reading the csv file 
df_DC=CSV.read(csvpath1, delim=',', DataFrame, header = false)
df_AC=CSV.read(csvpath2, delim=',', DataFrame, header = false)

##### DC
println(df_DC)

# CR
MTBF_DC_CR=df_DC[:, 9]
print(MTBF_DC_CR,"\n")

# IR
MTBF_DC_IR=df_DC[:, 7]
print(MTBF_DC_IR,"\n")

# MR
MTBF_DC_MR=df_DC[:, 5]
print(MTBF_DC_MR,"\n")

# SR
MTBF_DC_SR=df_DC[:, 3]
print(MTBF_DC_SR,"\n")

###### AC
println(df_AC)

# CR
MTBF_AC_CR=df_AC[:, 9]
print(MTBF_AC_CR,"\n")

# IR
MTBF_AC_IR=df_AC[:, 7]
print(MTBF_AC_IR,"\n")

# MR
MTBF_AC_MR=df_AC[:, 5]
print(MTBF_AC_MR,"\n")

# SR
MTBF_AC_SR=df_AC[:, 3]
print(MTBF_AC_SR,"\n")

# redundancy
n=10
m=3

# costs
cost_rectifier_SR=1000
cost_battery_SR=2000
cost_inverter_SR=3000

k_scale_rectifier_mod=0.8
k_scale_battery_mod=1
k_scale_inverter_mod=1.1

cost_rectifier_complexity=10
cost_battery_complexity=10
cost_inverter_complexity=10

# cost CR, cF=0
cost_CR_DC=cost_ips_CR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, 0, 1, DC::LoadT)
cost_CR_AC=cost_ips_CR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, 0, 1, AC::LoadT)

# cost IR, cF=0
cost_IR_DC=cost_ips_IR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, 0, 1, DC::LoadT)
cost_IR_AC=cost_ips_IR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, 0, 1, AC::LoadT)

# cost MR, cF=0
cost_MR_DC=cost_ips_MR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, 0, 1, DC::LoadT)
cost_MR_AC=cost_ips_MR(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, 0, 1, AC::LoadT)

# cost SR, cF=0
cost_SR_DC=cost_ips_SR(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, 0, 1, DC::LoadT)
cost_SR_AC=cost_ips_SR(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, 0, 1, AC::LoadT)

# DC load
print("cost_CR_DC: ", cost_CR_DC,", m=",m,"\n")
print("cost_IR_DC: ", cost_IR_DC,", m=",m,"\n")
print("cost_MR_DC: ", cost_MR_DC,", m=",m,"\n")
print("cost_SR_DC: ", cost_SR_DC,"\n")
# AC load
print("cost_CR_AC: ", cost_CR_AC,", m=",m,"\n")
print("cost_IR_AC: ", cost_IR_AC,", m=",m,"\n")
print("cost_MR_AC: ", cost_MR_AC,", m=",m,"\n")
print("cost_SR_AC: ", cost_SR_AC,"\n")

# DC load
print("cost_CR_DC/cost_SR_DC: ", cost_CR_DC/cost_SR_DC,", m=",m,"\n")
print("cost_IR_DC/cost_SR_DC: ", cost_IR_DC/cost_SR_DC,", m=",m,"\n")
print("cost_MR_DC/cost_SR_DC: ", cost_MR_DC/cost_SR_DC,", m=",m,"\n")
# AC load
print("cost_CR_AC/cost_SR_AC: ", cost_CR_AC/cost_SR_AC,", m=",m,"\n")
print("cost_IR_AC/cost_SR_AC: ", cost_IR_AC/cost_SR_AC,", m=",m,"\n")
print("cost_MR_AC/cost_SR_AC: ", cost_MR_AC/cost_SR_AC,", m=",m,"\n")


# DC
# Figure: 20a0-ips-cost-varying-m.pdf
cost_F_DC=0.01*cost_SR_DC

ms = 1:6

y_DC_CR = cost_ips_CR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_CR, DC::LoadT)
y_DC_IR = cost_ips_IR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_IR, DC::LoadT)
y_DC_MR = cost_ips_MR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_MR, DC::LoadT)
y_DC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_DC, MTBF_DC_SR, DC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set border 3" "set xlabel 'm'" "set ylabel 'C_F'" "set yrange [*:*]" "set key at graph 1.0, graph 0.65"
@gp :- "set title '{/Symbol g}_F=0.01*{/Symbol g}_{SR}'"
@gp :- ms y_DC_SR "with linespoints lt 6 dt 1 title 'SR'"
@gp :- ms y_DC_CR "with linespoints lt 4 dt 1 title 'CR'"
@gp :- ms y_DC_IR "with linespoints lt 8 dt 1 title 'IR'"
@gp :- ms y_DC_MR "with linespoints lt 3 dt 1 title 'MR'"
Gnuplot.save("20a0-ips-cost-varying-m.pdf", term="pdfcairo")
Gnuplot.savescript("20a0-ips-cost-varying-m.gp")

# DC
# Figure: 20a-ips-cost-varying-m.pdf
cost_F_DC=0.2*cost_SR_DC

ms = 1:6

y_DC_CR = cost_ips_CR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_CR, DC::LoadT)
y_DC_IR = cost_ips_IR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_IR, DC::LoadT)
y_DC_MR = cost_ips_MR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_MR, DC::LoadT)
y_DC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_DC, MTBF_DC_SR, DC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set notitle" "set border 3" "set xlabel 'm'" "set ylabel 'C_F'" "set key at graph 1.0, graph 0.65"
@gp :- "set yrange [1600:3600]" 
@gp :- "set ytics add ('1600' 1600, '3600' 3600)"
@gp :- ms y_DC_SR "with linespoints lt 6 dt 1 title 'SR'"
@gp :- ms y_DC_CR "with linespoints lt 4 dt 1 title 'CR'"
@gp :- ms y_DC_IR "with linespoints lt 8 dt 1 title 'IR'"
@gp :- ms y_DC_MR "with linespoints lt 3 dt 1 title 'MR'"
Gnuplot.save("20a-ips-cost-varying-m.pdf", term="pdfcairo")
Gnuplot.savescript("20a-ips-cost-varying-m.gp")

# DC
# Figure: 20b-ips-cost-varying-m.pdf
cost_F_DC=0.5*cost_SR_DC
    
ms = 1:6

y_DC_CR = cost_ips_CR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_CR, DC::LoadT)
y_DC_IR = cost_ips_IR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_IR, DC::LoadT)
y_DC_MR = cost_ips_MR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_MR, DC::LoadT)
y_DC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_DC, MTBF_DC_SR, DC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set notitle" "set border 3" "set xlabel 'm'" "set ylabel 'C_F'" "set key at graph 1.0, graph 0.65"
@gp :- "set yrange [1600:3600]" 
@gp :- "set ytics add ('1600' 1600, '3600' 3600)"
@gp :- ms y_DC_MR "with linespoints lt 3 dt 1 title 'MR'"
@gp :- ms y_DC_SR "with linespoints lt 6 dt 1 title 'SR'"
@gp :- ms y_DC_CR "with linespoints lt 4 dt 1 title 'CR'"
@gp :- ms y_DC_IR "with linespoints lt 8 dt 1 title 'IR'"
Gnuplot.save("20b-ips-cost-varying-m.pdf", term="pdfcairo")
Gnuplot.savescript("20b-ips-cost-varying-m.gp")

# DC
# Figure: 20b-ips-cost-varying-m.pdf
cost_F_DC=10*cost_SR_DC
    
ms = 1:6

y_DC_CR = cost_ips_CR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_CR, DC::LoadT)
y_DC_IR = cost_ips_IR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_IR, DC::LoadT)
y_DC_MR = cost_ips_MR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DC, MTBF_DC_MR, DC::LoadT)
y_DC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_DC, MTBF_DC_SR, DC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set border 3" "set xlabel 'm'" "set ylabel 'C_F'" "set key at graph 1.0, graph 0.65"
@gp :- "set title '{/Symbol g}_F=10*{/Symbol g}_{SR}'"
@gp :- ms y_DC_SR "with linespoints lt 6 dt 1 title 'SR'"
@gp :- ms y_DC_MR "with linespoints lt 3 dt 1 title 'MR'"
@gp :- ms y_DC_CR "with linespoints lt 4 dt 1 title 'CR'"
@gp :- ms y_DC_IR "with linespoints lt 8 dt 1 title 'IR'"
Gnuplot.save("20b1-ips-cost-varying-m.pdf", term="pdfcairo")
Gnuplot.savescript("20b1-ips-cost-varying-m.gp")


# AC
# Figure: 30a-ips-cost-varying-m.pdf
cost_F_AC=0.2*cost_SR_AC
    
ms = 1:6

y_AC_CR = cost_ips_CR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_AC, MTBF_AC_CR, AC::LoadT)
y_AC_IR = cost_ips_IR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_AC, MTBF_AC_IR, AC::LoadT)
y_AC_MR = cost_ips_MR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_AC, MTBF_AC_MR, AC::LoadT)
y_AC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_AC, MTBF_AC_SR, AC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set notitle" "set border 3" "set xlabel 'm'" "set ylabel 'C_F'" "set yrange [*:*]" "set key at graph 1.0, graph 0.7"
@gp :- "set ytics add ('5000' 5000, '15000' 15000)"
@gp :- ms y_AC_SR "with linespoints lt 6 dt 2 title 'SR'"
@gp :- ms y_AC_CR "with linespoints lt 4 dt 2 title 'CR'"
@gp :- ms y_AC_IR "with linespoints lt 8 dt 2 title 'IR'"
@gp :- ms y_AC_MR "with linespoints lt 3 dt 2 title 'MR'"
Gnuplot.save("30a-ips-cost-varying-m.pdf", term="pdfcairo")
Gnuplot.savescript("30a-ips-cost-varying-m.gp")


# AC
# Figure: 30b-ips-cost-varying-m.pdf
cost_F_AC=0.5*cost_SR_AC
    
ms = 1:6

y_AC_CR = cost_ips_CR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_AC, MTBF_AC_CR, AC::LoadT)
y_AC_IR = cost_ips_IR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_AC, MTBF_AC_IR, AC::LoadT)
y_AC_MR = cost_ips_MR.(n, ms, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_AC, MTBF_AC_MR, AC::LoadT)
y_AC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_AC, MTBF_AC_SR, AC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set notitle" "set border 3" "set xlabel 'm'" "set ylabel 'C_F'" "set yrange [*:*]" "set key at graph 1.0, graph 0.7"
@gp :- "set ytics add ('5000' 5000, '15000' 15000)"
@gp :- ms y_AC_SR "with linespoints lt 6 dt 2 title 'SR'"
@gp :- ms y_AC_MR "with linespoints lt 3 dt 2 title 'MR'"
@gp :- ms y_AC_CR "with linespoints lt 4 dt 2 title 'CR'"
@gp :- ms y_AC_IR "with linespoints lt 8 dt 2 title 'IR'"
Gnuplot.save("30b-ips-cost-varying-m.pdf", term="pdfcairo")
Gnuplot.savescript("30b-ips-cost-varying-m.gp")

# DC
# Figure: 20c-ips-cost-varying-cost_F.pdf
#cost_F_DC=0.01*cost_SR_DC
cost_F_DCs = [0.01*cost_SR_DC, 0.2*cost_SR_DC, 0.3*cost_SR_DC, 0.4*cost_SR_DC, 0.5*cost_SR_DC, 1*cost_SR_DC]

y_DC_CR = cost_ips_CR.(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DCs, MTBF_DC_CR, DC::LoadT)
y_DC_IR = cost_ips_IR.(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DCs, MTBF_DC_IR, DC::LoadT)
y_DC_MR = cost_ips_MR.(n, m, cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, k_scale_rectifier_mod, k_scale_battery_mod, k_scale_inverter_mod, cost_rectifier_complexity, cost_battery_complexity, cost_inverter_complexity, cost_F_DCs, MTBF_DC_MR, DC::LoadT)
y_DC_SR= cost_ips_SR.(cost_rectifier_SR, cost_battery_SR, cost_inverter_SR, cost_F_DCs, MTBF_DC_SR, DC::LoadT)
@gp "set xtics nomirror" "set ytics nomirror" "set border 3" "set xlabel '{/Symbol g}_F'" "set ylabel 'C_F'" "set yrange [*:*]" "set key at graph 1.0, graph 0.65"
@gp :- "set title 'm=3'"
@gp :- cost_F_DCs y_DC_SR "with linespoints lt 6 dt 1 title 'SR'"
@gp :- cost_F_DCs y_DC_CR "with linespoints lt 4 dt 1 title 'CR'"
@gp :- cost_F_DCs y_DC_IR "with linespoints lt 8 dt 1 title 'IR'"
@gp :- cost_F_DCs y_DC_MR "with linespoints lt 3 dt 1 title 'MR'"
Gnuplot.save("20c-ips-cost-varying-cost_F.pdf", term="pdfcairo")
Gnuplot.savescript("20c-ips-cost-varying-cost_F.gp")

end # cost_IPS_archs
