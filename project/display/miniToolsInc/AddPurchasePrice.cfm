<cfquery name="ishv" datasource="#dsn3#">
    SELECT PP_ID,UNIQUE_RELATION_ID,COMPANY_ID,COMPANY_ID,PRICE,OTHER_MONEY,PRICE_OTHER,PP_DATE,RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PBS_OFFER_ROW_PURCHASE_PRICES WHERE UNIQUE_RELATION_ID='#attributes.uniq_id#'
</cfquery>
<cfform name="Notorder_form">
<cfoutput>
    <input type="hidden" name="PP_ID" id="PP_ID" value="#ishv.PP_ID#">
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
                    <input type="text" name="PRICE_001" id="PRICE_001" value="#ishv.PRICE#">
                </div>
            </td>
            <td>
                <div class="form-group">
                    <select name="OTHER_MONEY_001" id="OTHER_MONEY_001">

                    </select>
                </div>
                
            </td>
        </tr>
    </table>
</cfoutput>
</cfform>

<script>
    $(document).ready(function (params) {
        for (let index = 0; index < moneyArr.length; index++) {
            const element = array[index];
            var opt=document.createElement("option")
            opt.value=element.MONEY;
            opt.innerText=element.MONEY
            document.getElementById("OTHER_MONEY_001").appendChild(opt)
        }
    })
</script>
