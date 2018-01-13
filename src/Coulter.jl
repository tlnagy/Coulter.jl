module Coulter

    __precompile__()

    using KernelDensity
    using Distributions
    import Base.-, Base.deepcopy

    export CoulterCounterRun, loadZ2, volume, extract_peak, extract_peak_interval, -

    include("utils.jl")

    """
    A simplified representation of a coulter counter run
    """
    type CoulterCounterRun
        filename::String
        sample::String
        timepoint::DateTime
        binheights::Vector{Int}
        binlims::Vector{Float64}
        data::Vector{Float64}
        params::Dict{String, Any}
    end

    include("analysis.jl")

    # copy constructor
    deepcopy(a::CoulterCounterRun) = CoulterCounterRun([deepcopy(getfield(a, field)) for field in fieldnames(CoulterCounterRun)]...)

    """
    loadZ2(filename::String, sample::String)

    Loads `filename` and assigns it a sample, returns a
    `CoulterCounterRun` object
    """
    function loadZ2(filepath::String, sample::String)
        open(filepath) do s
            # split windows newlines if present
            filebody = replace(readstring(s), "\r\n", "\n")
            # extract start time and date from body
            datetime = match(r"^StartTime= \d*\s*(?<time>\d*:\d*:\d*)\s*(?<date>\d*\s\w{3}\s\d{4})$"m, filebody)
            timepoint = DateTime("$(datetime[:date]) $(datetime[:time])", "dd uuu yyy HH:MM:SS")
            params = Dict{String, Any}()
            params["Current"] = parse(Float64, match(r"^Cur=([+-]?[0-9]*[.]?[0-9]+)$"m, filebody)[1])
            params["Pre-Amp Gain"] = parse(Float64, match(r"^PAGn=([+-]?[0-9]*[.]?[0-9]+)$"m, filebody)[1])
            params["Volume metered"] = parse(Float64, match(r"^Vol=([+-]?[0-9]*[.]?[0-9]+)$"m, filebody)[1])

            # extract data
            matcheddata = match(r"^\[#Bindiam\]\n(?<binlims>.*?)\n^\[Binunits\].*?\[#Binheight\]\n(?<binheight>.*?)\n^\[end\]"sm, filebody)
            binheights = [parse(Int64, x) for x in split(matcheddata[:binheight], "\n ")]
            binlims = [parse(Float64, x) for x in split(matcheddata[:binlims], "\n ")]

            # unbin data, i.e. the inverse of the hist function
            data = repvec(binlims, binheights)

            CoulterCounterRun(basename(filepath), sample, timepoint, binheights, binlims, data, params)
        end
    end

    loadZ2(filepath::String) = loadZ2(filepath, "N/A")

    -(a::CoulterCounterRun, b::CoulterCounterRun) = a.timepoint - b.timepoint
    -(a::CoulterCounterRun, b::DateTime) = a.timepoint - b
end
