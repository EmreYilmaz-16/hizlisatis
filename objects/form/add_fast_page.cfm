<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<input type="hidden" name="is_submit">
<input type="hidden" name="security" value="Standart">
<input type="hidden" name="is_legacy" value="0">
<input type="hidden" name="type" value="0">
<input type="hidden" name="licence" value="2">
<input type="hidden" name="status" value="Deployment">
<div class="form-group"> Head <input type="text" name="head" placeholder="Head"></div>
<div class="form-group">FUSEACTION <input type="text" name="fuseaction_name" placeholder="Full Fuseaction"></div>
PENCERE
<div class="form-group"><select name="window_type" id="window_type" required=""><option value="">Seçiniz </option><option value="normal" selected="selected">normal</option><option value="popup">popup</option><option value="draggable">draggable</option></select></div>
<div class="form-group">SOLUTION <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')" required=""></select></div>
<div class="form-group">FAMILY<select id="family" name="family" onchange="loadModules(this.value,'module')" required=""></select></div>
<div class="form-group">MODULE<select id="module" name="module" required=""></select></div>
<div class="form-group">DOSYAYOLU<input type="text" name="file_path" placeholder="file_path"></div>
<div class="form-group"><select name="is_menu">
	<option value="Menü" disabled>Menüde Gör</option>
	<option value="0">Hayır</option>
	<option value="1">Evet</option>
</select></div>
<br>
<input type="submit">
</cfform>



<script>
	$(document).ready(function(){
		var a=wrk_query("select * from WRK_SOLUTION","DSN")
		var sel=document.getElementById("solution");
		for(let i=0;i<a.recordcount;i++){
			var opt=document.createElement("option");
			opt.setAttribute("value",a.WRK_SOLUTION_ID[i]);
			opt.innerText=a.SOLUTION[i]
			sel.appendChild(opt);
		}

	})

	function loadFamilies(id,a,b){
		var a=wrk_query("select * from WRK_FAMILY WHERE WRK_SOLUTION_ID="+id,"DSN")
			var sel=document.getElementById("family");
                  sel.html='';
		for(let i=0;i<a.recordcount;i++){
			var opt=document.createElement("option");
			opt.setAttribute("value",a.WRK_FAMILY_ID[i]);
			opt.innerText=a.FAMILY[i]
			sel.appendChild(opt);
		}
	}

		function loadModules(id,a,b){
		var a=wrk_query("select * from WRK_MODULE WHERE FAMILY_ID="+id,"DSN")
			var sel=document.getElementById("module");
                  sel.html='';
		for(let i=0;i<a.recordcount;i++){
			var opt=document.createElement("option");
			opt.setAttribute("value",a.MODULE_NO[i]);
			opt.innerText=a.MODULE[i]
			sel.appendChild(opt);
		}
	}
</script>


<cfif isDefined("attributes.is_submit")>
<cfquery name="ins" datasource="#dsn#" result="RES">
INSERT INTO [#dsn#].[WRK_OBJECTS]
           ([IS_ACTIVE]
           ,[MODULE_NO]
           ,[HEAD]
           ,[DICTIONARY_ID]
           ,[FRIENDLY_URL]
           ,[FULL_FUSEACTION]
           ,[FULL_FUSEACTION_VARIABLES]
           ,[FILE_PATH]
           ,[CONTROLLER_FILE_PATH]
           ,[STANDART_ADDON]
           ,[LICENCE]
           ,[EVENT_TYPE]
           ,[STATUS]
           ,[IS_DEFAULT]
           ,[IS_MENU]
           ,[WINDOW]
           ,[VERSION]
           ,[IS_CATALYST_MOD]
           ,[MENU_SORT_NO]
           ,[USE_PROCESS_CAT]
           ,[USE_SYSTEM_NO]
           ,[USE_WORKFLOW]
           ,[DETAIL]
           ,[AUTHOR]
           ,[OBJECTS_COUNT]
           ,[DESTINATION_MODUL]
           ,[RECORD_IP]
           ,[RECORD_EMP]
           ,[RECORD_DATE]
           ,[UPDATE_IP]
           ,[UPDATE_EMP]
           ,[UPDATE_DATE]
           ,[SECURITY]
           ,[STAGE]
           ,[MODUL]
           ,[BASE]
           ,[MODUL_SHORT_NAME]
           ,[FUSEACTION]
           ,[FUSEACTION2]
           ,[FOLDER]
           ,[FILE_NAME]
           ,[IS_ADD]
           ,[IS_UPDATE]
           ,[IS_DELETE]
           ,[LEFT_MENU_NAME]
           ,[IS_WBO_DENIED]
           ,[IS_WBO_FORM_LOCK]
           ,[IS_WBO_LOCK]
           ,[IS_WBO_LOG]
           ,[IS_SPECIAL]
           ,[IS_TEMP]
           ,[EVENT_ADD]
           ,[EVENT_DASHBOARD]
           ,[EVENT_DEFAULT]
           ,[EVENT_DETAIL]
           ,[EVENT_LIST]
           ,[EVENT_UPD]
           ,[TYPE]
           ,[POPUP_TYPE]
           ,[RANK_NUMBER]
           ,[EXTERNAL_FUSEACTION]
           ,[IS_LEGACY]
           ,[ADDOPTIONS_CONTROLLER_FILE_PATH]
           ,[THEME_PATH]
           ,[IS_ONLY_SHOW_PAGE]
           ,[DISPLAY_BEFORE_PATH]
           ,[DISPLAY_AFTER_PATH]
           ,[ACTION_BEFORE_PATH]
           ,[ACTION_AFTER_PATH]
           ,[ICON]
           ,[XML_PATH]
           ,[IS_PUBLIC]
           ,[IS_EMPLOYEE]
           ,[IS_COMPANY]
           ,[IS_CONSUMER]
           ,[IS_EMPLOYEE_APP]
           ,[IS_MACHINES]
           ,[IS_LIVESTOCK]
           ,[MAIN_VERSION]
           ,[DATA_PATH]
           ,[DATA_CFC]
           ,[EVENT_OUTPUT]
           ,[WATOMIC_SOLUTION_ID]
           ,[WATOMIC_FAMILY_ID])
     VALUES
           (1
           ,#attributes.module#
           ,'#attributes.head#'
           ,NULL
           ,NULL
           ,'#attributes.fuseaction_name#'
           ,NULL
           ,'#attributes.file_path#'
           ,NULL
           ,NULL
           ,#attributes.licence#
           ,NULL
           ,'#attributes.status#'
           ,NULL
           ,#attributes.is_menu#
           ,'#attributes.window_type#'
           ,'v1'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,#session.ep.userid#
           ,#now()#
           ,NULL
           ,NULL
           ,NULL
           ,'#attributes.security#'
           ,NULL
           ,NULL
           ,NULL
           ,'#listGetAt(attributes.fuseaction_name, 1,".")#'
           ,'#listGetAt(attributes.fuseaction_name, 2,".")#'
           ,NULL
           ,'W3WorkDev'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,'V1'
           ,NULL
           ,NULL
           ,0
           ,NULL
           ,NULL)

</cfquery>
<cfdump var="#RES#">
</cfif>