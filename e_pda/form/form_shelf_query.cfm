<style type="text/css">
.boxtext {
	text-decoration: none;
	background-color: #e6e6fe;
	margin: 0px;
	padding: 0px;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
}
.tablo {
	text-decoration: none;
	margin: 0px;
	padding: 0px;
	border-top-width: 1px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-top-color: aec7f0;
	border-right-color: aec7f0;
	border-bottom-color: aec7f0;
	border-left-color: aec7f0;
}
table,td,th,div{
    font-size:13px;
		font-weight: 600;
}
.form-title{
    font-size:13px;
}
</style>
<cfset get_barcode.recordcount = 0>
<cfparam name="attributes.add_other_barcod" default="">
<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
	<cfquery name="get_barcode" datasource="#dsn3#">
    	SELECT        
        	TOP (1) SB.STOCK_ID, 
            S.PRODUCT_ID, 
            S.STOCK_CODE, 
            S.STOCK_CODE_2, 
            S.PRODUCT_NAME
		FROM 
        	STOCKS_BARCODES AS SB INNER JOIN
        	STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID
		WHERE        
        	SB.BARCODE = '#attributes.add_other_barcod#'
    </cfquery>
    <cfif get_barcode.recordcount>
        <cfquery name="get_shelf_query" datasource="#dsn2#">
            SELECT        
                PP.SHELF_CODE, 
                PPR.AMOUNT, 
                PP.PRODUCT_PLACE_ID, 
                ISNULL((
                        SELECT        
                            REAL_STOCK
                        FROM            
                            GET_STOCK_LAST_SHELF
                        WHERE        
                            SHELF_NUMBER = PP.PRODUCT_PLACE_ID AND 
                            STOCK_ID = PPR.STOCK_ID
                ), 0) AS REAL_STOCK
            FROM            
                #dsn3_alias#.PRODUCT_PLACE AS PP LEFT OUTER JOIN
                #dsn3_alias#.PRODUCT_PLACE_ROWS AS PPR ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
            WHERE        
                PPR.STOCK_ID = 
                            (
                                SELECT        
                                    TOP (1) STOCK_ID
                                FROM            
                                    #dsn1_alias#.STOCKS_BARCODES
                                WHERE        
                                    BARCODE = '#attributes.add_other_barcod#'
                            )
            ORDER BY
                REAL_STOCK DESC
        </cfquery>
        
        <cfif isdefined('attributes.new_shelf_code') and len(attributes.new_shelf_code)>
        	<cfquery name="get_shelf" datasource="#dsn3#">
            	SELECT PRODUCT_PLACE_ID,SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND SHELF_CODE = '#attributes.new_shelf_code#'
            </cfquery>
            <cfif not get_shelf.recordcount>
				<script type="text/javascript">
                    alert("Raf Barkodu Tanımlı Değil. Tekrar Kontrol Ediniz!");
                    history.back();	
                </script>
            <cfelse>
            	
            	<!---<cfif get_shelf_query.recordcount>--->
                	
            		<cfquery name="get_product_shelf" dbtype="query">
                    	SELECT * FROM get_shelf_query WHERE SHELF_CODE = '#attributes.new_shelf_code#'
                    </cfquery>
                    <cfif not get_product_shelf.recordcount>
                    	<cfquery name="add_product_shelf" datasource="#dsn3#">
                        	INSERT INTO 
                            	PRODUCT_PLACE_ROWS
                         		(
                                PRODUCT_PLACE_ID, 
                                PRODUCT_ID, 
                                STOCK_ID, 
                                AMOUNT
                                )
							VALUES        
                            	(
                                #get_shelf.PRODUCT_PLACE_ID#,
                                #get_barcode.PRODUCT_ID#,
                                #get_barcode.STOCK_ID#,
                                1
                                )
                        </cfquery>
                    	<script type="text/javascript">
							alert("Kaydedildi!");
							window.location.href='<cfoutput>#request.self#?fuseaction=epda.prtotm_form_shelf'</cfoutput>;
						</script>
                    </cfif>
            	<!---</cfif>--->
            </cfif>
        </cfif>
    </cfif>
</cfif>
<cfform name="form_shelf_query" action="#request.self#?fuseaction=epda.prtotm_form_shelf" method="post">
  <cfinput type="hidden" name="is_form_submitted" value="1">
  <div style="width:100%">
  <table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
    <tr>
  <td>
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;
  </td>
  </tr>
    <tr class="color-list">
      <td colspan="3">
      	<table cellpadding="0" cellspacing="0" width="99%">
          <tr>
            <td nowrap="nowrap" width="20%"><strong>Barkod</strong></td>
            <td><cfinput value="#attributes.add_other_barcod#" id="add_other_barcod"  name="add_other_barcod" type="text" style="width:90px;" ></td>
            <cfif get_barcode.recordcount>
            	<td>&nbsp;&nbsp;<cfinput value="" id="new_shelf_code"  name="new_shelf_code" type="text" style="width:70px;" ></td>
          	</cfif>
          </tr>
        </table>
      </td>
    </tr>
    <cfif get_barcode.recordcount gt 0>
    	<tr class="color-list">
      		<td colspan="3" align="center" valign="middle">
            	<cfoutput>#get_barcode.product_name#</cfoutput>
            </td>
      	</tr>
    </cfif>
    <tr class="color-list">
      <td width="60%" align="center"><strong>Raf Kodu</strong></td>
      <td width="20%" align="center"><strong>Kapasite</strong></td>
      <td width="20%" align="center"><strong>Mevcut</strong></td>
    </tr>
    <cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
    	<cfif get_barcode.recordcount>
			<cfif get_shelf_query.recordcount>
                <cfoutput query="get_shelf_query">
                <tr class="color-list">
                  <td align="center">#SHELF_CODE#</td>
                  <td align="right">#AMOUNT#</td>
                  <td align="right">#REAL_STOCK#</td> 
                </tr>
                </cfoutput>
            <cfelse>
                <tr class="color-list">
                  <td colspan="3" align="left">Raf Bulunamadı</td> 
                </tr>
            </cfif>
     	<cfelse>
        	<tr class="color-list">
             	<td colspan="3" align="left">Ürün Barkodu Kayıtlı Değil</td> 
          	</tr>
        </cfif>
    <cfelse>
    	<tr class="color-list">
          <td colspan="3" align="left">Ürün Borkodu Okutun</td> 
        </tr>
    </cfif>
    <tr class="color-list">
     	<td colspan="3" align="right">
        	<cfinput type="button" value="Yeni" name="yeni" onClick="yeniden_ara();">
            <cfif not isdefined('attributes.is_form_submitted') or get_barcode.recordcount>
        		<cfinput type="submit" value="Ara" name="ara">
           	</cfif>
        </td> 
  	</tr>
  </table>
  </div>
</cfform>
<script language="javascript" type="text/javascript">
	<cfif isdefined('attributes.is_form_submitted') and get_barcode.recordcount gt 0>
		document.getElementById('new_shelf_code').focus();
		setTimeout("document.getElementById('new_shelf_code').select();",1000);
	<cfelse>
		document.getElementById('add_other_barcod').focus();
		setTimeout("document.getElementById('add_other_barcod').select();",1000);
	</cfif>
	function yeniden_ara()
	{
		window.location.href='<cfoutput>#request.self#?fuseaction=epda.prtotm_form_shelf'</cfoutput>;
	}
</script>