# Copyright (c) 2024 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using ArgParse
using DelimitedFiles
using FeynmanDenominators
using SymEngine

include("scripts/get_data.jl")
include("scripts/combine_result_main.jl")

function main(args=ARGS)
    max_den_collect_list, _, containing_indices_list, coefficient_list, exponent_mat = get_data("data/denMom.dat", "data/exponentMat.dat", "data/coefficientList.dat")

    arg_parse_settings = ArgParseSettings()
    @add_arg_table arg_parse_settings begin
        "-s"
            help = "Mandelstam variable s."
            default = 100
        "-m"
            help = "Mass of scalar particle."
            default = 1
        "-g"
            help = "Coupling constant."
            default = 1
    end

    arg_dict = parse_args(args, arg_parse_settings)
    s = Basic(arg_dict["s"])
    m = Basic(arg_dict["m"])
    g = Basic(arg_dict["g"])

    result = combine_result_main(
        s, m,
        max_den_collect_list, containing_indices_list, coefficient_list, exponent_mat;
        g=1
    )

    println("The result for s = $s, m = $m, and g = $g is: $result")

    return result
end

main()
