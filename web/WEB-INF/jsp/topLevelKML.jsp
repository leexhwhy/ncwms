<%@page contentType="text/xml"%><%--application/vnd.google-earth.kml+xml"--%><%@page pageEncoding="UTF-8"%><?xml version="1.0" encoding="UTF-8"?>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="/WEB-INF/taglib/wms/wms2kml" prefix="wms2kml"%>
<%-- Creates the top-level KML to wrap the WMS

     Arguments passed in to this JSP:
     title: (String) Title for this KML document
     description: (String) description
     tiledLayers: (List<TiledLayer>) Layers to include in this KML, together with top-level tiles
     wmsBaseUrl: (String) URL to use as a base for future requests back to this server --%>
<kml xmlns="http://earth.google.com/kml/2.2"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="http://earth.google.com/kml/2.2 http://code.google.com/apis/kml/schema/kml22beta.xsd">
    <Document>
        <name>${title}</name>
        <description>${description}</description><%-- Generated by...  Contact details... --%>
        <c:forEach var="tiledLayer" items="${tiledLayers}">
            <c:set var="layer" value="${tiledLayer.layer}"/>
            <Folder>
                <%-- Create a ScreenOverlay for the legend --%>
                <ScreenOverlay>
                    <name>Colour scale</name>
                    <Icon><href>${wmsBaseUrl}?REQUEST=GetLegendGraphic&amp;LAYER=${layer.layerName}</href></Icon>
                    <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
                    <screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>
                    <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
                    <size x="0" y="0" xunits="fraction" yunits="fraction"/>
                </ScreenOverlay>
                <%-- Titles for the layer --%>
                <name>${layer.title} from ${layer.dataset.title}</name>
                <description>${layer.abstract}</description>
                <visibility>0</visibility>
                <open>0</open>
                <%-- If the layer has a z dimension we create a folder for each level --%>
                <c:choose>
                    <c:when test="${empty layer.zvalues}">
                        <wms2kml:layerTimesteps tiledLayer="${tiledLayer}" baseURL="${wmsBaseUrl}"/>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${layer.zvalues}" var="elevation">
                            <Folder>
                                <name>${elevation} ${layer.zunits}</name>
                                <wms2kml:layerTimesteps tiledLayer="${tiledLayer}" elevation="${elevation}" baseURL="${wmsBaseUrl}"/>
                            </Folder>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </Folder>
        </c:forEach>
    </Document>
</kml>