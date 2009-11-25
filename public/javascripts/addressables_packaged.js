function addInfoWindowToMarker(marker,info,options){GEvent.addListener(marker,"click",function(){marker.openInfoWindowHtml(info,options);});return marker;}
function addInfoWindowTabsToMarker(marker,info,options){GEvent.addListener(marker,"click",function(){marker.openInfoWindowTabsHtml(info,options);});return marker;}
function addPropertiesToLayer(layer,getTile,copyright,opacity,isPng){layer.getTileUrl=getTile;layer.getCopyright=copyright;layer.getOpacity=opacity;layer.isPng=isPng;return layer;}
function addOptionsToIcon(icon,options){for(var k in options){icon[k]=options[k];}
return icon;}
function addCodeToFunction(func,code){if(func==undefined)
return code;else{return function(){func();code();}}}
function addGeocodingToMarker(marker,address){marker.orig_initialize=marker.initialize;orig_redraw=marker.redraw;marker.redraw=function(force){};marker.initialize=function(map){new GClientGeocoder().getLatLng(address,function(latlng){if(latlng){marker.redraw=orig_redraw;marker.orig_initialize(map);marker.setPoint(latlng);}});};return marker;}
GMap2.prototype.centerAndZoomOnMarkers=function(markers){var bounds=new GLatLngBounds(markers[0].getPoint(),markers[0].getPoint());for(var i=1,len=markers.length;i<len;i++){bounds.extend(markers[i].getPoint());}
this.centerAndZoomOnBounds(bounds);}
GMap2.prototype.centerAndZoomOnPoints=function(points){var bounds=new GLatLngBounds(points[0],points[0]);for(var i=1,len=points.length;i<len;i++){bounds.extend(points[i]);}
this.centerAndZoomOnBounds(bounds);}
GMap2.prototype.centerAndZoomOnBounds=function(bounds){var center=bounds.getCenter();this.setCenter(center,this.getBoundsZoomLevel(bounds));}
function setWindowDims(elem){if(window.innerWidth){elem.style.height=(window.innerHeight)+'px;';elem.style.width=(window.innerWidth)+'px;';}else if(document.body.clientWidth){elem.style.width=(document.body.clientWidth)+'px';elem.style.height=(document.body.clientHeight)+'px';}}
ManagedMarker=function(markers,minZoom,maxZoom){this.markers=markers;this.minZoom=minZoom;this.maxZoom=maxZoom;}
function addMarkersToManager(manager,managedMarkers){for(var i=0,length=managedMarkers.length;i<length;i++){mm=managedMarkers[i];manager.addMarkers(mm.markers,mm.minZoom,mm.maxZoom);}
manager.refresh();return manager;}
var INVISIBLE=new GLatLng(0,0);if(self.Event&&Event.observe){Event.observe(window,'unload',GUnload);}else{window.onunload=GUnload;}
function GMarkerGroup(active,markers,markersById){this.active=active;this.markers=markers||new Array();this.markersById=markersById||new Object();}
GMarkerGroup.prototype=new GOverlay();GMarkerGroup.prototype.initialize=function(map){this.map=map;if(this.active){for(var i=0,len=this.markers.length;i<len;i++){this.map.addOverlay(this.markers[i]);}
for(var id in this.markersById){this.map.addOverlay(this.markersById[id]);}}}
GMarkerGroup.prototype.remove=function(){this.deactivate();}
GMarkerGroup.prototype.redraw=function(force){}
GMarkerGroup.prototype.copy=function(){var overlay=new GMarkerGroup(this.active);overlay.markers=this.markers;overlay.markersById=this.markersById;return overlay;}
GMarkerGroup.prototype.clear=function(){this.deactivate();this.markers=new Array();this.markersById=new Object();}
GMarkerGroup.prototype.addMarker=function(marker,id){if(id==undefined){this.markers.push(marker);}else{this.markersById[id]=marker;}
if(this.active&&this.map!=undefined){this.map.addOverlay(marker);}}
GMarkerGroup.prototype.showMarker=function(id){var marker=this.markersById[id];if(marker!=undefined){GEvent.trigger(marker,"click");}}
GMarkerGroup.prototype.activate=function(active){active=(active==undefined)?true:active;if(!active){if(this.active){if(this.map!=undefined){for(var i=0,len=this.markers.length;i<len;i++){this.map.removeOverlay(this.markers[i])}
for(var id in this.markersById){this.map.removeOverlay(this.markersById[id]);}}
this.active=false;}}else{if(!this.active){if(this.map!=undefined){for(var i=0,len=this.markers.length;i<len;i++){this.map.addOverlay(this.markers[i]);}
for(var id in this.markersById){this.map.addOverlay(this.markersById[id]);}}
this.active=true;}}}
GMarkerGroup.prototype.centerAndZoomOnMarkers=function(){if(this.map!=undefined){var tmpMarkers=this.markers.slice();for(var id in this.markersById){tmpMarkers.push(this.markersById[id]);}
if(tmpMarkers.length>0){this.map.centerAndZoomOnMarkers(tmpMarkers);}}}
GMarkerGroup.prototype.deactivate=function(){this.activate(false);}