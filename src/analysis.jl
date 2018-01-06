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
    orig_est = extract_peak(run.data)
    for i in 1:n
        sample!(run.data, alloc)
        results[i] = extract_peak(alloc)
    end
    sort!(results)

    orig_est, results[ceil(Int, (1-α/2)*n)], results[floor(Int, (α/2)*n+1)]
end

function extract_peak(data::Array)
    kd_est = kde(data)
    return volume(kd_est.x[findmax(kd_est.density)[2]])
end

extract_peak(run::CoulterCounterRun) = extract_peak(run.data)
