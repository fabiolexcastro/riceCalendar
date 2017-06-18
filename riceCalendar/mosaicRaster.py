


import arcpy

arcpy.env.workspace  = r'Z:\RiceCalendar\_raster\_climate\_delta\_tif\_prec'
outputFolder = r'Z:\RiceCalendar\_raster\_climate\_mosaicDelta'
rasterList = arcpy.ListRasters('*','')
arcpy.MosaicToNewRaster_management(rasterList, outputFolder + "prec" + ".tif", "", "32_BIT_SIGNED", "", "1", "LAST", "FIRST")	
print "Finish"