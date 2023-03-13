<cfcomponent>
    <cffunction name="getTreeWitStock_id">
        <cfargument name="stock_id">
        <cfargument name="dsn3">
        <cfset dsn3=arguments.dsn3>
        <cfquery name="getTree" datasource="#dsn3#">
            EXEC #dsn3#.GET_TREE_PBS #arguments.stock_id#
        </cfquery>
       <CFLOOP query="getTree">
            <cfquery name="getTree_2">

            </cfquery>
       </CFLOOP>

    </cffunction>

    <cffunction name="getSubTree">
        <cfargument name="stock_id">
        <cfargument name="dsn3">
        <cfset dsn3=arguments.dsn3>
        <cfquery name="getTree" datasource="#dsn3#">
             EXEC #dsn3#.GET_TREE_PBS #arguments.stock_id#        
        </cfquery>
    </cffunction>
</cfcomponent>