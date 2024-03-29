﻿
<cfparam name="attributes.price_catid" default="0">
<cfparam name="attributes.comp_id" default="0">
<cffunction name="getQuestionWithId">
    <cfargument name="QuestionId">
    <cfquery name="getQ" datasource="#dsn3#">
        SELECT * FROM VIRTUAL_PRODUCT_TREE_QUESTIONS WHERE QUESTION_ID=#arguments.QuestionId#
    </cfquery>
    <CFSET RET.QNAME=getQ.QUESTION>
    <CFSET RET.REQ=getQ.IS_REQUIRED>
    <cfreturn RET>
</cffunction>

<cf_box title="Make Tube" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfform name="TubeForm">

    <cfoutput>
    <div class="form-group">
        <label>Uretim</label>
        <input type="checkbox" name="IsProduction" checked value="1">
    </div>
    <div class="form-group">
        <label>Hortum Grubu</label>
        <input type="text" name="PRODUCT_CAT" id="PRODUCT_CAT" readonly value="">
        <input type="hidden" name="PRODUCT_CATID" id="PRODUCT_CATID" value="">
        <input type="hidden" name="HIEARCHY" id="HIEARCHY" value="">
    </div>

    <div class="form-group">
    <label style="width: 100%;">Sol Rekor</label>
    <input data-type="LRekor" type="text" name="LRekor" id="LRekor" onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)" style="width: 80%!important;" placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"> 
    
    <input type="text" name="LRekor_Qty" id="LRekor_Qty" style="width: 15% !important;padding-right: 1px;text-align:right" value="#tlformat(1)#" onkeyup="calculateTubeRow(this)">
    <input type="hidden" name="LRekor_PId" id="LRekor_PId">
    <input type="hidden" name="LRekor_SId" id="LRekor_SId">
    <input type="hidden" name="LRekor_Prc" id="LRekor_Prc" value="0">
    <label style="width: 100%;font-size:6pt;color:red" id="LRekor_lbs"></label>
</div>

<div class="form-group">
    <label style="width: 100%;">Tube</label>
    <input data-type="Tube" type="text" name="Tube" id="Tube"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)" style="width: 80%!important;" placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">
    <input type="text" name="Tube_Qty" id="Tube_Qty" style="width: 15% !important;padding-right: 1px;text-align:right" value="#tlformat(1)#" onkeyup="calculateTubeRow(this)">
    <input type="hidden" name="Tube_PId" id="Tube_PId">
    <input type="hidden" name="Tube_SId" id="Tube_SId">
    <input type="hidden" name="Tube_Prc" id="Tube_Prc" value="0">
    <label style="width: 100%;font-size:6pt;color:red" id="Tube_lbs"></label>
</div>

<div class="form-group">
    <label style="width: 100%;">Sağ Rekor</label>
    <input  data-type="RRekor" type="text" name="RRekor" id="RRekor"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)" style="width: 80%!important;" placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">
    <input type="text" name="RRekor_Qty" id="RRekor_Qty" style="width: 15% !important;padding-right: 1px;text-align:right" value="#tlformat(1)#" onkeyup="calculateTubeRow(this)">
    <input type="hidden" name="RRekor_PId" id="RRekor_PId">
    <input type="hidden" name="RRekor_SId" id="RRekor_SId">
    <input type="hidden" name="RRekor_Prc" id="RRekor_Prc" value="0">
    <label style="width: 100%;font-size:6pt;color:red" id="RRekor_lbs"></label>
</div>

<div class="form-group">
    <label style="width: 100%;">Kabuk</label>
    <input  data-type="Kabuk" type="text" name="Kabuk" id="Kabuk"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)" style="width: 80%!important;" placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">
    <input type="text" name="Kabukr_Qty" id="Kabuk_Qty" style="width: 15% !important;padding-right: 1px;text-align:right" value="#tlformat(1)#" onkeyup="calculateTubeRow(this)">
    <input type="hidden" name="Kabuk_PId" id="Kabuk_PId">
    <input type="hidden" name="Kabuk_SId" id="Kabuk_SId">
    <input type="hidden" name="Kabuk_Prc" id="Kabuk_Prc" value="0">
    <label style="width: 100%;font-size:6pt;color:red" id="Kabuk_lbs"></label>
</div>

<div class="form-group">
    <label style="width: 100%;">Ek Malzeme</label>
    <input data-type="AdditionalProduct" type="text" name="AdditionalProduct" id="AdditionalProduct"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)" style="width: 80%!important;" placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">
    <input type="text" name="AdditionalProduct_Qty" id="AdditionalProduct_Qty" style="width: 15% !important;padding-right: 1px;text-align:right" value="#tlformat(1)#" onkeyup="calculateTubeRow(this)">
    <input type="hidden" name="AdditionalProduct_PId" id="AdditionalProduct_PId">
    <input type="hidden" name="AdditionalProduct_SId" id="AdditionalProduct_SId">
    <input type="hidden" name="RRekor_Prc" id="AdditionalProduct_Prc" value="0">
    <label style="width: 100%;font-size:6pt;color:red" id="AdditionalProduct_lbs"></label>
</div>
<div class="form-group">
    <label style="width: 100%;">İşçilik</label>
    <input  data-type="working" type="text" name="working" id="working"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)" style="width: 80%!important;" placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">
    <input type="text" name="working_Qty" id="working_Qty" style="width: 15% !important;padding-right: 1px;text-align:right" value="#tlformat(1)#" onkeyup="calculateTubeRow(this)">
    <input type="hidden" name="working_PId" id="working_PId">
    <input type="hidden" name="working_SId" id="working_SId">
    <input type="hidden" name="working_Prc" id="working_Prc" value="0">
    <label style="width: 100%;font-size:6pt;color:red" id="working_lbs"></label>
</div>

<hr>
<table>
    <tr>
        <td>
            <div class="form-group" id="f1" title="Maliyet">
                <label>Marj %</label>
                <input data-type="maliyet" type="text" name="marj" id="marj"  style="padding-right: 1px;text-align:right" value="#tlformat(0)#" onkeyup="CalculateTube()">    
            </div>
        </td>
        <td>
            <div class="form-group" id="f1" title="Maliyet">
                <label>Hesaplan Maliyet</label>
                <input data-type="maliyet" type="text" name="maliyet" id="maliyet"  style="padding-right: 1px;text-align:right" value="#tlformat(0)#" readonly>    
            </div>
        </td>
    </tr>
</table>
<br>
<div style="display:flex;justify-content: space-around;align-items: center;align-content: space-between;flex-wrap: nowrap;">
<button type="button" onclick="saveVirtualTube('#dsn3#','#attributes.modal_id#')" class="btn btn-primary">Save Virtual Tube</button>
<button type="button" onclick="SaveTube('#dsn3#','#attributes.modal_id#')" class="btn btn-success">Save  Tube</button>
<button type="button" onclick="closeBoxDraggable('#attributes.modal_id#')" class="btn btn-danger">Kapat</button>
</div>
</cfoutput>
</cfform>
</cf_box>
