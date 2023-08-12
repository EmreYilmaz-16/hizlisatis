<!---
    File: add_image.cfm
    Folder: V16\objects\query\
	Controller:
    Author:
    Date:
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
        2019-12-30 14:09:40
        Yükleme yapılan dizinlerin var olup olmadığı kontrol edildi. Dizin yok ise oluşturulması sağlandı.
    To Do:

--->


    <cfif Not directoryExists('#upload_folder#productcat')>
        <cfset directoryCreate('#upload_folder#productcat') />
    </cfif>

     <cfset table = "PRODUCTCAT_IMAGES">
     <cfset identity_column = "PRODUCT_CATID">
    <cfif isDefined("attributes.image_file")  and len(attributes.image_file) and isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cftry>
            <cfset file_name = createUUID()>
            <cffile action="UPLOAD" 
                    destination="#upload_folder#productcat#dir_seperator#" 
                    filefield="image_file"  
                    nameconflict="MAKEUNIQUE"> <!---accept="image/*"---> 
            <cffile action="rename" source="#upload_folder#productcat#dir_seperator##cffile.serverfile#" destination="#upload_folder#productcat#dir_seperator##file_name#.#cffile.serverfileext#">
            <cfcatch type="any">
                <script type="text/javascript">
                    alert("Lütfen imaj dosyası giriniz!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#productcat#dir_seperator##file_name#.#cffile.serverfileext#">
            <script type="text/javascript">
                alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfset  session.imFile = #file_name#&"."&#cffile.serverfileext#>
    
        <cfif (findnocase("gif","#CFFILE.SERVERFILE#",1) neq 0) and isDefined("rd")>
            <cfscript>
                CFFILE.SERVERFILE = listgetat(CFFILE.SERVERFILE,1,".")&"."&"jpg";
                cffile.serverfileext = "jpg";
            </cfscript>
        </cfif>
        <cfset size = cffile.fileSize / 1024>
        
        <cfquery name="ADD_IMAGE" datasource="#DSN1#">
            INSERT INTO 
                #table#
                (
                    IS_INTERNET,
                    #identity_column#,
                    PATH,
                    PATH_SERVER_ID,
                    PRD_IMG_NAME,
                    IMAGE_SIZE,
                    LANGUAGE_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    VIDEO_PATH,
                    DETAIL
                )
                VALUES
                (
                    <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                    #attributes.image_action_id#,
                    '#file_name#.#cffile.serverfileext#',
                    '#fusebox.server_machine#',
                    '#FORM.IMAGE_NAME#',
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>
                    '#attributes.language_id#',
                    #NOW()#,
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                    #session.ep.userid#,
                    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                    #session.pp.userid# ,
                    </cfif>
                    '#cgi.REMOTE_ADDR#',
                    1,
                    0,
                    '#attributes.image_url_link#',
                    '#FORM.DETAIL#'
                )
        </cfquery>
        <cfset session.resim = 4>
        <cfif not isDefined("rd")>
            <script type="text/javascript">
                wrk_opener_reload();
                window.close();
            </script>
            <cfabort>
        </cfif>

    <cfelseif isDefined("attributes.image_url_link")  and len(attributes.image_url_link)>
        <cfquery name="ADD_IMAGE" datasource="#DSN1#">
            INSERT INTO 
                #table#
                (
                    IS_INTERNET,
                    #identity_column#,
                    VIDEO_PATH,
                    PRD_IMG_NAME,
                    IMAGE_SIZE,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    PATH_SERVER_ID,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    DETAIL
                )
                VALUES
                (
                    <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                    #attributes.image_action_id#,
                    '#attributes.image_url_link#',
                    '#form.IMAGE_NAME#',
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>
                    #now()#,
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                        #session.ep.userid#,
                    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                        #session.pp.userid# ,
                    </cfif>
                    '#cgi.remote_addr#',
                    NULL,
                    1,
                    <cfif isdefined('attributes.video_link') and len(attributes.video_link)>1<cfelse>0</cfif>,
                    '#FORM.DETAIL#'
                )
        </cfquery>
        <script type="text/javascript">
            wrk_opener_reload();
            window.close();
        </script>
        <cfabort>
    <cfelse>
        <cftry>
            <cfset file_name = createUUID()>
            <cffile action="UPLOAD" 
                    destination="#upload_folder#productcat#dir_seperator#" 
                    filefield="image_file"  
                    nameconflict="MAKEUNIQUE"> <!--- <!---accept="image/*"---> --->
                
            <cffile action="rename" source="#upload_folder#productcat#dir_seperator##cffile.serverfile#" destination="#upload_folder#productcat#dir_seperator##file_name#.#cffile.serverfileext#">
            <cfcatch type="any">
                <script type="text/javascript">
                    alert("Lütfen imaj dosyası giriniz!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#productcat#dir_seperator##file_name#.#cffile.serverfileext#">
            <script type="text/javascript">
                alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfset  session.imFile = #file_name#&"."&#cffile.serverfileext#>
    
        <cfif (findnocase("gif","#CFFILE.SERVERFILE#",1) neq 0) and isDefined("rd")>
            <cfscript>
                CFFILE.SERVERFILE = listgetat(CFFILE.SERVERFILE,1,".")&"."&"jpg";
                cffile.serverfileext = "jpg";
            </cfscript>
        </cfif>
        <cfset size = cffile.fileSize / 1024>
        
        <cfquery name="ADD_IMAGE" datasource="#DSN1#">
            INSERT INTO 
                #table#
                (
                    IS_INTERNET,
                    #identity_column#,
                    PATH,
                    PATH_SERVER_ID,
                    PRD_IMG_NAME,
                    IMAGE_SIZE,

                    LANGUAGE_ID,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    IS_EXTERNAL_LINK,
                    VIDEO_LINK,
                    DETAIL
                )
                VALUES
                (
                    <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                    #attributes.image_action_id#,
                    '#file_name#.#cffile.serverfileext#',
                    '#fusebox.server_machine#',
                    '#form.IMAGE_NAME#',
                    <cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>

                    '#attributes.language_id#',
                    #NOW()#,
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                    #session.ep.userid#,
                    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                    #session.pp.userid# ,
                    </cfif>
                    '#cgi.REMOTE_ADDR#',
                    0,
                    0,
                      '#FORM.detail#'
                )
        </cfquery>
        <cfset session.resim = 4>
        <cfif not isDefined("rd")>
            <script type="text/javascript">
                wrk_opener_reload();
                window.close();
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfif isDefined("rd")>
        <cfinclude template="../display/rd.cfm">
    </cfif>
