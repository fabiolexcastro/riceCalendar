


import arcpy

arcpy.env.workspace  = r'W:\RiceCalendar\_raster\_climate\_delta2\_tif\_tmean'
outputFolder = r'W:\RiceCalendar\_raster\_climate\_mosaicDelta'
rasterList = arcpy.ListRasters('*','')
print rasterList
arcpy.MosaicToNewRaster_management(rasterList, outputFolder, "tmean2.tif", "", "32_BIT_FLOAT", "", "1", "LAST", "FIRST")	
print "Finish"
