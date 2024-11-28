# Copyright (c) 2024 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function get_data(
    den_list_file::String,
    exponent_mat_file::String,
    coefficient_list_file::String
)

    loop_momenta = ["k1", "k2"]
    external_momenta = ["pa", "pb"]

    den_list = map(den_mom -> FeynmanDenominator(den_mom, "m", 0; loop_momenta=loop_momenta, external_momenta=external_momenta), readlines(den_list_file))
    exponent_mat = readdlm(exponent_mat_file, '\t', Int, '\n'; header=false)
    coefficient_list = map(Basic, readlines(coefficient_list_file))

    den_collect_list = FeynmanDenominatorCollection[]

    for exponent_list ∈ eachrow(exponent_mat)
        # any(iszero, exponent_list[1:3]) && continue
        den_indices = findall(!iszero, exponent_list)
        # println(den_indices)
        # (println ∘ string ∘ FeynmanDenominatorCollection)(loop_momenta, external_momenta, den_list[den_indices])
        push!(den_collect_list,
            FeynmanDenominatorCollection(loop_momenta, external_momenta, den_list[den_indices])
        )
    end

    max_num_den, _ = findmax(length, den_collect_list)
    @assert max_num_den == 7
    max_den_collect_list = den_collect_list[findall(==(max_num_den) ∘ length, den_collect_list)]

    containing_indices_list = [Int[] for _ ∈ eachindex(max_den_collect_list)]

    for (ii, den_collect) ∈ enumerate(den_collect_list)
        ii_flag = false
        for (jj, max_den_collect) ∈ enumerate(max_den_collect_list)
            if den_collect ⊆ max_den_collect
                # @show exponent_mat[ii, :]
                push!(containing_indices_list[jj], ii)
                ii_flag = true
                break
            end
        end

        ii_flag &&
            @assert any(iszero, exponent_mat[ii, :]) """
            Denominator collection $ii is not contained in the maximal one:
            $(string(den_collect))
            """
    end

    max_num_den, _ = findmax(length, den_collect_list)
    @assert max_num_den == 7
    max_den_collect_list = den_collect_list[findall(==(max_num_den) ∘ length, den_collect_list)]

    containing_indices_list = [Int[] for _ ∈ eachindex(max_den_collect_list)]

    for (ii, den_collect) ∈ enumerate(den_collect_list)
        ii_flag = false
        for (jj, max_den_collect) ∈ enumerate(max_den_collect_list)
            if den_collect ⊆ max_den_collect
                # @show exponent_mat[ii, :]
                push!(containing_indices_list[jj], ii)
                ii_flag = true
                break
            end
        end

        ii_flag &&
            @assert any(iszero, exponent_mat[ii, :]) """
            Denominator collection $ii is not contained in the maximal one:
            $(string(den_collect))
            """
    end

    return max_den_collect_list, den_collect_list, containing_indices_list, coefficient_list, exponent_mat
end
