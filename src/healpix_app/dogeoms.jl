using GeometryBasics
import Makie
using Healpix
using NaNMath; nm=NaNMath

function domarker(bottom_poly, f; h=1.0)
    top_poly = h .* bottom_poly
    top = normal_mesh(top_poly, f)
    bottom = normal_mesh(bottom_poly, f)
    combined = merge([top, bottom])
    nvertices = length(top.position)
    connection = Makie.band_connect(nvertices)
    m = normal_mesh(coordinates(combined), vcat(faces(combined), connection))
    return m
end

function domesh(mnew; pointsperside = 3, resol)
    points3d = []
    meshes = []
    mnew2 = []
    for pixidx in 1:resol.numOfPixels
        if !isnan(mnew[pixidx])
            pts3d = boundariesRing(resol, pixidx, pointsperside, Float32)
            ptss = hcat(pts3d', pts3d[1,:])';
            pts3d = [Point3f(ptss[i,:]...) for i in 1:size(ptss,1)]
            push!(points3d, pts3d)
            mf = triangle_mesh(points3d[1])
            mc = normal_mesh(pts3d, faces(mf))
            push!(meshes, mc)
            push!(mnew2, mnew[pixidx])
        end
    end
    #@show length(meshes)
    xcc = repeat(Float32.(mnew2), inner=4*pointsperside + 1);
    return merge([meshes...]), xcc
end

function domeshscatter(mnew; pointsperside = 3, resol)
    points3d = []
    meshes = []
    mnew2 = []
    for pixidx in 1:resol.numOfPixels
        if !isnan(mnew[pixidx])
            pts3d = boundariesRing(resol, pixidx, pointsperside, Float32)
            ptss = hcat(pts3d', pts3d[1,:])';
            pts3d = [Point3f(ptss[i,:]...) for i in 1:size(ptss,1)]
            push!(points3d, pts3d)
            mf = triangle_mesh(points3d[1])
            mtest = domarker(pts3d, faces(mf); h = 1.0 + mnew[pixidx]);
            push!(meshes, mtest)
            push!(mnew2, mnew[pixidx])
        end
    end
    xcc = repeat(Float32.(mnew2), inner=4*pointsperside*2 + 2);
    return merge([meshes...]), xcc
end

"""
aggpixels(lon, lat, data, m)
- lon, lat in radians
- m = HealpixMap{Float32, RingOrder}(resol.nside) # resol = Resolution(2^6)
"""
function aggpixels(lon, lat, data, m)
    θ(δ) = π/2 - δ # co-latitude, δ-> latitude
    # ϕ = 0.1 # longitude
    indx = [ang2pix(m, θ(la), ϕ) for ϕ in lon, la in lat]
    n = length(m.pixels)
    for i in 1:n
        #m.pixels[i] = mean(skipmissing(data[indx .== i]))
        m.pixels[i] = nm.mean(data[indx .== i])
    end
    return m
end
# super slow !