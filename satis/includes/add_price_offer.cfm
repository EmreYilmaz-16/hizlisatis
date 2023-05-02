
<cfquery name="ishvprodorders" datasource="#dsn3#">
	SELECT * FROM PBS_OFFER_ROW_PRICE_OFFER WHERE UNIQUE_RELATION_ID='#evaluate("attributes.row_unique_relation_id#i#")#'
</cfquery>


<cfif not ishvprodorders.recordcount and evaluate("attributes.PBS_OFFER_ROW_CURRENCY#i#") eq 1>
    <!----	TABLE workcube_metosan_1.PBS_OFFER_ROW_PRICE_OFFER
		(ID INT PRIMARY KEY IDENTITY(1,1),UNIQUE_RELATION_ID INT,PRICE_EMP NVARCHAR(150) ,PRICE FLOAT,PRICE_MONEY NVARCHAR(50),IS_ACCCEPTED BIT)---->
    <cfquery name="Ins" datasource="#dsn3#">
        INSERT INTO PBS_OFFER_ROW_PRICE_OFFER(UNIQUE_RELATION_ID,IS_ACCCEPTED) VALUES('#evaluate("attributes.row_unique_relation_id#i#")#',0)
    </cfquery>
</cfif>