# Copyright (c) 2024 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function generate_AMFlow_wolfram_script(
    file_name::String,
    family_name::String,
    den_collect::FeynmanDenominatorCollection,
    indices_list::Vector{Vector{Int}},
    s, m
)
    file_name_ext_list = (collect ∘ splitext)(file_name)
    file_name_ext_list[end] = ".wls"
    file_name = join(file_name_ext_list)

    propagator_list = Vector{String}(undef, length(den_collect))
    for (ii, den) ∈ enumerate(den_collect)
        mom_list = den.denominator_momenta
        @assert length(den.denominator_momenta) == 1
        propagator_list[ii] = "($(first(mom_list)))^2 - msqr"
    end

    j_list = ["j[$family_name, $(join(indices, ", "))]" for indices ∈ indices_list]

    script_content = """
    #!/usr/bin/env wolframscript
    (* ::Package:: *)


    SetDirectory @ If[\$FrontEnd === Null, DirectoryName[\$InputFileName], NotebookDirectory[]];


    << AMFlow`


    SetReductionOptions["IBPReducer" -> "FiniteFlow+LiteRed"]
    AMFlowInfo["Family"] = $family_name;
    AMFlowInfo["Loop"] = {k1, k2};
    AMFlowInfo["Leg"] = {pa, pb};
    AMFlowInfo["Conservation"] = {};
    AMFlowInfo["Replacement"] = {pa^2 -> msqr, pb^2 -> msqr, (pa + pb)^2 -> s};
    AMFlowInfo["Propagator"] = {$(join(propagator_list, ", "))};
    AMFlowInfo["Numeric"] = {s -> $s, msqr -> $(m^2)};
    AMFlowInfo["NThread"] = 16;
    AMFlowInfo["Prescription"] = {0, 0};
    AMFlowInfo["Cut"] = {1, 1, 1, 0, 0, 0, 0};


    integrals = {$(join(j_list, ", "))};
    precision = 20;
    epsOrder = 4;
    sol = SolveIntegrals[integrals, precision, epsOrder];


    Export["$family_name.txt", sol];
    Exit[];
    
    """

    write(file_name, script_content)
end