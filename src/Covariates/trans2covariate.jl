struct Trans2Covariate{S<:AbstractFloat, T<:AbstractFloat, U<:AbstractFloat} <: AbstractCovariate{U}
    name::String
    basecovariate1::AbstractCovariate{S}
    basecovariate2::AbstractCovariate{T}
    transform::Function
end

Base.length(var::Trans2Covariate) = length(var.basecovariate1)

function Trans2Covariate(name::String, basecovariate1::AbstractCovariate{S}, basecovariate2::AbstractCovariate{T},
                        transform::Function) where {S<:AbstractFloat} where {T<:AbstractFloat}
    U = promote_type(S, T)
    Trans2Covariate{S, T, U}(name, basecovariate1, basecovariate2, transform)
end

function slice(covariate::Trans2Covariate{S, T, U}, fromobs::Integer, toobs::Integer, slicelength::Integer) where {S<:AbstractFloat} where {T<:AbstractFloat} where {U<:AbstractFloat}
    basecov1 = covariate.basecovariate1
    basecov2 = covariate.basecovariate2
    f = covariate.transform
    slices = zip2(slice(basecov1, fromobs, toobs, slicelength), slice(basecov2, fromobs, toobs, slicelength)) 
    mapslice2(f, slices, slicelength, U)
end