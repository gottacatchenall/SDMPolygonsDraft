module PolygonInterface

const _data_storage_folders = first([
    Base.DEPOT_PATH...,
    homedir(),
])

const _POLYGON_PATH = get(ENV, "SDMLAYERS_PATH", joinpath(_data_storage_folders, "PolygonInterface"))
isdir(_POLYGON_PATH) || mkpath(_POLYGON_PATH)

using Downloads
using ZipArchives
using Proj 
using GeoJSON
using HTTP


using DataFrames, CSV 

_GADM_MAX_LEVELS = Dict([r[Symbol("alpha-3")]=>r.max_level for r in eachrow(CSV.read("assets/GADM.csv", DataFrame))])


import GeoJSON as GJ 
import Shapefile as SF 
import GeoInterface as GI 
import ArchGDAL as AG
import NaturalEarth as NE

include(joinpath("types", "datasets.jl"))
export PolygonDataset
export Land, Oceans, Lakes, Countries, Ecoregions, CoralReefs, ParksAndProtected

include(joinpath("types", "providers.jl"))
export PolygonProvider
export EPA, NaturalEarth, OpenStreetMap, UCDavis

include(joinpath("types", "filetypes.jl"))
export _file, _zip
export _geojson, _shapefile

include(joinpath("types", "specifiers.jl"))
export PolygonData

include(joinpath("types", "geometry.jl"))
export FeatureCollection, Feature, Polygon, MultiPolygon

include("interface.jl")
export provides 

include("downloader.jl")
export downloader

export downloadtype, filetype

include(joinpath("providers", "epa.jl"))
include(joinpath("providers", "naturalearth.jl"))
include(joinpath("providers", "openstreetmap.jl"))
include(joinpath("providers", "ucdavis.jl"))


end # module PolygonInterface
