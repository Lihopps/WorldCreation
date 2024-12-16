local asteroid={}

function asteroid.spawn_smoke()
    return {
        type="entity",
        asteroid ="assembling-machine-1",
        probability=1,
        speed=0.5
    }
end



return asteroid