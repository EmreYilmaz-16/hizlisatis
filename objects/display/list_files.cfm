<cf_box title="#attributes.CatName#">
    <cfparam name="attributes.DosyaAd" default="">    
<cfdirectory action="list" directory="#expandPath("./#attributes.DosyaAd#")#" recurse="false" name="myLists">
<cfset myList=directoryList(expandPath("./#attributes.DosyaAd#"),false,"query","","type asc")>
<cfdump var="#myList#">
</cf_box>