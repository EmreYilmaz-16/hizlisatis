<cfparam name="attributes.barcode" default="">
<cfparam name="attributes.isSubmit" default="0">
<cfoutput>
<h3>Barkod  : 
<cfif attributes.barcode neq "" >
#attributes.barcode#
</cfif>
</h3>
<hr>
</cfoutput>
        <cfform method="post" action="#request.self#?fuseaction=pda.Stock_location_partner">
            <table>
                <tr>
                    <td>
                        Barkod
                    </td>
                    <td>
                        <input onclick="this.value=''" value="<cfoutput>#attributes.barcode#</cfoutput>" id="barcode" type="text" name="barcode">
                    </td>
                    <td>
                        <input type="submit">
                        <input type="hidden" name="isSubmit" value="1">
                    </td>

                </tr>
            </table>
        </cfform>
        <cfif attributes.isSubmit eq 1>
        <cfquery name="GetDepartment" datasource="#dsn#">
        select * from PRTOTM_PDA_DEPARTMENT_DEFAULTS where EPLOYEE_ID =#session.ep.USERID#
        </cfquery>
        <cfset x1 = listGetAt(GetDepartment.DEFAULT_RF_TO_SV_DEP, 1)>
        <cfset TotStok=0>
            <cfquery name="GetStokLocation" datasource="#dsn3#">
                        SELECT GTSL.TOTAL_STOCK
                        
                    ,GTSL.COMMENT
                    ,(
                        SELECT DEPARTMENT_HEAD
                        FROM #dsn#.DEPARTMENT AS DEPT
                        WHERE DEPT.DEPARTMENT_ID = GTSL.DEPARTMENT_ID
                        ) AS DEPARTMAN
                        ,BARCOD
                        ,STOCK_ID
                        ,DEPARTMENT_ID
		                ,STORE_LOCATION
                FROM #dsn2#.GET_STOCK_LOCATION_Partner AS GTSL
                WHERE BARCOD='#attributes.barcode#' 
                        AND GTSL.DEPARTMENT_ID=#x1# 
                        AND GTSL.TOTAL_STOCK >0
            </cfquery>    
            <cf_medium_list style="width:100%">
                <tr>
                    <th>
                        Lokasyon
                    </th>
                    <th>
                        Stok Miktarı
                    </th>
                </tr>
                <cfoutput query="GetStokLocation">
<cfquery name="getRaf" datasource="#dsn3#">
    SELECT * FROM #dsn2#.GET_STOCK_SHELF GSS,
            #dsn3#.PRODUCT_PLACE AS PP 
    WHERE  STOCK_ID=#GetStokLocation.STOCK_ID# 
            AND GSS.SHELF_ID=PP.PRODUCT_PLACE_ID
            AND STORE_ID= #GetStokLocation.DEPARTMENT_ID# 
            AND LOCATION_ID=#GetStokLocation.STORE_LOCATION# 
</cfquery>
                  <tr>
                    <td>
                        #DEPARTMAN# - #COMMENT#
                    </td>
                    <td align="right">
                        #TOTAL_STOCK#
			            <cfset TotStok=TotStok+TOTAL_STOCK>
                    </td>
                   </tr>
                   <cfif getRaf.recordcount gt 0>
                   <cfloop query="getRaf">
                         <tr>
                            <td style="border-bottom:solid 2px black"><span style="font-weight:bold;font-size:14pt;color:blue;">&nbsp;&nbsp;»&nbsp;</span>#getRaf.SHELF_CODE#</td>
                            <td style="border-bottom:solid 2px black">#getRaf.PRODUCT_STOCK#</td>
                         </tr>
                   </cfloop>             
                   </cfif>
                </cfoutput>
                   <tr>
                      <td style="border-top:solid 1px #6699cc" align="right">
                         <span style="color:red">
                           <b>Toplam Stok = </b>
                         </span>
                      </td>
                      <td align="right" style="border-top:solid 1px #6699cc">
                        <span style="color:red"> 
                            <b>
                                <cfoutput>
                                #TotStok#
                                </cfoutput> 
                            </b>
                        </span>
                      </td>
                  </tr>
              </cf_medium_list>
        </cfif>
<script>
document.getElementById("barcode").focus()

function OnclickClear(){
document.getElementById("barcode").val="";
}
</script>
