"""
    provides
"""
provides(::Type{P}, ::Type{D}) where {P<:PolygonProvider,D<:PolygonDataset} = false


levels(::PolygonData) = nothing 
resolutions(::PolygonData) = nothing 

"""
    destination(::PolygonData{P, D}; kwargs...)
"""
destination(::PolygonData{P, D}; kwargs...) where {P <: PolygonProvider, D <: PolygonDataset} =
    joinpath(PolygonInterface._POLYGON_PATH, string(P), string(D))


"""
    postprocess
"""
postprocess(::PolygonData{P,D}, result::R) where {P,D,R} = error("`postprocess` has not been implemented for provider $P and dataset $D. An overload of the `postprocess` method is necessary for the interface.")


_extra_keychecks(::PolygonData{P,D}; kw...) where {P,D} = nothing 