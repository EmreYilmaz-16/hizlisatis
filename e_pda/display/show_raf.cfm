<cf_box title="Raf Görüntüle">
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
  <div style="margin-left:auto;margin-right:auto">
    <input type="text" name="barcode" style="font-size:16pt">
    <input type="hidden" name="is_submit">
</div>
</cfform>

<cfif isDefined("attributes.is_submit")>
    <cfquery name="getRafs" datasource="#dsn3#">
    SELECT PRODUCT_PLACE.SHELF_CODE,PRODUCT_PLACE.PRODUCT_PLACE_ID,PRODUCT_PLACE_ROWS.STOCK_ID
FROM #dsn3#.PRODUCT_PLACE_ROWS
LEFT JOIN #dsn3#.PRODUCT_PLACE ON PRODUCT_PLACE.PRODUCT_PLACE_ID = PRODUCT_PLACE_ROWS.PRODUCT_PLACE_ID
WHERE PRODUCT_PLACE_ROWS.PRODUCT_ID IN (
		SELECT PRODUCT_ID
		FROM #dsn3#.STOCKS
		WHERE 1 = 1
			AND (
				PRODUCT_CODE = '#attributes.barcode#'
				OR PRODUCT_CODE_2 = '#attributes.barcode#'
				OR PRODUCT_BARCOD = '#attributes.barcode#'
				)
		)
    
   
    </cfquery>
    <cfoutput query="getRafs">
      <cfquery NAME="GETSMOUN" datasource="#DSN2#">
          select * from GET_STOCK_SHELF where STOCK_ID=#STOCK_ID# and SHELF_ID=#PRODUCT_PLACE_ID#
      </cfquery>
       <p style="font-size:12pt;border-bottom:solid 1px"> #SHELF_CODE# (#GETSMOUN.PRODUCT_STOCK#)</p>
    </cfoutput>
</cfif>
</cf_box>