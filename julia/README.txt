To generate cost figures and numerical results,
run scripts:

cd Fig_src/julia
bin/go.sh > cost_IPS_archs_results.txt

or

cd Fig_src/julia
./cost_IPS_archs.jl > cost_IPS_archs_results.txt

DC:
20b-ips-cost-varying-m.pdf
20a-ips-cost-varying-m.pdf

AC:
30b-ips-cost-varying-m.pdf
30a-ips-cost-varying-m.pdf

To generate figures showing how failure rates and r(n,m) vary as r changes,
and corresponding numerical results
run commands:

cd Fig_src/julia
julia rate_IPS_archs.jl > rate_IPS_archs_results.txt

