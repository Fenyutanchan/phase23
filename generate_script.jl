# Copyright (c) 2024 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using ArgParse
using DelimitedFiles
using FeynmanDenominators
using SymEngine

include("scripts/get_data.jl")
include("scripts/generate_AMFlow_wolfram_script.jl")
include("scripts/generate_script_main.jl")

function main(args=ARGS)
    max_den_collect_list, _, containing_indices_list, _, exponent_mat = get_data("data/denMom.dat", "data/exponentMat.dat", "data/coefficientList.dat")

    arg_parse_settings = ArgParseSettings()
    @add_arg_table arg_parse_settings begin
        "-s"
            help = "Mandelstam variable s."
            default = 100
        "-m"
            help = "Mass of scalar particle."
            default = 1
    end

    arg_dict = parse_args(args, arg_parse_settings)
    s = Basic(arg_dict["s"])
    m = Basic(arg_dict["m"])

    generate_script_main(s, m, max_den_collect_list, containing_indices_list, exponent_mat)
end

main()
