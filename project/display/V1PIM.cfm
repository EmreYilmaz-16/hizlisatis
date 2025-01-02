<cfquery name="getVirtualTree" datasource="#dsn3#">
	select *,0 AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID=1190
	UNION
	select *,1 AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN (select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID=1190 AND IS_VIRTUAL=1)
	UNION
	select *,2 AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN ( select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN (select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID=1190 AND IS_VIRTUAL=1) AND IS_VIRTUAL=1)
	UNION
	select *,3 AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN(select PRODUCT_ID  from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN ( select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN (select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID=1190 AND IS_VIRTUAL=1) AND IS_VIRTUAL=1))
	UNION
	SELECT *,4 AS SEVIYE FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID IN (select PRODUCT_ID  from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN(select PRODUCT_ID AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN ( select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN (select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID=1190 AND IS_VIRTUAL=1) AND IS_VIRTUAL=1)))
	UNION 
	select *,5 AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN(SELECT PRODUCT_ID AS SEVIYE FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID IN (select PRODUCT_ID  from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN(select PRODUCT_ID AS SEVIYE from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN ( select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID IN (select PRODUCT_ID from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT where VP_ID=1190 AND IS_VIRTUAL=1) AND IS_VIRTUAL=1))))
	ORDER BY SEVIYE ASC ,VP_ID
</cfquery>
	<cfquery name="getvirtuals" dbtype="query">
		SELECT * FROM getVirtualTree WHERE IS_VIRTUAL=1
	</cfquery>
	<cfdump var="#getvirtuals#">
	<cfquery name="ins" datasource="#dsn#" result="RES">
		INSERT INTO geciciUrun (PRODUCT_NAME) VALUES ('1190')
	</cfquery>
	<cfquery name="productInfo" datasource="#dsn3#">
		SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=1190
	</cfquery>
	<cfscript>
		var AcilanUrunler=queryNew("VP_ID,STOCK_ID,SEVIYE","INTEGER,INTEGER,INTEGER");
	</cfscript>
	<CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,18)>	
	<CFSET "A.PRODUCT_ID_1190"=K_URUN.PRODUCT_ID>
	<CFSET "A.STOCK_ID_1190"=K_URUN.STOCK_ID>
	<CFSET "A.SPECT_MAIN_LIST_1190"="">
	
	<cfset SRaRR=[{
		VP_ID=1190,
		STOCK_ID=K_URUN.STOCK_ID
	}]>
	<cfoutput query="getvirtuals">
		<cfquery name="ins" datasource="#dsn#" result="RES">
			INSERT INTO geciciUrun (PRODUCT_NAME) VALUES ('#PRODUCT_ID#')
		</cfquery>
		<cfquery name="productInfo" datasource="#dsn3#">
			SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
		</cfquery>
		<CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,18)>	
		<CFSET "A.PRODUCT_ID_#PRODUCT_ID#"=K_URUN.PRODUCT_ID>
		<CFSET "A.STOCK_ID_#PRODUCT_ID#"=K_URUN.STOCK_ID>
		<CFSET "A.SPECT_MAIN_LIST_#PRODUCT_ID#"="">
		<cfscript>
			O={
				VP_ID=PRODUCT_ID,
				STOCK_ID=K_URUN.STOCK_ID}
			arrayAppend(SRaRR,O);
		</cfscript>
	</cfoutput>
	
	<CFLOOP query="getVirtualTree">
		<CFIF isDefined("A.PRODUCT_ID_#VP_ID#")>
			<CFIF isDefined("A.PRODUCT_ID_#PRODUCT_ID#")>
				ÜRÜNÜ EKLE =<cfoutput>#evaluate("A.PRODUCT_ID_#PRODUCT_ID#")# => #evaluate("A.PRODUCT_ID_#VP_ID#")#</cfoutput> <BR>
				<cfquery name="insertTree" datasource="#dsn#">
					INSERT INTO geciciUrunAGACI(PRODUCT_ID,STOCK_ID) VALUES(#evaluate("A.PRODUCT_ID_#PRODUCT_ID#")# ,#evaluate("A.PRODUCT_ID_#VP_ID#")#)
				</cfquery>
				<cfscript>
					AgacaEkle(evaluate("A.STOCK_ID_#VP_ID#"),evaluate("A.PRODUCT_ID_#VP_ID#"),evaluate("A.STOCK_ID_#PRODUCT_ID#"),evaluate("A.PRODUCT_ID_#PRODUCT_ID#"),AMOUNT,"",QUESTION_ID)
				</cfscript>
			<CFELSE>
				ÜRÜNÜ EKLE =<cfoutput>#PRODUCT_ID# => #evaluate("A.PRODUCT_ID_#VP_ID#")#</cfoutput> <BR>
				<cfquery name="insertTree" datasource="#dsn#">
					INSERT INTO geciciUrunAGACI(PRODUCT_ID,STOCK_ID) VALUES(#PRODUCT_ID# ,#evaluate("A.PRODUCT_ID_#VP_ID#")#)				
				</cfquery>
				<cfquery name="getStokInfo" datasource="#dsn3#">
					SELECT * FROM workcube_metosan_1.STOCKS WHERE PRODUCT_ID=#PRODUCT_ID#
				</cfquery>
				<cfscript>
					AgacaEkle(evaluate("A.STOCK_ID_#VP_ID#"),evaluate("A.PRODUCT_ID_#VP_ID#"),getStokInfo.STOCK_ID,PRODUCT_ID,AMOUNT,"",QUESTION_ID)
				</cfscript>
			</CFIF>
			<CFSET "A.SPECT_MAIN_LIST_#VP_ID#" ="#evaluate('A.SPECT_MAIN_LIST_#VP_ID#')#,#evaluate("A.STOCK_ID_#VP_ID#")#">
		</CFIF>
	</CFLOOP>
	<cfdump var="#A#">
	<cfquery name="SEL" datasource="#DSN#">
		SELECT * FROM geciciUrun
	</cfquery>
	<cfquery name="SEAL" datasource="#DSN#">
		SELECT * FROM geciciUrunAGACI
	</cfquery>
	<cfloop array="#SRaRR#" item="ii">
	<cfscript>
		AddSpects(ii.STOCK_ID,evaluate("A.SPECT_MAIN_LIST_#ii.VP_ID#"))
	</cfscript>
	</cfloop>