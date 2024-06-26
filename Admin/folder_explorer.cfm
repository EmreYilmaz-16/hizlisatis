<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<cfparam name="attributes.DosyaAd" default="" />
<cfparam name="product_cat_id" default="">
<cfparam name="PRODUCT_CATID" default="">
<cfparam name="PRODUCT_CAT" default="">
<cfparam name="is_show_detail_variation" default="1">
<cfdirectory action="list" directory="#expandPath("./#attributes.DosyaAd#")#" recurse="false" name="myLists">
<cfset myList=directoryList(expandPath("./#attributes.DosyaAd#"),false,"query","","type asc")>

<cfoutput>
	#getDd(myList)#
</cfoutput>

<cffunction name="getDd" returntype="any" returnformat="plain">
<cfargument name="FL">
<cfsavecontent variable="RES">
	<ul class="list-group">
<cfloop query="arguments.FL">
	<li class="list-group-item"><cfoutput>#Name#</cfoutput>
	<cfif type eq "dir">
		<cfset myList=directoryList("#directory#\#name#",false,"query","","type asc")>
		<cfoutput>#getDd(myList)#</cfoutput>
	<cfelse>
		<cftry>
			<cfset myfile = FileRead("#directory#\#name#")>   
               
              <cfset linecount = ListLen(myfile,chr(10),true)>
			  <cfoutput>
				<span class="LineCount badge text-bg-primary rounded-pill">#linecount#</span></cfoutput>
			<cfcatch></cfcatch>
		</cftry>
	</cfif>
	</li>
</cfloop>
</ul>
</cfsavecontent>
<cfreturn RES>

</cffunction>

<script>
	$(document).ready(function (params) {
		var e=document.getElementsByClassName("LineCount")
		var tlc=0;
var tempMax=0;
var sifirbin=[];
var binikibin=[];
var ikibinucbin=[];
var buyukucbin=[];
for(let i=0;i<e.length;i++){
    var tv=parseFloat(e[i].innerText)
   // console.log(tv)
    tlc+=tv
    if(tv>tempMax && tv!=4533 && tv != 3274){
        tempMax=tv
    }
   if(tv<1000){
       sifirbin.push(tv);
   }else if(tv>=1000 && tv<2000){
       binikibin.push(tv);
   }else if(tv>=2000 && tv<3000){
       ikibinucbin.push(tv);
   }else if(tv>=3000 ){
       buyukucbin.push(tv);
   }
}
console.warn("Total Line Count : "+tlc)
console.warn("Max Line Count : "+tempMax)
console.table(sifirbin)
console.table(binikibin)
console.table(ikibinucbin)
console.table(buyukucbin)

	})
</script>

<cfabort>


<!---<cfdump var="#myLists#">
<cfdump var="#expandPath(".")#">
<cfdump var="#application#">---->
<style>
	.td1{ pading:20px; } .ASFGH{ height: 85vh; width: 500px; overflow-y: scroll; } 
</style>

<table style="width:100%">
	<tr>
		<td>
			<div class="ASFGH" >
        <cf_box height="100vh">
			<cf_ajax_list >
				<tr>
					<td>
						Dosya Adı 
					</td>
				</tr>
				<cfif listlen(attributes.DosyaAd,"/") gt 0>
					<cfset  a=listDeleteAt(attributes.DosyaAd, ListLen(attributes.DosyaAd,"/"), "/")>
					<cfoutput>
						<tr>
							<td>
								<a class="tableyazi" href="#request.self#?fuseaction=objects.folder_explorer&DosyaAd=#a#">
									<img src="/img/foldero.png" width="25" height="25" />
									Ust Klasor 
								</a>
							</td>
						</tr>
					</cfoutput>
				</cfif>
				<cfoutput query="myList">
                    <cfset f_info=GetFileInfo("#directory#\#name#")>
               <!---   <cfdump var="#f_info#">---->
					<tr>
						<td valign="top" style="vertical-align:top">
							<div style="vertical-align:top">
								<cfif attributes.DosyaAd neq "">																	
                                    <cfset ace = "">
                                    <cfif type neq "Dir">
                                        <cfset ace=listLast(Name,".")>
										<a href="/#request.self#?fuseaction=#attributes.fuseaction#&DosyaAd=#attributes.DosyaAd#&download_file=#replace(replace(f_info.path,"#expandPath(".")#",""),"//","//")#" > <span class="kopkop"><img src="/img/#ace#.png" width="25" height="35" />#Name# </span></a>
                                    <cfelse>
                                    <a class="tableyazi" href="#request.self#?fuseaction=objects.folder_explorer&DosyaAd=#attributes.DosyaAd#/#Name#"><img src="/img/folder.png" width="25" height="25" />#Name#</a>
                                    </cfif>																
								<cfelse>									
                                    <cfif type neq "Dir">
											<cfset ace=listLast(Name, ".")>

										<a href="#replace(replace(f_info.path,"#expandPath(".")#",""),"//","//")#" download>	<span class="kopkop"><img src="/img/#ace#.png" width="25" height="25" />#Name#</span></a>
										<cfelse>
                                        <a href="#request.self#?fuseaction=objects.folder_explorer&DosyaAd=#Name#"><img src="/img/folder.png" width="25" height="25" />#Name#</a>
										</cfif>							
								</cfif>
						</td>
					</tr>
				</cfoutput>
			</table>
			</div> 
		</td>
    <cfif isDefined("attributes.download_file")>
      <cfzip action="zip" file="#expandPath('./#attributes.DosyaAd#/dwn.zip')#" overwrite="yes" >
        <cfzipparam  source="#expandPath('./#attributes.download_file#')#">
        </cfzip>
          <cfcontent deleteFile="true" file="#expandPath('./#attributes.DosyaAd#/dwn.zip')#" type="application/x-zip-compressed" >
          <cfheader name = "Content-disposition" value = 'attachment; filename="#expandPath('./#attributes.DosyaAd#/dwn.zip')#"'>
    </cfif>
		<td valign="top">
			<table>
				<tr>
					<td class="td1">
						<div style="margin-left:10px;margin-right:10px">
							<h4>
								Klasör Oluşturma 
							</h4>
							<cfform action="#request.self#?fuseaction=objects.folder_explorer&DosyaAd=#attributes.DosyaAd#" method="post" preservedata="true">
								<cfinput type="text" required="true" name="createDirectory" placeholder="Klasör Adı" />
								<cfinput type="submit" value="Klasör Oluştur" name="submit" />
							</cfform>
							<cfif IsDefined("FORM.createDirectory")>
								<cfif FORM.createDirectory is not "">
									<cfset createDirectory = FORM.createDirectory>
									<cfset DirectoryCreate(expandPath("./#attributes.DosyaAd#/#createDirectory#"))>
									<cfoutput>
										<b>
											Directory #createDirectory# successfully created. 
										</b>
									</cfoutput>
								</cfif>
							</cfif>
						</div>
					</td>
				</tr>
				<tr>
					<td class="td1">
						<div style="margin-left:10px;margin-right:10px">
							<h4>
								Dosya Yükleme 
							</h4>
            
                 <cfif isDefined("Form.FileContents") > 
                  
                    <!--- If TRUE, upload the file. --->
                   
                    
                    <cffile action = "upload"
                    fileField = "FileContents"
                    destination = "#expandPath("./#attributes.DosyaAd#")#" 
                    nameConflict = "Overwrite"> 

                    
                    <cfset f_info=GetFileInfo("#expandPath('./#attributes.DosyaAd#\#attributes.fname#')#")>
                    
                  <cfquery name="fileUpo" datasource="#dsn#">
                      INSERT INTO FILE_UPLOAD_HISTORY_PARTNER(FILE_PATH,EMPLOYEE_ID,RECORD_DATE,FILE_NAME_) VALUES('#attributes.DosyaAd#',#SESSION.EP.USERID#,GETDATE(),'#attributes.fname#')
                    </cfquery>
                    <cfelse> 
                    <!--- If FALSE, show the Form. --->
                    <form method="post" action="<cfoutput>#request.self#?fuseaction=objects.folder_explorer&DosyaAd=#URLEncodedFormat(attributes.DosyaAd)#</cfoutput>"
                    name="uploadForm" enctype="multipart/form-data"> 
                    <input id="FileContents" name="FileContents" type="file"> 
                    <input type="hidden" name="fname" id="fname">
                    <input name="submit" type="submit" value="Upload File"> 
                    </form> 
                    </cfif>
						</div>
					</td>
				</tr>
			</cf_ajax_list>
    </cf_box>
		</td>
		<td>	<cfform name="form_add_product">
					<div class="form-group" id="item-product_cat">
						<label class="col col-3 col-xs-3">Kategori</label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
								<cfinput type="hidden" name="product_catid" value="#product_cat_id#">
								<cfsavecontent variable="message">Kategori Girmediniz</cfsavecontent>
								<cfif is_show_detail_variation eq 1>
									<cfinput type="text" name="product_cat" id="product_cat" required="yes" style="width:426px;" message="#message#" value=" #product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455',true,'add_property()');">
								<cfelse>                                
									<cfinput type="text" name="product_cat" id="product_cat" required="yes" style="width:426px;" message="#message#" value="#product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPoniter" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=product_catid&field_name=form_add_product.product_cat&field_min=form_add_product.MIN_MARGIN&field_max=form_add_product.MAX_MARGIN<cfif is_show_detail_variation eq 1>&caller_function=add_property</cfif>','list');" title="Ürün Kategorisi Ekle!">11</span>
							</div>
						</div>
					</div>
					</cfform>
		</td>
	</tr>
</table>
<script>
$("#FileContents").change(function(e){
     var fileName = e.target.files[0].name;
     var d=document.getElementById("fname");
     d.value=fileName
     console.log(e);
     console.log(fileName); 
})
$(".kopkop").dblclick(function(e){
console.log(e);
})
</script>
