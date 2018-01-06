using Coulter
using Base.Test

# write your own tests here
@test volume(0.0) = 0.0
@test volume(10.0) ≈ 523.59878
