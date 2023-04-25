<cfparam name="attributes.satir" default="0">
<cfparam name="attributes.product_id" default="0">
<cfparam name="attributes.stock_id" default="0">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.brand" default="0">
<cfparam name="attributes.unit" default="0">
<cfparam name="attributes.tax" default="">
<cfparam name="attributes.cost" default="">
<cfparam name="attributes.manuel" default="">
<cfquery name="GET_PRICES" datasource="#dsn3#">
	SELECT
		CASE
			WHEN
				PURCHASESALES = 0
			THEN
				'Standart Alış'
			ELSE
				'Standart Satış'
		END AS PRICE_LIST,
		CASE
			WHEN
				IS_KDV = 0
			THEN
				PRICE
			ELSE
				PRICE_KDV
		END AS PRICE,
		PS.MONEY
	FROM
		PRICE_STANDART PS
	WHERE
		PS.PRODUCT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.product_id#"> AND
		PS.PRICESTANDART_STATUS = 1
	UNION ALL
	SELECT DISTINCT
		PC.PRICE_CAT AS PRICE_LIST,
		CASE
			WHEN
				P.IS_KDV = 0
			THEN
				P.PRICE
			ELSE
				P.PRICE_KDV
		END AS PRICE,
		P.MONEY
	FROM
		PRICE AS P,
		PRICE_CAT AS PC,
		PRODUCT_UNIT AS PU,
		STOCKS AS S
	WHERE
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		P.PRODUCT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.product_id#"> AND
		P.PRICE_CATID = PC.PRICE_CATID AND
		P.STARTDATE <= #Now()# AND 
		(
			P.FINISHDATE >= #Now()# OR
			P.FINISHDATE IS NULL
		) AND
		P.UNIT = PU.PRODUCT_UNIT_ID AND
		S.STOCK_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.stock_id#">
</cfquery>
<cfset company_name = "">
<cfif isDefined("attributes.company_id") and Len(attributes.company_id)>
	<cfquery name="getCompName" datasource="#dsn#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.company_id#">
	</cfquery>
	<cfset company_name = getCompName.FULLNAME&" ">
</cfif>
<cf_box title="Fiyat Detay" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_medium_list>
		<thead>
			<tr>
				<th>Liste</th>
				<th>Fiyat</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_PRICES">
				<tr>
					<td>#PRICE_LIST#</td>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,0,#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#MONEY#','#TLFormat(PRICE,4)#','','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(PRICE,4)#
							#MONEY#
						</a>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_medium_list>
	<cfquery name="GET_LAST_PURCHASES" datasource="#dsn2#">
		SELECT TOP 10
			I.INVOICE_ID,
			I.INVOICE_NUMBER,
			I.INVOICE_DATE,
			IR.PRICE,
			IR.PRICE_OTHER,
			IR.OTHER_MONEY,
			IR.DISCOUNT1,
			IR.DISCOUNT2, 
			IR.DISCOUNT3, 
			IR.DISCOUNT4, 
			IR.DISCOUNT5,
			IR.DISCOUNT6,
			IR.DISCOUNT7, 
			IR.DISCOUNT8, 
			IR.DISCOUNT9, 
			IR.DISCOUNT10
		FROM
			INVOICE I
			LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
		WHERE
			IR.PRODUCT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.product_id#"> AND
			IR.STOCK_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.stock_id#"> AND
			I.PURCHASE_SALES = 0 AND
			ISNULL(I.IS_IPTAL,0)= 0
			<cfif isDefined("attributes.company_id") and Len(attributes.company_id)>
				AND I.COMPANY_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.company_id#">
			</cfif>
		ORDER BY
			I.INVOICE_DATE DESC
	</cfquery>
	<cf_medium_list>
		<thead>
			<tr>
				<th colspan="5"><cfoutput>#company_name#</cfoutput>Son Alışlar</th>
			</tr>
			<tr>
				<th>Belge No</th>
				<th>Tarih</th>
				<th>Fiyat</th>
				<th>Döviz Fiyat</th>
				<th>İndirimli Fiyat</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_LAST_PURCHASES">
				<tr>
					<td><a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#INVOICE_ID#" target="_blank">#INVOICE_NUMBER#</a></td>
					<td>#DateFormat(INVOICE_DATE,"dd/mm/yyyy")#</td>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,'#TLFormat(PRICE,4)#',#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#session.ep.money#',0,'','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(PRICE,4)#
							#session.ep.money#
						</a>
					</td>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,'#TLFormat(PRICE_OTHER,4)#',#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#OTHER_MONEY#',0,'','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(PRICE_OTHER,4)#
							#OTHER_MONEY#
						</a>
					</td>
					<cfset discounted_price = PRICE>
					<cfloop from="1" to="10" index="i">
						<cfif Len(Evaluate("DISCOUNT#i#"))>
							<cfset indirim = Evaluate("DISCOUNT#i#")>
						<cfelse>
							<cfset indirim = 0>
						</cfif>
						<cfset discounted_price = discounted_price*(100-indirim)/100>
					</cfloop>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,'#TLFormat(discounted_price,4)#',#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#session.ep.money#',0,'','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(discounted_price,4)#
							#session.ep.money#
						</a>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_medium_list>
	<cfquery name="GET_LAST_SALES" datasource="#dsn2#">
		SELECT TOP 10
			I.INVOICE_ID,
			I.INVOICE_NUMBER,
			I.INVOICE_DATE,
			IR.PRICE,
			IR.PRICE_OTHER,
			IR.OTHER_MONEY,
			IR.DISCOUNT1,
			IR.DISCOUNT2, 
			IR.DISCOUNT3, 
			IR.DISCOUNT4, 
			IR.DISCOUNT5,
			IR.DISCOUNT6,
			IR.DISCOUNT7, 
			IR.DISCOUNT8, 
			IR.DISCOUNT9, 
			IR.DISCOUNT10
		FROM
			INVOICE I
			LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
		WHERE
			IR.PRODUCT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.product_id#"> AND
			IR.STOCK_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.stock_id#"> AND
			I.PURCHASE_SALES = 1 AND
			ISNULL(I.IS_IPTAL,0)= 0
			<cfif isDefined("attributes.company_id") and Len(attributes.company_id)>
				AND I.COMPANY_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.company_id#">
			</cfif>
		ORDER BY
			I.INVOICE_DATE DESC
	</cfquery>
	<cf_medium_list>
		<thead>
			<tr>
				<th colspan="5"><cfoutput>#company_name#</cfoutput>Son Satışlar</th>
			</tr>
			<tr>
				<th>Belge No</th>
				<th>Tarih</th>
				<th>Fiyat</th>
				<th>Döviz Fiyat</th>
				<th>İndirimli Fiyat</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_LAST_SALES">
				<tr>
					<td><a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#INVOICE_ID#" target="_blank">#INVOICE_NUMBER#</a></td>
					<td>#DateFormat(INVOICE_DATE,"dd/mm/yyyy")#</td>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,'#TLFormat(PRICE,4)#',#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#session.ep.money#',0,'','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(PRICE,4)#
							#session.ep.money#
						</a>
					</td>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,'#TLFormat(PRICE_OTHER,4)#',#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#OTHER_MONEY#',0,'','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(PRICE_OTHER,4)#
							#OTHER_MONEY#
						</a>
					</td>
					<cfset discounted_price = PRICE>
					<cfloop from="1" to="10" index="i">
						<cfif Len(Evaluate("DISCOUNT#i#"))>
							<cfset indirim = Evaluate("DISCOUNT#i#")>
						<cfelse>
							<cfset indirim = 0>
						</cfif>
						<cfset discounted_price = discounted_price*(100-indirim)/100>
					</cfloop>
					<td>
						<a href="javascript://" onclick="selectPrice(#attributes.satir#,'#TLFormat(discounted_price,4)#',#attributes.product_id#,#attributes.stock_id#,'#attributes.tax#','#attributes.cost#','#attributes.manuel#','#attributes.product_name#','#attributes.stock_code#','#attributes.brand#','0','','','','','#attributes.unit#','#session.ep.money#',0,'','',0,0); closeBoxDraggable('#attributes.modal_id#');">
							#TLFormat(discounted_price,4)#
							#session.ep.money#
						</a>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_medium_list>
</cf_box>