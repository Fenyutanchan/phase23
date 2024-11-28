# Copyright (c) 2024 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function generate_script_main(s, m, max_den_collect_list, containing_indices_list, exponent_mat)
    source_directory = begin
        s_str = replace(string(s), "/" => "div")
        m_str = replace(string(m), "/" => "div")
        joinpath("wolfram_scripts", "s$(s_str)_m$(m_str)")
    end
    if !isdir(source_directory)
        rm(source_directory; force=true, recursive=true)
        mkdir(source_directory)
    end
    
    open(joinpath(source_directory, "run.sh"), "w+") do io
        write(io, "echo \"Start Time: \$(date +%H:%M:%S)\"\n")
    
        count = 0
    
        for (ii, max_den_collect) ∈ enumerate(max_den_collect_list)
            containing_indices = containing_indices_list[ii]
            sub_expontent_mat = exponent_mat[containing_indices, :]
            # (println ∘ string)(sub_expontent_mat)
    
            non_zero_col_list = findall(!iszero, eachcol(sub_expontent_mat))
            # @show length(non_zero_col_list)
            # @show non_zero_col_list
            @assert length(non_zero_col_list) == 7
            sub_expontent_mat = sub_expontent_mat[:, non_zero_col_list]
            # sub_expontent_mat = hcat(ones(Int, length(containing_indices), 3), sub_expontent_mat)
    
            indices_list = [collect(row) for row ∈ eachrow(sub_expontent_mat)]
            generate_AMFlow_wolfram_script(
                joinpath(source_directory, "phase$ii"), "phase$ii",
                max_den_collect, indices_list, 4,
                s, m
            )
            write(io, "WolframKernel -script phase$ii.wls > phase$ii.log &\n")
            count += 1
            if count == 4
                write(io, "wait\n")
                count = 0
            end
        end
    
        count == 0 || write(io, "wait\n")
        write(io, "echo \"End Time: \$(date +%H:%M:%S)\"\n")
    end
    
    write(joinpath(source_directory, ".gitignore"), "cache/\n\n*.log\n")
    
    chmod(joinpath(source_directory, "run.sh"), 0o755)
end
