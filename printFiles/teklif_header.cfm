<cfquery name="Our_Company" datasource="#dsn#">
    SELECT 
        ASSET_FILE_NAME3,
        ASSET_FILE_NAME3_SERVER_ID,
        COMPANY_NAME,
        TEL_CODE,
        TEL,TEL2,
        TEL3,
        TEL4,
        FAX,
        TAX_OFFICE,
        TAX_NO,
        ADDRESS,
        WEB,
        EMAIL
    FROM 
        OUR_COMPANY 
    WHERE 
    <cfif isDefined("SESSION.EP.COMPANY_ID")>
        COMP_ID = #SESSION.EP.COMPANY_ID#
    <cfelseif isDefined("SESSION.PP.COMPANY")>	
        COMP_ID = #SESSION.PP.COMPANY#
    </cfif>
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
        ASSET_FILE_NAME2,
        ASSET_FILE_NAME2_SERVER_ID,
        COMPANY_NAME
    FROM 
        OUR_COMPANY 
    WHERE 
        <cfif isdefined("attributes.our_company_id")>
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
        <cfelse>
            <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
                COMP_ID = #session.ep.company_id#
            <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
                COMP_ID = #session.pp.company_id#
            <cfelseif isDefined("session.ww.our_company_id")>
                COMP_ID = #session.ww.our_company_id#
            <cfelseif isDefined("session.cp.our_company_id")>
                COMP_ID = #session.cp.our_company_id#
            </cfif> 
        </cfif> 
</cfquery>
<cfif isDefined('attributes.OFFER_ID')>
    <cfquery name="Get_Offer" datasource="#DSN#">
    SELECT
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_EMAIL,	
            PP.PROJECT_HEAD,
            PP.PROJECT_NUMBER,
            PP.PROJECT_ID,
            O.*
        FROM 
            #DSN3#.PBS_OFFER O , 
            workcube_metosan.EMPLOYEES E,
            workcube_metosan.PRO_PROJECTS AS PP 
        WHERE 
            O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
            E.EMPLOYEE_ID = O.RECORD_MEMBER AND
            PP.PROJECT_ID=O.PROJECT_ID
       
    </cfquery>
</cfif>
<cfset Member_Code = "">
    <cfset Member_Name = "">
    <cfset Member_Mail = "">
    <cfset Member_TaxOffice = "">
    <cfset Member_TaxNo = "">
    <cfset Member_TelCode = "">
    <cfset Member_Tel = "">
    <cfset Member_Fax = "">
    <cfset Member_Address = "">
    <cfset Member_Semt = "">
    <cfset Member_County = "">
    <cfset Member_City = "">
    <cfset Member_Country = "">
    <cfif isdefined("Get_Offer.Company_Id") and Len(Get_Offer.Company_Id)>
        <cfquery name="Get_Member_Info" datasource="#dsn#">
            SELECT
                COMPANY_ID MEMBER_ID,
                MEMBER_CODE MEMBER_CODE,
                FULLNAME MEMBER_NAME,
                COMPANY_EMAIL MEMBER_EMAIL,
                TAXOFFICE MEMBER_TAXOFFICE,
                TAXNO MEMBER_TAXNO,
                COMPANY_TELCODE MEMBER_TELCODE,
                COMPANY_TEL1 MEMBER_TEL,
                COMPANY_FAX MEMBER_FAX,
                COMPANY_ADDRESS MEMBER_ADDRESS,
                SEMT MEMBER_SEMT,
                COUNTY MEMBER_COUNTY,
                CITY MEMBER_CITY,
                COUNTRY MEMBER_COUNTRY
            FROM
                COMPANY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Company_Id#">
        </cfquery>
    <cfelseif isdefined("Get_Offer.Consumer_Id") and Len(Get_Offer.Consumer_Id)>
        <cfquery name="Get_Member_Info" datasource="#dsn#">
            SELECT
                CONSUMER_ID MEMBER_ID,
                MEMBER_CODE MEMBER_CODE,
                CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
                CONSUMER_EMAIL MEMBER_EMAIL,
                TAX_OFFICE MEMBER_TAXOFFICE,
                TAX_NO MEMBER_TAXNO,
                CONSUMER_WORKTELCODE MEMBER_TELCODE,
                CONSUMER_WORKTEL MEMBER_TEL,
                CONSUMER_FAXCODE + '' + CONSUMER_FAX MEMBER_FAX,
                WORKADDRESS MEMBER_ADDRESS,
                WORKSEMT MEMBER_SEMT,
                WORK_COUNTY_ID MEMBER_COUNTY,
                WORK_CITY_ID MEMBER_CITY,
                WORK_COUNTRY_ID MEMBER_COUNTRY
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Consumer_Id#">
        </cfquery>
    </cfif>
    <cfif len(Get_Offer.PROJECT_ID)>
    <cfquery name="getProject" datasource="#dsn#">
        SELECT PROJECT_NUMBER,PROJECT_HEAD,SMC.MAIN_PROCESS_CAT,PP.PROJECT_EMP_ID FROM workcube_metosan.PRO_PROJECTS AS PP
INNER JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
WHERE PP. PROJECT_ID=#Get_Offer.PROJECT_ID#
    </cfquery>
    <cfelse>
        <cfset getProject.PROJECT_NUMBER = "">
        <cfset getProject.PROJECT_HEAD = "">
        <cfset getProject.MAIN_PROCESS_CAT = "">
        <cfset getProject.PROJECT_EMP_ID = "">
        
    </cfif>
    <cfif isdefined("Get_Member_Info") and Get_Member_Info.RecordCount>
        <cfset Member_Code = Get_Member_Info.Member_Code>
        <cfset Member_Name = Get_Member_Info.Member_Name>
        <cfset Member_Mail = Get_Member_Info.Member_Email>
        <cfset Member_TaxOffice = Get_Member_Info.Member_TaxOffice>
        <cfset Member_TaxNo = Get_Member_Info.Member_TaxNo>
        <cfset Member_TelCode = Get_Member_Info.Member_TelCode>
        <cfset Member_Tel = Get_Member_Info.Member_Tel>
        <cfset Member_Fax = Get_Member_Info.Member_Fax>
        <cfset Member_Address = Get_Member_Info.Member_Address>
        <cfset Member_Semt = Get_Member_Info.Member_Semt>
        
        <cfif Len(Get_Member_Info.Member_County)>
            <cfquery name="Get_County_Name" datasource="#dsn#">
                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_County#">
            </cfquery>
            <cfset Member_County = Get_County_Name.County_Name>
        </cfif>
        <cfif Len(Get_Member_Info.Member_City)>
            <cfquery name="Get_City_Name" datasource="#dsn#">
                SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_City#">
            </cfquery>
            <cfset Member_City = Get_City_Name.City_Name>
        </cfif>
        <cfif Len(Get_Member_Info.Member_Country)>
            <cfquery name="Get_Country_Name" datasource="#dsn#">
                SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_Country#">
            </cfquery>
            <cfset Member_Country = Get_Country_Name.Country_Name>
        </cfif>
    </cfif>
    <cfif Len(Get_Offer.Partner_id)>
        <cfquery name="Get_Partner" datasource="#dsn#">
            SELECT COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME PARTNER_NAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Partner_id#">
        </cfquery>
        <cfset Partner_Name = Get_Partner.Partner_Name>
    <cfelse>
        <cfset Partner_Name = ''>
    </cfif>
    <cfif Len(Get_Offer.Ship_Method)>
        <cfquery name="Get_Ship_Method" datasource="#dsn#">
            SELECT
                SHIP_METHOD_ID,
                SHIP_METHOD
            FROM
                SHIP_METHOD
            WHERE 
                SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Ship_Method#">
        </cfquery>
    </cfif>
    <cfquery name="Get_Upper_Position" datasource="#dsn#">
        SELECT * FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfif len (Get_Upper_Position.Upper_Position_Code)>
        <cfquery name="Get_Chief1_Name" datasource="#dsn#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Upper_Position.Upper_Position_Code#">
        </cfquery>
    </cfif>
    <cfquery name="Get_Offer_Plus" datasource="#dsn3#">
        SELECT
            PROPERTY1 AS EPOSTA,
            PROPERTY2 AS ILGILI,
            PROPERTY3 AS NOTLAR,
            PROPERTY4 AS TESLIM,
            PROPERTY5 AS ODEME,
            PROPERTY6 AS OPSIYON,
            PROPERTY7 AS ACIKLAMA
            
        FROM
            PBS_OFFER_INFO_PLUS
        WHERE
            PBS_OFFER_INFO_PLUS.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    </cfquery>
    <cfif len(Get_Offer.Sales_Emp_Id)>
        <cfquery name="Get_Offer_Sales_Member" datasource="#dsn#">
            SELECT
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS FULLNAME,
                EP.POSITION_NAME,
                E.EMPLOYEE_EMAIL, 
                E.MOBILTEL,
                E.MOBILCODE
            FROM
                EMPLOYEES E
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getProject.PROJECT_EMP_ID#">
        </cfquery>
    </cfif>

    <cfquery name="Get_Money" datasource="#dsn3#">
        SELECT * FROM PBS_OFFER_MONEY WHERE ACTION_ID = #attributes.offer_id#
    </cfquery>
    <cfloop query="Get_Money">
        <cfset "Offer_Money_#Get_Money.Money_Type#" = Get_Money.Rate2>
    </cfloop>

    <cfquery name="Get_Money_Choose" dbtype="query">
        SELECT * FROM Get_Money WHERE IS_SELECTED = 1
    </cfquery>
    <cfset Offer_Money = Get_Money_Choose.Money_Type>