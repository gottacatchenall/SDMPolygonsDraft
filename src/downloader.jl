function downloader(
    data::PolygonData{P,D};
    kw...
) where {P,D}
    keychecker(data; kw...)
    dt = downloadtype(data)
    url, filename, dir = source(data; kw...)

    downloaded_path = _download(dt, url, filename, dir)
    return postprocess(data, _read(filetype(data), downloaded_path); kw...)
    
    # SDMDatasets and SDMLayers interface without knowing anything about each other. Datasets returns the path to the file, and the SDMLayer constructor works directly on the path 
    # I can't come find a way to make this form work cleanly w/ Polygons (so far) because the properties to extract are associated with the specific provider/dataset. To access the properties, you have to read it w/ GeoJSON/Shapefile.jl

    # A possible solution is to parse the properties here into a dict and have the downloader return a (path,properties) tuple which can be passed to a Feature constructor.
    # However, this means reading the file using GeoJSON/Shapefile twice (once here, once when the path is passed on), which obviously is inefficient. Maybe this doesn't matter? E.g. for level 3 ecoregions its .015 seconds. So even for big files it's probably fine 

    # But...if you are loading a feature collection, the features are associated with each feature. So you have a vector of feature dicts.  

    # Another option is to drop the idea of keeping any properties at all, but this kinda sucks. 
    

    #postprocess(data, _read(filetype(data), downloaded_path); kw...)
end

function _download(::Type{_File}, url, filename, dir)
    isdir(dir) || mkpath(dir)

    # Check for file existence, download if not
    !isfile(joinpath(dir, filename)) && Downloads.download(url, joinpath(dir, filename))

    return joinpath(dir, filename)
end

function _download(::Type{_Zip}, url, filename, dir)
    isdir(dir) || mkpath(dir)

    # Check for file existence, download if not
    !isfile(joinpath(dir, filename)) && Downloads.download(url, joinpath(dir, filename))

    zip_path = joinpath(dir, filename)
    target_dir = joinpath(dir, String(split(zip_path, ".zip")[1]))
    !isdir(target_dir) && _unzip(zip_path, target_dir)
    return target_dir
end

function _unzip(zip_path, target_dir)
    mkdir(target_dir)
    zip_archive = ZipArchives.ZipReader(read(zip_path))
    for file_in_zip in ZipArchives.zip_names(zip_archive)
        out = open(joinpath(target_dir, file_in_zip), "w")
        write(out, ZipArchives.zip_readentry(zip_archive, file_in_zip, String))
        close(out)
    end
end

function keychecker(data::P; kwargs...) where {P<:PolygonData}

    # Check for levels
    if :level in keys(kwargs)
        isnothing(levels(data)) && error("The $(P) dataset does not allow for month as a keyword argument")
        values(kwargs).level ∉ levels(data) && error("The level $(values(kwargs).level) is not supported by the $(P) dataset")
    end

    # Check for resolution
    if :resolution in keys(kwargs)
        isnothing(resolutions(data)) && error("The $(P) dataset does not support multiple resolutions")
        
        values(kwargs).resolution ∉ keys(resolutions(data)) && error("The resolution $(values(kwargs).resolution) is not supported by the $(P) dataset")
    end

    _extra_keychecks(data; kwargs...)
end