<cf_box title="#attributes.cat_name#">
    <cfdump var="#attributes#">
    <cfparam name="attributes.DosyaAd" default="#attributes.pth#">    
<cfdirectory action="list" directory="#expandPath("./documents/asset/>#attributes.DosyaAd#")#" recurse="false" name="myLists">
<cfset myList=directoryList(expandPath("./documents/asset/#attributes.DosyaAd#"),false,"query","","type asc")>
<cfdump var="#myList#">
<cfoutput query="myList">
    <cfset f_info=GetFileInfo("#directory#\#name#")>
    <cfdump var="#f_info#"><br>
</cfoutput>
</cf_box>
