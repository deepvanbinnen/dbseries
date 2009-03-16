<cfcomponent name="FileObj">
	<cfset variables.ABSROOT = "">
	<cfset variables.WEBROOT = "">
	<cfset variables.FOLDERS = "">
	<cfset variables.IMAGE_EXTENSIONS = "jpg,gif,png">
	
	<cfset this.fullname = "">
	<cfset this.name     = "">
	<cfset this.size = "">
	<cfset this.width = "">
	<cfset this.height = "">
	<cfset this.extension = "">
	<cfset this.directory = "">
	<cfset this.webPath = "">
	<cfset this.absPath = "">
	<cfset this.isFolder = FALSE>
	<cfset this.isimage  = FALSE>
		
	<cffunction name="init" output="No" returntype="FileObj">
		<cfargument name="directory" type="any" required="false" default="#this.directory#">
		<cfargument name="name" type="any" required="false" default="#this.name#">
		<cfargument name="isfolder" type="any" required="false" default="#this.size#">
		<cfargument name="size" type="any" required="false" default="#this.size#">
		<cfargument name="webroot" type="any" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.directory = arguments.directory>
		<cfset local.name = arguments.name>
		<cfset local.size = arguments.size>
	
		<cfset setDirectory(arguments.directory)>
		<cfset setName(arguments.name)>
		<cfset setSize(arguments.size)>
		<cfset setIsFolder(arguments.isfolder)>
		<cfset setWebroot(arguments.webroot)>
		
		<cfset setWebpath()>
		<cfset setFullName()>
		<cfif ListLen(getName(),".") GT 1>
			<cfset setExtension(ListLast(getName(),"."))>
		</cfif>
		
		<cfset setIsImage()>
		<cfif getIsImage()>
			<cfset setDimensions()>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getIsImage" output="No" returntype="boolean">
		<cfreturn this.isimage>
	</cffunction>
		
	<cffunction name="setIsImage" output="No" returntype="any">
		<cfargument name="isimage" type="boolean" required="false" default="#ListFindNoCase(variables.IMAGE_EXTENSIONS, getExtension())#">
		<cfset this.isimage = arguments.isimage>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getIsFolder" output="No" returntype="boolean">
		<cfreturn this.isFolder>
	</cffunction>
	
	<cffunction name="setIsFolder" output="No" returntype="any">
		<cfargument name="isfolder" type="boolean" required="false" default="true">
		<cfset this.isfolder = arguments.isfolder>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setDimensions" output="No" returntype="any">
		<cfset var local = StructNew()>
		<cfset local.dimensions = _imageSize(getFullName())>
		<cfif IsStruct(local.dimensions)>
			<cfset setIsImage(true)>
			<cfset setWidth(local.dimensions.imagewidth)>
			<cfset setHeight(local.dimensions.imageheight)>
		<cfelse>
			<cfset setIsImage(false)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getFullName" output="No">
		<cfreturn this.fullname>
	</cffunction>
	<cffunction name="setFullName" output="No">
		<cfset this.fullname = "/" & ArrayToList(ListToArray(getDirectory() & "/"&getName(),"/"),"/")>
	</cffunction>
	
	<cffunction name="_getAbsroot" output="No">
		<cfreturn variables.ABSROOT>
	</cffunction>
	<cffunction name="_setAbsroot" output="No">
		<cfargument name="ABSROOT" type="any" required="true">
		<cfset variables.ABSROOT = arguments.ABSROOT>
	</cffunction>
	
	<cffunction name="getWebroot" output="No">
		<cfreturn variables.WEBROOT>
	</cffunction>
	<cffunction name="setWebroot" output="No">
		<cfargument name="WEBROOT" type="any" required="true">
		<cfset variables.WEBROOT = arguments.WEBROOT>
	</cffunction>
	
	<cffunction name="_getFolders" output="No">
		<cfreturn variables.FOLDERS>
	</cffunction>
	<cffunction name="_setFolders" output="No">
		<cfargument name="FOLDERS" type="any" required="true">
		<cfset variables.FOLDERS = arguments.FOLDERS>
	</cffunction>
	
	<cffunction name="getName" output="No">
		<cfreturn this.name>
	</cffunction>
	<cffunction name="setName" output="No">
		<cfargument name="name" type="any" required="true">
		<cfset this.name = arguments.name>
	</cffunction>
	
	<cffunction name="getSize" output="No">
		<cfreturn this.size>
	</cffunction>
	<cffunction name="setSize" output="No">
		<cfargument name="size" type="any" required="true">
		<cfset this.size = arguments.size>
	</cffunction>
	
	<cffunction name="getWidth" output="No">
		<cfreturn this.width>
	</cffunction>
	<cffunction name="setWidth" output="No">
		<cfargument name="width" type="any" required="true">
		<cfset this.width = arguments.width>
	</cffunction>
	
	<cffunction name="getHeight" output="No">
		<cfreturn this.height>
	</cffunction>
	<cffunction name="setHeight" output="No">
		<cfargument name="height" type="any" required="true">
		<cfset this.height = arguments.height>
	</cffunction>
	
	<cffunction name="getExtension" output="No">
		<cfreturn this.extension>
	</cffunction>
	<cffunction name="setExtension" output="No">
		<cfargument name="extension" type="any" required="true">
		<cfset this.extension = arguments.extension>
	</cffunction>
	
	<cffunction name="getDirectory" output="No">
		<cfreturn this.directory>
	</cffunction>
	<cffunction name="setDirectory" output="No">
		<cfargument name="directory" type="any" required="true">
		<cfset this.directory = arguments.directory>
	</cffunction>
	
	<cffunction name="getWebpath" output="No">
		<cfreturn this.webPath>
	</cffunction>
	<cffunction name="setWebpath" output="No">
		<cfset this.webPath = getWebroot() & "/" & getName()>
	</cffunction>
	
	<cffunction name="getAbspath" output="No">
		<cfreturn this.absPath>
	</cffunction>
	<cffunction name="setAbspath" output="No">
		<cfargument name="absPath" type="any" required="true">
		<cfset this.absPath = arguments.absPath>
	</cffunction>
	
	<cffunction name="_imageSize" output="no">
		<cfargument name="filename" type="string" required="true">
		<cfscript>
		/**
		 * Returns width and height of images based on image type.
		 * 
		 * @param filename 	 Absolute or relative path to file. (Required)
		 * @param mimetype 	 Minetype for the file. (Optional)
		 * @return Returns a struct containing height and width information, or an error string. 
		 * @author Peter Crowley (pcrowley@webzone.ie) 
		 * @version 1, January 28, 2004 
		 */
	
		// Jpeg variables
		var nFileLength=0; var nBlockLength=0; var nMarker=0;
		var nSOI = 65496; // Start of Image (FFD8)
		var nEOI = 65497; // End of Image (FFD9)
		var nSOF = 65472; // Start of frame nMarker (FFC0)
		var nSOF1 = 65473; // Start of frame extended sequential mode (FFC1)
		var nSOF2 = 65474; // Start of frame progressive mode (FFC2)
		var nSOF3 = 65475; // Start of frame lossless mode (FFC3)
		var nSOS = 65498; // Start of Scan (FFDA)
	
		
		var sImageType = "";
		var kCoords = structNew();
		var fInput = 0;
		var sByte=0;
		var sFullPath="";
		var sMimeType = "";
		
		if (Left(filename,1) IS "/" OR Left(filename,1) IS "\" OR MID(filename,2,1) IS ":")
			sFullPath=filename;
		else
			sFullPath=ExpandPath(filename);
	
		// Establish image type 
		if(arrayLen(arguments) gt 1) { 	//optional mimetype
			sMimeType = arguments[2];
			if (LCase(ListFirst(sMimeType,"/")) IS NOT "image") return "Wrong mime type";
			if (ListLen(sMimeType,"/") NEQ 2) return "Invalid mime type";
			sImageType=LCase(ListLast(sMimeType,"/"));
		} else { // work off file extension
			if (ListLen(filename,".") LT 2) return "Unknown image type";
			sImageType=LCase(ListLast(filename,"."));
		}
	
		if(not fileExists(sFullPath)) return "File does not exist.";
		
		//make a fileInputStream object to read the file into
		fInput = createObject("java","java.io.RandomAccessFile").init(sFullPath,"r");
		
		// Get X,Y resolution sizes for each image type supported
		switch (sImageType) {
		case "jpg": case "jpeg": case "jpe":
			do {
				nMarker = fInput.readUnsignedShort();
	
				if (nMarker NEQ nSOI AND nMarker NEQ nEOI AND nMarker NEQ nSOS) {
	
					nBlockLength = fInput.readUnsignedShort();
	
					if (nMarker EQ nSOF OR nMarker EQ nSOF1 OR nMarker EQ nSOF2 OR nMarker EQ nSOF3) { // Start of frame
						fInput.readUnsignedByte(); // skip sample precision in bits
						kCoords.ImageHeight = fInput.readUnsignedShort();
						kCoords.ImageWidth = fInput.readUnsignedShort();
						fInput.close();
						return kCoords;
					} else {
						fInput.skipBytes(JavaCast("int",nBlockLength-2));
					}
				}
			} while (BitSHRN(nMarker,8) EQ 255 AND nMarker NEQ nEOI);
			break;
		case "gif":
			fInput.skipBytes(6);
	
			sByte = fInput.readUnsignedByte();
			kCoords.ImageWidth = fInput.readUnsignedByte() * 256 + sByte;
			
			sByte = fInput.readUnsignedByte();
			kCoords.ImageHeight = fInput.readUnsignedByte() * 256 + sByte;
		
			fInput.close();
			return kCoords;
		default:
			break;
		}
		//close out this entry
		fInput.close();
		return "Unhandled image type";
		</cfscript>
	</cffunction>
</cfcomponent>
