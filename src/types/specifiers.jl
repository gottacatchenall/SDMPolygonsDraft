struct PolygonData{P<:PolygonProvider,D<:PolygonDataset} 
    PolygonData(P,D) = 
        if provides(P,D)
            new{P,D}()
        else
            error("The dataset $D is not provided by $P")
        end 
end 
