There are only three scripts here, used in order of the initial numeral:
- *1dataverseHarvestScript.sh* is used to download, via Dataverse API, DDI.xml and nativeJSON metadata
- *2MADIdataverseFileHarvest.sh* is for downloading the actual datafiles as zipped packages directly to our local archive MADI
- *3dataverseDDI2fgs.xsl* finally performs the transformation to METS.xml in accordance with current FGS ...
Please Note! Before that, the *nativeMDfile_info.json* file downloaded by *1dataverseHarvestScript.sh*, should be converted to **nativeMDfile_info.xml** (in Oxygen), to serve as a parameter document in the ensuing transformation.      
