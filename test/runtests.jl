using Coulter
using Base.Test

@testset "Loading" begin
    data = loadZ2("testdata/b_0_1.=#Z2", "blank")

    @test data.timepoint == DateTime(2017, 12, 22, 17, 46, 58)
    @test all(data.binheights .== 0.0)
end

@testset "Misc" begin
    @test volume(0.0) == 0.0
    @test volume(10.0) ≈ 523.59878
end
