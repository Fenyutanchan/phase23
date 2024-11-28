# Copyright (c) 2024 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function combine_result_main(
    s, m,
    max_den_collect_list, containing_indices_list, coefficient_list, exponent_mat;
    g=1
)
    result_directory = begin
        s_str = replace(string(s), "/" => "div")
        m_str = replace(string(m), "/" => "div")
        joinpath("wolfram_scripts", "s$(s_str)_m$(m_str)")
    end
    @assert isdir(result_directory)
    
    result_list = zeros(Basic, length(coefficient_list))
    
    for ii ∈ eachindex(max_den_collect_list)
        result_file = joinpath(result_directory, "phase$ii.txt")
        if !isfile(result_file)
            @warn "Missing result for phase$ii."
            continue
        end
    
        containing_indices = containing_indices_list[ii]
        sub_expontent_mat = exponent_mat[containing_indices, :]
    
        non_zero_col_list = findall(!iszero, eachcol(sub_expontent_mat))
        @assert length(non_zero_col_list) == 7
        sub_expontent_mat = sub_expontent_mat[:, non_zero_col_list]
    
        indices_list = [collect(row) for row ∈ eachrow(sub_expontent_mat)]
        result_dict = Dict{Vector{Int}, Basic}()
    
        for line ∈ eachline(result_file)
            line_list = split(line, "->")
            @assert length(line_list) == 2
            ν_string, result_string = line_list
    
            ν_list = map(r -> parse(Int, ν_string[r][2:end]), findall(r", -?\d", ν_string))
            @assert length(ν_list) == 7
    
            # @show result_string
            result = (Basic ∘ replace)(result_string, "`20." => "", "*^" => "e")
            # @show result
            result_dict[ν_list] = result
        end
    
        for (jj, index) ∈ zip(containing_indices, indices_list)
            @assert haskey(result_dict, index)
            result_list[jj] = result_dict[index]
        end
    end
    
    result = (expand ∘ subs)(transpose(coefficient_list) * result_list, Basic("s") => s, Basic("m") => m, Basic("g") => g)

    return result
end
