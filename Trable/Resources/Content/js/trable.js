var LocationIcon = L.divIcon({
    className: 'leaflet-control-locate-location',
    html: '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" version="1.1" viewBox="-16 -16 32 32">' +
        '<circle r="14" style="stroke:#fff;stroke-width:5;fill:#2A93EE;fill-opacity:1;opacity:1;" />' +
        '</svg>',
    iconSize: [32,32],
});

var app = {
    map: undefined,
    currentLocationMarker: undefined,

    initializeMap(mapConfig) {
        app.map = L.map('map', {
            crs: L.CRS.Simple,
            attributionControl: false,
            minZoom: mapConfig.minZoom,
            maxZoom: mapConfig.maxZoom
        })

        L.imageOverlay(mapConfig.mapImageUrl, mapConfig.mapBounds).addTo(this.map);
        this.map.fitBounds(mapConfig.mapBounds);

        if (mapConfig.markers) {
            mapConfig.markers.forEach(marker => {
                this.addMarker(marker)
            })
        }
    },

    setupSocketConnection(socketUrl, bearerToken) {
        const socket = io(socketUrl, {
            transportOptions: {
                polling: {
                    extraHeaders: {
                        'Authorization': 'Bearer ' + bearerToken
                    }
                }
            }
        });

        socket.on('updateLocation', (data) => {
            app.setCurrentLocation([data.y, data.x])
        })
    },

    addMarker(marker) {
        L.marker(marker.location).addTo(this.map).bindPopup(marker.displayName)
    },

    setCurrentLocation(location) {
        if (map === undefined) {
            return
        }

        if (this.currentLocationMarker) {
            this.currentLocationMarker.setLatLng(location)
        } else {
            this.currentLocationMarker = L.marker(location, { icon: LocationIcon }).addTo(this.map).bindPopup("Your current location")
        }
    }
}
