<cfquery name="ishv" datasource="#dsn3#">
    SELECT PP_ID
	,UNIQUE_RELATION_ID
	,PP.COMPANY_ID
	,PRICE
	,OTHER_MONEY
	,PRICE_OTHER
	,PP_DATE
	,PP.RECORD_DATE
	,workcube_metosan.getEmployeeWithId(PP.RECORD_EMP) AS RECORD_EMP_
	,PP.RECORD_EMP
	,PP.UPDATE_DATE
    ,workcube_metosan.getEmployeeWithId(PP.UPDATE_EMP) AS UPDATE_EMP_
	,PP.UPDATE_EMP
	,C.NICKNAME
FROM PBS_OFFER_ROW_PURCHASE_PRICES AS PP
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID = PP.COMPANY_ID WHERE UNIQUE_RELATION_ID='#attributes.uniq_id#'
</cfquery>
<cfdump var="#ishv#">
<cfquery name="GETMONEY" datasource="#DSN#">
    select DISTINCT MONEY from workcube_metosan.SETUP_MONEY 
</cfquery>
<cfdump var="#attributes#">
<cfform name="Notorder_form">
<cfoutput>
    <input type="hidden" name="PP_ID" id="PP_ID" value="#ishv.PP_ID#">
    <input type="hidden" name="UNIQUE_RELATION_ID" id="UNIQUE_RELATION_ID" value="#attributes.uniq_id#">
    <input type="hidden" name="EMP_ID" id="EMP_ID" value="#session.ep.userid#">
    <table>
        <tr>
            <td>
                <div class="form-group" id="item-company_id">
                    <label>Cari Hesap </label>							
                    <div>
                        <div class="input-group">
                            <input type="hidden" name="consumer_id_0001" id="consumer_id_0001" value="">
                            <input type="hidden" name="company_id_0001" id="company_id_0001" value="">
                            <input type="hidden" name="member_type_0001" id="member_type_0001" value="">
                            <input name="member_name_0001" type="text" id="member_name_0001" placeholder="Cari Hesap" onfocus="AutoComplete_Create('member_name_0001','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id_0001,company_id_0001,member_type_0001','','3','250');" value="" autocomplete="off" style=""><div id="member_name_div_2" name="member_name_div_2" class="completeListbox" autocomplete="on" style="width: 506px; max-height: 150px; overflow: auto; position: absolute; left: 545.833px; top: 210.556px; z-index: 159; display: none;"></div>
                            
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_all_pars&field_consumer=Notorder_form.consumer_id_0001&field_comp_id=Notorder_form.company_id_0001&field_member_name=Notorder_form.member_name_0001&field_type=Notorder_form.member_type_0001&select_list=7,8&keyword='+encodeURIComponent(document.Notorder_form.member_name_0001.value));"></span>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                Alış Fiyat Tarihi
            </td>            
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <input type="date" name="PP_DATE" id="PP_DATE" value="#ishv.PP_DATE#">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                Alış Fiyatı
            </td>       
            <td>
                Para Birimi
            </td>      
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <input type="text" name="PRICE_001" onchange="this.value=commaSplit(this.value)" id="PRICE_001" value="#ishv.PRICE#">
                </div>
            </td>
            <td>
                <div class="form-group">
                    <select name="OTHER_MONEY_001" id="OTHER_MONEY_001">
                        <CFLOOP query="GETMONEY">
                            <option value="#MONEY#">#MONEY#</option>
                        </CFLOOP>
                    </select>
                </div>
                
            </td>
        </tr>
    </table>
    <div>
        <cfif len(ishv.RECORD_EMP_)>
          Kaydeden :<code>#ishv.RECORD_EMP_#</code>
        </cfif>
        <cfif len(ishv.RECORD_EMP_)>
          Güncelleyen :<code>#ishv.UPDATE_EMP_#</code>
        </cfif>
    </div>
    <button type="button" onclick="SaveThisPrice()">Kaydet</button>
</cfoutput>
</cfform>
satis\cfc\hizli_satis.cfc
<script>
    function SaveThisPrice() {
        var PP_ID=document.getElementById("PP_ID").value;
        var UNIQUE_RELATION_ID=document.getElementById("UNIQUE_RELATION_ID").value;
        var EMP_ID=document.getElementById("EMP_ID").value;
        var COMP_ID=document.getElementById("company_id_0001").value;
        var PP_DATE=document.getElementById("PP_DATE").value;
        var PRICE=document.getElementById("PRICE_001").value;
        PRICE=filterNum(PRICE)
        var OTHER_MONEY=document.getElementById("OTHER_MONEY_001").value;
       var Objem={
        PP_ID:PP_ID,
        UNIQUE_RELATION_ID:UNIQUE_RELATION_ID,
        EMP_ID:EMP_ID,
        COMP_ID:COMP_ID,
        PP_DATE:PP_DATE,
        PRICE:PRICE,
        OTHER_MONEY:OTHER_MONEY
       }
        $.ajax({
    url:
      "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=AddPurchasePrice",
      data:{
        FormData:JSON.stringify(Objem)
      },
    success: function (retDat) {
      //  console.log(retDat);
     // getProjectProducts(projectId);
    },
  });  
    }
</script>