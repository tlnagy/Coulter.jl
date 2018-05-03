"""
    repvec(orig, reps)

Repeats the items in the first vector by the corresponding number of
times in the second vector. Essentially the inverse operation of `hist`
"""
function repvec{T}(orig::Vector{T}, reps::Vector{Int})
    (length(orig) != length(reps)) && error("Provided vectors have to be of same length")
    data = Array{T}(sum(reps))
    j = 1
    for i in 1:length(orig)
        if reps[i] > 0
            data[j:(j+reps[i]-1)] = orig[i]
            j += reps[i]
        end
    end
    data
end

"""
    volume(diameter)

Given the `diameter` of a sphere, return its volume
"""
volume(diameter::Number) = 4/3*π*(diameter/2)^3

"""
    diameter(volume)

Given the `volume` of a sphere, compute its diameter
"""
diameter(volume::Number) = 2*(3/4*volume/π)^(1/3)
