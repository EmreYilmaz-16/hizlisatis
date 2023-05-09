<CFSET datam=deserializeJSON(attributes.FORM_DATA)>
         <cfsavecontent  variable="control5">
            <cfdump  var="#arguments#">                       
            <cfdump  var="#datam#">      
                             
            </cfsavecontent>
            <cffile action="write" file = "c:\PBS\pump_functions_UpdatePumpa.html" output="#control5#"></cffile>
<cfif datam.isPriceOffering eq 1>
   <cfquery name="UP" datasource="#datam.datasources.dsn3#">
      UPDATE PBS_OFFER_ROW_PRICE_OFFER SET PRICE_EMP=#session.ep.userid#,PRICE=#datam.OlusacakUrun.PRICE#,PRICE_MONEY='#datam.OlusacakUrun.MONEY#',IS_ACCCEPTED=1 WHERE UNIQUE_RELATION_ID='#datam.uniqRelationId#'
   </cfquery>
<cfset attributes.price_offer_from_offering=datam.OlusacakUrun.PRICE>
<cfset attributes.priceMoney_offer_from_offering=datam.OlusacakUrun.MONEY>

<cfinclude template="../includes/updateOfferFromPriceOffer.cfm">





</cfif>
         <cfquery name="ins" datasource="#datam.datasources.dsn3#" result="RESSSS">
            UPDATE VirmanProduct SET JSON_DATA='#Replace(SerializeJSON(datam),' //','')#' WHERE VIRMAN_ID=#datam.virman_id#
         </cfquery>