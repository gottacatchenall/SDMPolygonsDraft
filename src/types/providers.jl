abstract type PolygonProvider end 

"""
    EPA

This data is all hosted by the US Environmental Protection Agency (EPA), so there's really no guarantee it will stay available day-to-day. 
"""
abstract type EPA <: PolygonProvider end 


abstract type UCDavis <: PolygonProvider end 
abstract type NaturalEarth <: PolygonProvider end 
abstract type OpenStreetMap <: PolygonProvider end 
