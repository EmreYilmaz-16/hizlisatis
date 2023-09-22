<cfparam name="attributes.page" default="list">
<cfif attributes.page eq "list">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css"
      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cf_box title="Proje Tanımları">
    <cfoutput>
    <div class="list-group">
        <a class="list-group-item list-group-item-action"
           onclick="window.location.href='index.cfm?fuseaction=#attributes.fuseaction#&page=1List'">
            <img src="/images/e-pd/pr.png">
            Ana İşlem Kategorisi => Kategori Tanımlama</a>
        <a class="list-group-item list-group-item-action"
           onclick="window.location.href='index.cfm?fuseaction=#attributes.fuseaction#&page=2List'">
            <img src="/images/e-pd/mpr.png">
            Ana İşlem Kategorisi Tanımlama</a>
        
    </div>
</cfoutput>
</cf_box>
</cfif>
<cfif attributes.page eq "1List">
    <cfquery name="GETL" datasource="#DSN3#">
select MAIN_PROCESS_CAT_TO_PRODUCT_CAT.ID,MAIN_PROCESS_CAT_ID,MAIN_PROCESS_CAT,PRODUCT_CAT.PRODUCT_CATID,PRODUCT_CAT from #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT
INNER JOIN #DSN#.SETUP_MAIN_PROCESS_CAT ON MAIN_PROCESS_CAT_TO_PRODUCT_CAT.MAIN_PROCESS_CATID=SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #DSN1#.PRODUCT_CAT ON PRODUCT_CAT.PRODUCT_CATID=MAIN_PROCESS_CAT_TO_PRODUCT_CAT.PRODUCT_CATID
    </cfquery>
    <cf_big_list>
        <thead>
            <tr>
                <th>Ana İşlem Kategorisi</th>
                <th>Kategori</th>
                <th><span class="icn-md icon-pencil-square-o"></span></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="GETL">
            <tr>
                <td>#MAIN_PROCESS_CAT#</td>
                <td>#PRODUCT_CAT#</td>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction#&page=1Upd&IID=#ID#"><span class="icn-md icon-pencil-square-o"></span></a></td>
            </tr>
        </cfoutput>
        </tbody>
    </cf_big_list>
</cfif>
<cfif attributes.page eq "1Add">
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&page=1AddQ" name="search_product">
        <table>
            <tr>
                <td>
                    <div class="form-group">
                        <select name="MainProcessCat" required>
                            <cfquery name="getMain" datasource="#dsn#">
                                SELECT MAIN_PROCESS_CAT_ID,MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT
                            </cfquery>
                            <option value="">Ana İşlem Kategorisi</option>
                            <cfoutput query="getMain">
                                <option value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
                            </cfoutput>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="form-group" id="item-cat_id">
                        <label>Kategori </label>
                        <div class="input-group">
                            <input type="hidden" name="cat_id" id="cat_id" value="">
                            <input type="hidden" name="cat" id="cat" value="">
                            <input name="category_name" type="text" id="category_name" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="" autocomplete="off" style=""><div id="category_name_div_2" name="category_name_div_2" class="completeListbox" autocomplete="on" style="width: 516px; max-height: 150px; overflow: auto; position: absolute; left: 540.833px; top: 146.111px; z-index: 159; display: none;"></div>
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.cat_id&field_code=search_product.cat&field_name=search_product.category_name');"></span>
                        </div>
                    </div>
                </td>
                <td><input type="submit"></td>
            </tr>
        </table>
    </cfform>
</cfif>
<cfif attributes.page eq "1Upd">
    <cfquery name="GETL" datasource="#DSN3#">
        select MAIN_PROCESS_CAT_TO_PRODUCT_CAT.ID,MAIN_PROCESS_CAT_ID,MAIN_PROCESS_CAT,PRODUCT_CAT.PRODUCT_CATID,PRODUCT_CAT from #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT
        INNER JOIN #DSN#.SETUP_MAIN_PROCESS_CAT ON MAIN_PROCESS_CAT_TO_PRODUCT_CAT.MAIN_PROCESS_CATID=SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID
        INNER JOIN #DSN#.PRODUCT_CAT ON PRODUCT_CAT.PRODUCT_CATID=MAIN_PROCESS_CAT_TO_PRODUCT_CAT.PRODUCT_CATID WHERE MAIN_PROCESS_CAT_TO_PRODUCT_CAT.ID=#attributes.IID#
            </cfquery>
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&page=1UpdQ" name="search_product">
        <input type="hidden" name="iid" value="<cfoutput>#attributes.iid#</cfoutput>">
        <table>
            <tr>
                <td>
                    <div class="form-group">
                        <select name="MAIN_PROCESS_CATID" required>
                            <cfquery name="getMain" datasource="#dsn#">
                                SELECT MAIN_PROCESS_CAT_ID,MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT
                            </cfquery>
                            <option value="">Ana İşlem Kategorisi</option>
                            <cfoutput query="getMain">
                                <option <cfif GETL.MAIN_PROCESS_CAT_ID eq MAIN_PROCESS_CAT_ID>selected</cfif> value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
                            </cfoutput>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="form-group" id="item-cat_id">
                        <label>Kategori </label>
                        <div class="input-group">
                            <input type="hidden" name="cat_id" id="cat_id" value="<cfoutput>#getl.PRODUCT_CATID#</cfoutput>">
                            <input type="hidden" name="cat" id="cat" value="<cfoutput>#getl.PRODUCT_CAT#</cfoutput>">
                            <input name="category_name" type="text" id="category_name" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="" autocomplete="off" style=""><div id="category_name_div_2" name="category_name_div_2" class="completeListbox" autocomplete="on" style="width: 516px; max-height: 150px; overflow: auto; position: absolute; left: 540.833px; top: 146.111px; z-index: 159; display: none;"></div>
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.cat_id&field_code=search_product.cat&field_name=search_product.category_name');"></span>
                        </div>
                    </div>
                </td>
                <td><input type="submit"></td>
            </tr>
        </table>
    </cfform>
</cfif>
<cfif attributes.page eq "1AddQ">
    <cfquery name="INS" datasource="#DSN3#" >
        INSERT INTO MAIN_PROCESS_CAT_TO_PRODUCT_CAT (MAIN_PROCESS_CATID,PRODUCT_CATID) VALUES (#attributes.MAIN_PROCESS_CATID#,#attributes.cat_id#)
    </cfquery>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&page=1List</cfoutput>";
</script>
</cfif>
<cfif attributes.page eq "1UpdQ" >
    <cfquery name="INS" datasource="#DSN3#">
        UPDATE  MAIN_PROCESS_CAT_TO_PRODUCT_CAT SET MAIN_PROCESS_CATID=#attributes.MAIN_PROCESS_CATID#,PRODUCT_CATID=#attributes.cat_id# WHERE ID=#attributes.IID#
    </cfquery>
    <script>
        window.location.href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&page=1List</cfoutput>";
    </script>
</cfif>
<cfif attributes.page eq "2Add"></cfif>
<cfif attributes.page eq "2Upd"></cfif>
<cfif attributes.page eq "2AddQ"></cfif>
<cfif attributes.page eq "2UpdQ"></cfif>