"""
    extract_peak_interval(run; α, n)

Takes a CoulterCounterRun `run` and fits a kernel density estimate to smooth
out binning effects by the machine and then finds the largest peak. It returns
the diameter corresponding to the location of this peak as well as the max and
min diameters of the confidence interval defined by `α`. This interval is
generated on the empirically by bootstrapping the data `n` times.
"""
function extract_peak_interval(run::CoulterCounterRun; α=0.05, n=250)
    alloc = zeros(length(run.data))
    results = zeros(n)
    data = volume.(run.data)
    orig_est = extract_peak(data)
    for i in 1:n
        sample!(data, alloc)
        results[i] = extract_peak(alloc)
    end
    sort!(results[.!isnan.(results)])
    # update n since we might have deleted some values due to NaNs
    n = length(results)

    orig_est, max(orig_est, results[ceil(Int, (1-α/2)*n)]), min(orig_est, results[floor(Int, (α/2)*n+1)])
end

function extract_peak(data::Array)
    kd_est = kde(volume.(data))
    _find_peaks(collect(kd_est.x), kd_est.density)[end]
end

extract_peak(run::CoulterCounterRun) = extract_peak(run.data)


"""
    _find_peaks(xs, ys; minx, miny)

Finds prominent peaks in `ys` and returns the values from `xs` corresponding to
the location of these peaks. `minx` and `miny` can be used to exclude peaks that
are too small in `x` or `y`.
"""
function _find_peaks{T}(xs::Array{T}, ys::Array{T}; minx=310, miny=0.0005)
    loc = zero(T) # location of an extremum
    width = zero(T) # width of an extremum
    sign = -1
    extrema = T[]
    heights = T[miny]
    is_peak = Bool[]
    for i in 2:length(ys)
        if ys[i] > ys[i-1]
            if sign < 0 && width > 0
                push!(extrema, loc/width)
                push!(heights, ys[i-1])
                push!(is_peak, false)
                loc = 0
                width = 0
            end
            loc = xs[i]
            width = 1
            sign = 1
        elseif ys[i] == ys[i-1]
            loc += xs[i]
            width += 1
        elseif ys[i] < ys[i-1]
            if sign > 0 && width > 0
                push!(extrema, loc/width)
                push!(heights, ys[i-1])
                push!(is_peak, true)
                loc = 0
                width = 0
            end
            loc = xs[i]
            width = 1
            sign = -1
        end
    end

    for i in 2:length(is_peak)
        # This should only be triggered if a peak is not followed by a valley, or vice versa
        if !xor(is_peak[i], is_peak[i-1])
            warn("Unable to establish prominence. Peak identification potentially flawed.")
            break
        end
    end

    push!(heights, miny)

    peaks = T[]
    # peaks are every second value in heights
    for i in 2:2:length(heights)-1
        # peak shows significant prominence versus their adjacent vallies
        if abs(log2(heights[i]./heights[i-1])+log2(heights[i]./heights[i+1])) .> 0.5
            if extrema[i-1] > minx && heights[i] > miny
                push!(peaks, extrema[i-1])
            end
        end
    end
    if length(peaks) > 1
        warn("Multiple viable peaks identified: $(join(peaks, ", "))")
    end
    peaks
end
